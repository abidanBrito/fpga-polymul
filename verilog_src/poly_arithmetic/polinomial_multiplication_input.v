`timescale 1ns / 1ps

module polynomial_multiplication_input(
    input clk,
    input rst,
    input [11:0] state,
    input forward,
    input element_wise,
    output [9:0] read_address,
    output read_poly_op_sel,
    input [127:0] data128_in,
    
    output [63:0] operand_a,
    output [63:0] operand_b,
    output [63:0] operand_w
);

wire odd_cycle = state[0];

reg [127:0] read_buf_1;
reg [127:0] read_buf_2;
reg [127:0] read_buf_3;

// TODO could be integrated into ntt_index_generator
reg [63:0] operand_w_buf_1; 
reg [63:0] operand_w_buf_2;
reg [63:0] operand_w_buf_3;
reg [63:0] operand_w_buf_4;

reg [63:0] op_a;
reg [63:0] op_b;
reg [63:0] op_w;

assign operand_a = op_a;
assign operand_b = op_b;
assign operand_w = op_w;

wire [63:0] lut_output;

wire reorder;

reg reorder_delay [3:0];

assign read_poly_op_sel = element_wise ? odd_cycle : 0;

wire [7:0] psi_idx;
wire [7:0] pol_a_offset;

reg [9:0] read_address_reg;
assign read_address = read_address_reg;

ntt_const_lut const_lut(
    forward,
    psi_idx,
    lut_output
);
    
ntt_index_generator index_generator (
    clk,
    rst,
    forward,
    element_wise,
    psi_idx,
    pol_a_offset,
    reorder
);

always @(posedge clk)
begin
    if(rst) begin
        read_address_reg <= 0;
        read_buf_1 <= 128'd0;
        read_buf_2 <= 128'd0;
        read_buf_3 <= 128'd0;
        op_a <= 64'd0;
        op_b <= 64'd0;
        operand_w_buf_1 <= 64'd0;
        operand_w_buf_2 <= 64'd0;
        operand_w_buf_3 <= 64'd0;
        operand_w_buf_4 <= 64'd0;
        op_w <= 64'd0;
        reorder_delay[0] <= 1'd1;
        reorder_delay[1] <= 1'd1;
        reorder_delay[2] <= 1'd1;
        reorder_delay[3] <= 1'd1;
    end else begin
        read_address_reg <= {2'b0, pol_a_offset};
        read_buf_1 <= data128_in;
        read_buf_2 <= read_buf_1;
        read_buf_3 <= read_buf_2;
        op_a <= reorder_delay[3] ? (odd_cycle ? read_buf_2[63:0] : read_buf_3[127:64]) : read_buf_2[63:0];
        op_b <= reorder_delay[3] ? (odd_cycle ? read_buf_1[63:0] : read_buf_2[127:64]) : read_buf_2[127:64];
        operand_w_buf_1 <= lut_output;
        operand_w_buf_2 <= operand_w_buf_1;
        operand_w_buf_3 <= operand_w_buf_2;
        operand_w_buf_4 <= operand_w_buf_3;
        op_w <= operand_w_buf_4;
        reorder_delay[0] <= reorder;
        reorder_delay[1] <= reorder_delay[0];
        reorder_delay[2] <= reorder_delay[1];
        reorder_delay[3] <= reorder_delay[2];
        //$write("ntt_index_generator %02x %02x ", psi_idx, pol_a_offset);
        //$write("read %08x %08x ", data128_in[127:64], data128_in[63:0]);
        ////$write("b1 %08x %08x ", read_buf_1[127:64], read_buf_1[63:0]);
        ////$write("b2 %08x %08x ", read_buf_2[127:64], read_buf_2[63:0]);
        ////$write("b3 %08x %08x ", read_buf_3[127:64], read_buf_3[63:0]);
        //$write("a %08x b %08x w %08x", op_a, op_b, op_w);
        //$display("");
    end
end   

endmodule