module MSD_Mult #(
        parameter X = 33,
        parameter Y = 33
    )(
        input clk,
        input rst_n,
        input [2*X-1:0] in1,
        input [2*Y-1:0] in2,
        output [2*X+2*Y+21:0] result
    );

    wire [2*X+2*Y-3:0] partial_sums[Y-1:0];
    wire [2*X-1:0]      temp[Y-1:0];
    genvar idx;
    generate
        for (idx = 0; idx < Y; idx = idx + 1) begin : PART_GEN
            Transform #(X) u_transform (clk, rst_n, in1, in2[2*idx+1:2*idx], temp[idx]);
        end
    endgenerate

    genvar jdx;
    generate
        for (jdx = 1; jdx < Y; jdx = jdx + 1) begin : SUM_GEN
            assign partial_sums[jdx] = {{(Y-jdx-1){2'b10}}, temp[jdx], {jdx{2'b10}}};
        end
        assign partial_sums[0] = {{32{2'b10}}, temp[0]};
    endgenerate

    wire [2*X+2*Y+1:0] sum_lvl1[16:0];
    wire [2*X+2*Y+5:0] sum_lvl2[8:0];
    wire [2*X+2*Y+9:0] sum_lvl3[4:0];
    wire [2*X+2*Y+13:0] sum_lvl4[2:0];
    wire [2*X+2*Y+17:0] sum_lvl5;
    wire [2*X+2*Y+21:0] final_sum;
    
    genvar lvl1;
    generate
        for (lvl1 = 0; lvl1 < 16; lvl1 = lvl1 + 1) begin : ADD_LVL1
            MSD_Adder #(X+Y-1) add1 (clk, rst_n, partial_sums[lvl1], partial_sums[16 + lvl1], sum_lvl1[lvl1]);
        end
        MSD_Adder #(X+Y-1) add1_extra (clk, rst_n, partial_sums[32], {65{2'b10}}, sum_lvl1[16]);
    endgenerate

    genvar lvl2;
    generate
        for (lvl2 = 0; lvl2 < 8; lvl2 = lvl2 + 1) begin : ADD_LVL2
            MSD_Adder #(X+Y+1) add2 (clk, rst_n, sum_lvl1[lvl2], sum_lvl1[8 + lvl2], sum_lvl2[lvl2]);
        end
        MSD_Adder #(X+Y+1) add2_extra (clk, rst_n, sum_lvl1[16], {67{2'b10}}, sum_lvl2[8]);
    endgenerate

    genvar lvl3;
    generate
        for (lvl3 = 0; lvl3 < 4; lvl3 = lvl3 + 1) begin : ADD_LVL3
            MSD_Adder #(X+Y+3) add3 (clk, rst_n, sum_lvl2[lvl3], sum_lvl2[4 + lvl3], sum_lvl3[lvl3]);
        end
        MSD_Adder #(X+Y+3) add3_extra (clk, rst_n, sum_lvl2[8], {69{2'b10}}, sum_lvl3[4]);
    endgenerate

    genvar lvl4;
    generate
        for (lvl4 = 0; lvl4 < 2; lvl4 = lvl4 + 1) begin : ADD_LVL4
            MSD_Adder #(X+Y+5) add4 (clk, rst_n, sum_lvl3[lvl4], sum_lvl3[2 + lvl4], sum_lvl4[lvl4]);
        end
        MSD_Adder #(X+Y+5) add4_extra (clk, rst_n, sum_lvl3[4], {71{2'b10}}, sum_lvl4[2]);
    endgenerate

    MSD_Adder #(X+Y+7) add5 (clk, rst_n, sum_lvl4[0], sum_lvl4[1], sum_lvl5);
    MSD_Adder #(X+Y+9) add6 (clk, rst_n, {4'b1010, sum_lvl4[2]}, sum_lvl5, final_sum);

    assign result = final_sum;

endmodule
