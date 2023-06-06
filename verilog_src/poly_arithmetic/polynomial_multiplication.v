`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2022 03:14:43 PM
// Design Name: 
// Module Name: polynomial_64_multiplication
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module modular_multiplier(clk, mul_ina, mul_inb, mul_start, mul_out, mul_done);

localparam q       = 64'd18434813901432784897;
localparam qx      = 65'd18434813901432784897;
localparam mu      = 65'd18458681966650671896;
localparam DELAY   = 14;
localparam S_DELAY = 2; // 2 = 3 cycles delay
localparam MUL_DELAY = 3+3-1; // 5 = 6 cycles delay

input clk;
input [63:0] mul_ina, mul_inb;
input mul_start;
output [63:0] mul_out;
output mul_done;

reg [63:0] mul_ina_reg, mul_inb_reg;
reg [127:0] mul_delay [MUL_DELAY:0];
reg [64:0] s_delay [S_DELAY:0];

reg [DELAY:0] done_delay;

wire [127:0] int_mul_result;
wire [127:0] rx_low;
wire [127:0] sx_low, sx_high;

reg [63:0] result;

//    D = A * B
//
mult_64 MUL_64 (.CLK(clk), .A(mul_ina_reg), .B(mul_inb_reg), .P(int_mul_result));
mu_const_mult MU_MUL_LOW (.CLK(clk), .A(int_mul_result[63:0]), .P(sx_low));
mu_const_mult MU_MUL_HIGH (.CLK(clk), .A(int_mul_result[127:64]), .P(sx_high));
q_const_mult Q_MUL_LOW (.CLK(clk), .A(s[63:0]), .P(rx_low));

wire [192:0] sx = ((sx_high << 64) + sx_low) << 1;
wire [64:0] s = sx[192:128];
wire [64:0] r = ((s_delay[S_DELAY][64] * q) << 64) + rx_low;
wire [64:0] u = mul_delay[MUL_DELAY][64:0] - r;
wire [63:0] reduced_val = (u >= qx) ? (u - q) : u;

//    s = (D * mu) >> 128
//
//wire [192:0] sx_ref = int_mul_result * mu;
//wire [64:0] s_ref = sx_ref[192:128];

//    D_low = int_mul_result[63:0]
//    D_high = int_mul_result[127:64]

// Way #1: naive addition (needs to be synced with flip-flops).
// NOTE(abi): use 64-bit mu as the cte. for the IP multiplier (cut off MSB).
//wire [192:0] sx = ((mul_1 + sx_high) << 64) + sx_low;

// Way #2: bit shifting trick (no flip-flop needed for int_mul_result).
// NOTE(abi): use mu >> 1 as the cte. for the IP multiplier.

// NOTE(abi): we only need the upper 65 bits.

//    r = s * q
//
// NOTE(abi): we only need the lower 65 bits for the correction.
//wire [64:0] r_ref = s * q;



//    u = D - r
//

//    C = u - q if(u >= q) else u
//

generate 
    for (genvar i=1; i<=S_DELAY; i=i+1) begin
        always @(posedge clk)
        begin
            s_delay[i] <= s_delay[i-1];
        end
    end
    for (genvar i=1; i<=MUL_DELAY; i=i+1) begin
        always @(posedge clk)
        begin
            mul_delay[i] <= mul_delay[i-1];
        end
    end
endgenerate

always @(posedge clk)
begin
    result <= reduced_val[63:0];
    mul_ina_reg <= mul_ina;
    mul_inb_reg <= mul_inb;
    done_delay <= {done_delay[DELAY-1:0], mul_start};
    s_delay[0] <= s;
    mul_delay[0] <= int_mul_result;
end

assign mul_out = result;
assign mul_done = done_delay[DELAY];

endmodule

 

module polynomial_multiplication(clk, rst, mode, read_poly_op_sel, read_address, write_address, wea,
                                 data128_in, done, data128_out);

input clk;
input rst;                      // Active high
input [1:0] mode;               // 00 -> NTT, 01 -> inv-NTT, 10 -> element-wise mult
output [9:0] read_address;      // BRAM address for reading a 64-bit word
output read_poly_op_sel;        // Select one of the two polynomial operands
input [127:0] data128_in;       // Word read from the BRAM

output [9:0] write_address;     // BRAM address where the result word will be written
output wea;                     // BRAM write enable signal. The data in the write-bus will get written when this is 1.
output [127:0] data128_out;     // Word to be written to BRAM in the memory address specified by write_address
output done;                    // This signal becomes 1 when a given polynomial multiplication gets computed. 
                                // After that it should stay 1 until rst becomes 1.
                                // (we only set it to 1 for one cycle, otherwise the cryptocore would not work)

reg [11:0] mode_reg;
reg [11:0] state;  
wire [11:0] last_state = mode_reg[1] ? (256+8+2+2+13) : (1024+8+2+2+13);
wire [11:0] nextstate = (state == last_state) ? 11'd0 : state + 1;
wire odd_cycle = ~state[0];            

wire forward = ~mode[0];
wire element_wise = mode[1];
wire input_start = (state <= 0) || (state == last_state);
wire output_start = (state <= 2+2+13) || (state == last_state); // 1 + butterfly_unit delay
wire [63:0] operand_a_in, operand_b_in, operand_w_in;
wire [63:0] operand_a_out, operand_b_out;    
wire input_reset = rst | input_start;

assign done = (state == last_state) ? 1'b1 : 1'b0;
assign wea = (state >= 8+2+2+13) && (state != last_state) && ((~element_wise) || (odd_cycle)); // 8 + output_start delay

polynomial_multiplication_input input_gen(
    .clk(clk),
    .rst(input_reset),
    .state(state),
    .forward(forward),
    .element_wise(element_wise),
    .read_address(read_address),
    .read_poly_op_sel(read_poly_op_sel),
    .data128_in(data128_in),
    .operand_a(operand_a_in),
    .operand_b(operand_b_in),
    .operand_w(operand_w_in)
); 
                           
butterfly_unit butterfly(
    .clk(clk),
    .rst(rst),
    .forward(forward),
    .element_wise(element_wise),
    .operand_a_in(operand_a_in),
    .operand_b_in(operand_b_in),
    .operand_w_in(operand_w_in),
    .operand_a_out(operand_a_out),
    .operand_b_out(operand_b_out)
);

polynomial_multiplication_output output_gen(
    .clk(clk),
    .rst(rst),
    .start(output_start),
    .state(state),
    .forward(forward),
    .element_wise(element_wise),
    .write_address(write_address),
    .data128_out(data128_out),
    .done(done),
    .result_a(operand_a_out),
    .result_b(operand_b_out)
);

always @(posedge clk)
begin
    if(rst)
        mode_reg <= 2'd0;
    else
        mode_reg <= mode;    
end

always @(posedge clk)
begin
    if(rst)
        state <= 11'd0;
    else
        state <= nextstate;    
end
                                        
endmodule


