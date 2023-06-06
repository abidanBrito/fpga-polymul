`timescale 1ns / 1ps


// MOD_ADD(A,B) ((A+B >= q) ? ((A)+(B)-q) : ((A)+(B)))
// MOD_SUB(A,B) ((A-B >= q) ? ((A)+(B)-q) : ((A)+(B)))

module mod_add
#(parameter q = 65'd18434813901432784897)
(
    input clk,
    input [63:0] a,
    input [63:0] b,
    output reg [63:0] c
);

wire [64:0] tmp1 = a + b;
wire [64:0] tmp2 = tmp1 - q;

always @(*)
begin
    c <= tmp2[64] ? tmp1 : tmp2;
end

endmodule


module mod_sub
#(parameter q = 65'd18434813901432784897)
(
    input clk,
    input [63:0] a,
    input [63:0] b,
    output reg [63:0] c
);

wire [64:0] tmp1 = a - b;
wire [63:0] tmp2 = tmp1 + q;

always @(*)
begin
    c <= tmp1[64] ? tmp2 : tmp1;
end

endmodule


module butterfly_unit(
    input clk,
    input rst,
    input forward,
    input element_wise,
    input [63:0] operand_a_in,
    input [63:0] operand_b_in,
    input [63:0] operand_w_in,
    output [63:0] operand_a_out,
    output [63:0] operand_b_out
);

localparam MODMUL_DELAY = 2+13; // 2 + modular_multiplier delay

reg [63:0] propval [MODMUL_DELAY:0]; // TODO only MODMUL_DELAY elements needed
reg [63:0] stage_1_mul_in_a;
reg [63:0] stage_1_mul_in_b;

reg [63:0] stage_n_mul_out;

reg [63:0] stage_out_a;
reg [63:0] stage_out_b;

assign operand_a_out = stage_out_a;
assign operand_b_out = stage_out_b;

wire [63:0] mul_ina, mul_inb, mul_out; 
reg mul_start = 1'd1; 
wire mul_done;

modular_multiplier Mult(
  .clk(clk),
  .mul_ina(mul_ina),
  .mul_inb(mul_inb),
  .mul_start(mul_start),
  .mul_out(mul_out),
  .mul_done(mul_done)
);

assign mul_ina = stage_1_mul_in_a;
assign mul_inb = stage_1_mul_in_b;
assign mul_ina = stage_1_mul_in_a;

wire [63:0] input_sum_a, input_sum_b, output_sum_a, output_sum_b;

mod_add input_adder_a(clk, operand_a_in, operand_b_in, input_sum_a);
mod_sub input_subtr_b(clk, operand_a_in, operand_b_in, input_sum_b);
mod_add output_adder_a(clk, propval[MODMUL_DELAY], stage_n_mul_out, output_sum_a);
mod_sub output_subtr_a(clk, propval[MODMUL_DELAY], stage_n_mul_out, output_sum_b);

generate 
    for (genvar i=1; i<=MODMUL_DELAY; i=i+1) begin
        always @(posedge clk)
        begin
            propval[i] <= propval[i-1];
        end
    end
endgenerate

always @(posedge clk)
begin
    propval[0] <= forward ? operand_a_in : input_sum_a;
    stage_1_mul_in_a <= element_wise ? operand_a_in : operand_w_in;
    stage_1_mul_in_b <= forward ? operand_b_in : input_sum_b;
    
    stage_n_mul_out <= mul_out;
    
    stage_out_a <= forward ? output_sum_a : propval[MODMUL_DELAY];
    stage_out_b <= element_wise ? stage_n_mul_out : (forward ? output_sum_b : stage_n_mul_out);

    $write("in p %08x a %08x b %08x ", operand_w_in, operand_a_in, operand_b_in);
    $write("s1 p %08x a %08x b %08x ", propval[0], stage_1_mul_in_a, stage_1_mul_in_b);
    $write("sn p %08x m %08x ", propval[MODMUL_DELAY], stage_n_mul_out);
    $write("out a %08x b %08x ", stage_out_a, stage_out_b);
    $display("");
end

endmodule
