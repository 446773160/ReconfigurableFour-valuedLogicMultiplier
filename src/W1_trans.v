module W1_trans #(
        parameter p = 33
    ) (
        input            clk,
        input            rst_n,
        input  [2*p-1:0] a,
        input  [2*p-1:0] b,
        output [2*p+1:0] w1
    );

    genvar i;
    generate
        for (i = 0; i < p; i = i + 1) begin
            W1_trans_module u_W1_trans_module (clk, rst_n, a[2*i+1:2*i], b[2*i+1:2*i], w1[2*i+1:2*i]);
        end
    endgenerate

    assign w1[2*p+1:2*p] = 2'b01;

endmodule
