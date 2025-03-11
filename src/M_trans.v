module M_trans_cell (
    input        clk,
    input        rst_n,
    input  [1:0] a_i,
    input  [1:0] b_i,
    output reg [1:0] m_i
);
// reg [1:0] m_i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        m_i <= 2'b0;
    end
    else begin
        if (a_i == 2'b00 && b_i == 2'b00)
            m_i <= 2'b10;
        else if (a_i == 2'b10 && b_i == 2'b00)
            m_i <= 2'b00;
        else if (a_i == 2'b10 && b_i == 2'b10)
            m_i <= 2'b10;
        else if (a_i == 2'b00 && b_i == 2'b10)
            m_i <= 2'b00;
        else
            m_i <= 2'b01;
    end
end

endmodule

module M_trans #(
    parameter p = 33
) (
    input            clk,
    input            rst_n,
    input  [2*p-1:0] a_i,
    input  [    1:0] b_i,
    output [2*p-1:0] m_i
);

genvar i;
generate
    for (i = 0; i < p; i = i + 1) begin : M_cell
        M_trans_cell u_M_trans_cell(clk, rst_n, a_i[2*i+1:2*i], b_i, m_i[2*i+1:2*i]); 
    end
endgenerate

endmodule
