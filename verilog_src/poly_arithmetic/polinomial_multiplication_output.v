`timescale 1ns / 1ps

module polynomial_multiplication_output(
    input clk,
    input rst,
    input start,
    input [11:0] state,
    input forward,
    input element_wise,
    output [9:0] write_address,
    output [127:0] data128_out,
    output done,
    
    input [63:0] result_a,
    input [63:0] result_b
);

localparam WRITE_DELAY = 6;

reg index_rst_delay [WRITE_DELAY:0];

reg [127:0] write_buf_1;
reg [127:0] write_buf_2;
reg [127:0] write_buf_3;

wire reorder;
wire [7:0] psi_idx;
wire [7:0] pol_a_offset;

wire odd_cycle = state[0];
wire [63:0] out_low  = reorder ? (odd_cycle ? write_buf_2[63:0] : write_buf_3[127:64]) : write_buf_2[63:0];
wire [63:0] out_high = reorder ? (odd_cycle ? write_buf_1[63:0] : write_buf_2[127:64]) : write_buf_2[127:64];
assign data128_out = {out_high, out_low};
assign write_address = {2'b0, pol_a_offset};


ntt_index_generator index_generator (
    clk,
    index_rst_delay[WRITE_DELAY],
    forward,
    element_wise,
    psi_idx,
    pol_a_offset,
    reorder
);    

generate 
    for (genvar i=1; i<=WRITE_DELAY; i=i+1) begin
        always @(posedge clk)
        begin
            index_rst_delay[i] <= index_rst_delay[i-1];
        end
    end
endgenerate

always @(posedge clk)
begin
    index_rst_delay[0] <= start;
    if(rst) begin
        write_buf_1 <= 128'd0;
        write_buf_2 <= 128'd0;
        write_buf_3 <= 128'd0;
    end else begin
        write_buf_1 <= {result_b, result_a};
        write_buf_2 <= write_buf_1;
        write_buf_3 <= write_buf_2;
        //$write("ntt_index_generator %08x %08x ", psi_idx, pol_a_offset);
        //$write("reslts %08x %08x ", result_b, result_a);
        //$write("b1 %08x %08x ", write_buf_1[127:64], write_buf_1[63:0]);
        //$write("b2 %08x %08x ", write_buf_2[127:64], write_buf_2[63:0]);
        //$write("b3 %08x %08x ", write_buf_3[127:64], write_buf_3[63:0]);
        //$write("delay %d ", index_rst_delay[WRITE_DELAY]);
        //$write("write_address %08x ", write_address);
        //$display("");
    end
end

endmodule
