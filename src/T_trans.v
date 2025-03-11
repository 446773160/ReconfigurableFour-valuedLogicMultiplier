module T_trans #(
        parameter p = 33
    ) (
        input            clk,
        input            rst_n,
        input  [2*p-1:0] a,
        input  [2*p-1:0] b,
        output [2*p+1:0] t
    );

    genvar i;
    generate
        for (i = 0; i < p; i = i + 1) begin
            T_trans_module  u_T_trans_module  (clk, rst_n, a[2*i+1:2*i], b[2*i+1:2*i], t[2*i+3:2*i+2]);
        end
    endgenerate

    assign t[1:0] = 2'b01;

endmodule
