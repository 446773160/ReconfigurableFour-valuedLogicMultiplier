module MSD_Multiplier #(
        parameter p = 33,
        parameter q = 33
    )(
        input clk,
        input rst_n,
        input [2*p-1:0] a,
        input [2*q-1:0] b,
        output [2*p+2*q+21:0] o
    );

    wire [2*p+2*q-3:0] partial_sum[q-1:0];
    wire [    2*p-1:0]           m[q-1:0];
    genvar i;
    generate
        for (i = 0; i < q; i = i + 1) begin : M_trans
            M_trans #(p) u_M_trans (clk, rst_n, a, b[2*i+1:2*i], m[i]);
        end
    endgenerate

    genvar j;
    generate
        for (j = 1; j < q; j = j + 1) begin : S2P
            assign partial_sum[j] = {{(q-j-1){2'b01}}, m[j], {j{2'b01}}};//(0 + m[j]) << (2*j);
        end
        assign partial_sum[0] = {{32{2'b01}},  m[0]};
    endgenerate

    wire [2*p+2*q+1:0] sum1[16:0];
    wire [2*p+2*q+5:0] sum2[8:0];
    wire [2*p+2*q+9:0] sum3[4:0];
    wire [2*p+2*q+13:0] sum4[2:0];
    wire [2*p+2*q+17:0] sum5;
    wire [2*p+2*q+21:0] sum_out;
    genvar i1;
    generate
        for (i1 = 0; i1 < 16; i1 = i1 + 1) begin : ADD1
            MSD_Adder #(p+q-1) u1_adder (clk, rst_n, partial_sum[i1], partial_sum[16 + i1], sum1[i1]);
        end
        MSD_Adder #(p+q-1) u1_adder (clk, rst_n, partial_sum[32], {65{2'b01}}, sum1[16]);
    endgenerate

    genvar i2;
    generate
        for (i2 = 0; i2 < 8; i2 = i2 + 1) begin : ADD2
            MSD_Adder #(p+q+1) u2_adder (clk, rst_n, sum1[i2], sum1[8 + i2], sum2[i2]);
        end
        MSD_Adder #(p+q+1) u2_adder (clk, rst_n, sum1[16], {67{2'b01}}, sum2[8]);
    endgenerate

    genvar i3;
    generate
        for (i3 = 0; i3 < 4; i3 = i3 + 1) begin : ADD3
            MSD_Adder #(p+q+3) u3_adder (clk, rst_n, sum2[i3], sum2[4 + i3], sum3[i3]);
        end
        MSD_Adder #(p+q+3) u3_adder (clk, rst_n, sum2[8], {69{2'b01}}, sum3[4]);
    endgenerate

    genvar i4;
    generate
        for (i4 = 0; i4 < 2; i4 = i4 + 1) begin : ADD4
            MSD_Adder #(p+q+5) u4_adder (clk, rst_n, sum3[i4], sum3[2 + i4], sum4[i4]);
        end
        MSD_Adder #(p+q+5) u4_adder (clk, rst_n, sum3[4], {71{2'b01}}, sum4[2]);
    endgenerate

    MSD_Adder #(p+q+7) u5_adder (clk, rst_n, sum4[0], sum4[1], sum5);
    MSD_Adder #(p+q+9) u6_adder (clk, rst_n, {4'b0101, sum4[2]}, sum5, sum_out);

    assign o = sum_out;

endmodule
