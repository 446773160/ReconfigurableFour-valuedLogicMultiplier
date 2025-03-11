module W_trans #(
        parameter p = 33
    ) (
        input            clk,
        input            rst_n,
        input  [2*p-1:0] a,
        input  [2*p-1:0] b,
        output [2*p+1:0] w
    );

    genvar i;
    generate
        for (i = 0; i < p; i = i + 1) begin
            W_trans_module u_W_trans_module (clk, rst_n, a[2*i+1:2*i], b[2*i+1:2*i], w[2*i+1:2*i]);
        end
    endgenerate

    assign w[2*p+1:2*p] = 2'b01;

endmodule
