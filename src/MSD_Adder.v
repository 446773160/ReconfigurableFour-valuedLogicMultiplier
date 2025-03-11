module MSD_Adder #(
        parameter p = 33
    ) (
        input clk,
        input rst_n,
        input [2*p-1:0] a,
        input [2*p-1:0] b,
        output [2*p+3:0] o
    );

    wire [2*p+1:0] t1, w1;
    T_trans #(p) u_T_trans (clk, rst_n, a, b, t1);
    W_trans #(p) u_W_trans (clk, rst_n, a, b, w1);

    wire [2*p+3:0] t2, w2;
    T1_trans #(p+1) u_T1_trans (clk, rst_n, t1, w1, t2);
    W1_trans #(p+1) u_W1_trans (clk, rst_n, t1, w1, w2);

    wire [2*p+5:0] t3;
    T_trans #(p+2) u_T_trans_2 (clk, rst_n, t2, w2, t3);

    assign o = t3[2*p+5:2];

endmodule
