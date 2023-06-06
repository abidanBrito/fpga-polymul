`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Cryptographic Engineering Project: Graz University of Technology
// Based on initial design by Sujoy Sinha Roy and Ahmet Can Mert. 
// The codes are for academic research use only and does not come with any support or any responsibility.

//////////////////////////////////////////////////////////////////////////////////

module ComputeCore(clk, rst, address_ext, dina_ext, wea_ext,
					command_in, command_we0, command_we1, 
					doutb_ext,
					done_ins_computation,
					error_trng
					);

input clk, rst; 
input [9:0] address_ext;
input [63:0] dina_ext;
input wea_ext;

input [34:0] command_in;
input command_we0, command_we1;
output [63:0] doutb_ext;
output done_ins_computation; // This becomes 1 when the instruction has finished. 
output error_trng;

reg [34:0] command_reg0, command_reg1;
wire [4:0] INS;
wire [9:0] OP1, OP2, OP3;
wire op2_sel;
wire [9:0] OP1_or_OP2;

always @(posedge clk)
begin
    if(rst)
        command_reg0 <= 35'd0;
	else if(command_we0)
		command_reg0 <= command_in;
	else
	   command_reg0 <= command_reg0;	
end
always @(posedge clk)
begin
    if(rst)
        command_reg1 <= 35'd0;
	else if(command_we1)
		command_reg1 <= command_in;
	else
	   command_reg1 <= command_reg1;	
end


// Parsing of INS-code, operand1, operand2, operand3 from command_reg0
// INS is 5 bit and all operands are 10 bits. 
assign INS = command_reg0[4:0];
assign OP1 = command_reg0[14:5];
assign OP2 = command_reg0[24:15];
assign OP3 = command_reg0[34:25];	

// Declaration of BRAM signal. The BRAM is Simple-Dual-Port, and uses Port-A for writing and Port-B for reading. 
// The BRAM has 64-bit words an there are 1024 words. Hence the address range is 0-1023 and address selection is 10 bit.                           
wire bram_slice1 = ~address_ext[0];
wire [9:0] rd_address, wt_address;
wire [9:0] addra, addrb;
wire wea, wea_br1, wea_br2;
wire [63:0] dina, doutb;
wire [63:0] dina_br1, dina_br2;
wire [63:0] doutb_br1, doutb_br2;
wire [127:0] dout_128_mult;
wire [127:0] dina_128, doutb_128;

// Declaration of TRNG related signals.
wire trng_rst, trng_enable; 
wire [63:0] trng_out;
wire [9:0] num_rng_words;   // Number of random words to be generated. Max value 512. User specifies it in OP1 of the TRNG instruction.
wire [9:0] trng_write_address; 
wire trng_wea, done_trng;
wire error_trng;

// Declaration of AES related signals
wire aes_rst, aes_enc_or_dec;
wire [9:0] aes_read_address, aes_write_address;
wire aes_wea;
wire done_aes;
wire [63:0] aes_out;

//Declaration of Poly Add/Sub related signals
wire addsub_rst,add_or_sub,polyas_wea,polyas_op2_sel;
wire [9:0]  polyas_read_address, polyas_write_address;
wire [63:0] polyas_out;
wire done_polyas;

//Declaration of Poly mult related signals
wire mult_rst,polymult_wea,polymult_op2_sel;
wire [9:0]  polymult_read_address, polymult_write_address;
wire [63:0] polymult_out;
wire done_polymult;

// When the cryptoprocessor finds that the decoded instruction is TRNG/AES, 
// it makes the reset signal for the TRNG/AES low so that TRNG/AES starts functioning. 
// INS:18 --> TRNG
// INS:19 --> AES Enc
// INS:20 --> Aes Dec
// INS:22 --> PolyAdd
// INS:23 --> PolySub
// INS:24 --> PolyMul
assign trng_rst = (INS==5'd18) ? 1'b0 : 1'b1;
assign trng_enable = ~trng_rst;
assign aes_rst     = (INS==5'd19 || INS==5'd20) ? 1'b0 : 1'b1;
assign aes_enc_or_dec = (INS==5'd20);
assign addsub_rst = (INS==5'd22 || INS==5'd23) ? 1'b0 : 1'b1;
assign mult_rst = ((INS==5'd24) || (INS==5'd25) || (INS==5'd26)) ? 1'b0 : 1'b1;
assign add_or_sub = (INS==5'd22) ? 1'b1 : 1'b0;// 1 if add otherise 0 for sub

// BRAM read/write relative-address and control signals are generated based on different instructions and their enable signals. 
assign rd_address = (trng_enable) ? 10'd0              : (~aes_rst) ? aes_read_address  : (~addsub_rst) ? polyas_read_address : (~mult_rst) ? polymult_read_address : address_ext;
assign wt_address = (trng_enable) ? trng_write_address : (~aes_rst) ? aes_write_address : (~addsub_rst) ? polyas_write_address: (~mult_rst) ? polymult_write_address : address_ext;
assign wea        = (trng_enable) ? trng_wea           : (~aes_rst) ? aes_wea           : (~addsub_rst) ? polyas_wea : (~mult_rst) ? polymult_wea : wea_ext;
assign dina       = (trng_enable) ? trng_out           : (~aes_rst) ? aes_out           : (~addsub_rst) ? polyas_out : (~mult_rst) ? polymult_out : dina_ext;

assign wea_br1    = (wea_ext) ? (wea_ext & bram_slice1) : wea;
assign wea_br2    = (wea_ext) ? (wea_ext & ~bram_slice1) : wea;

assign dina_128 = (~mult_rst) ? dout_128_mult : {2{dina}};
assign dina_br1 = dina_128[63:0];
assign dina_br2 = dina_128[127:64];
assign doutb = bram_slice1 ? doutb_br1 : doutb_br2;
assign doutb_128 = {doutb_br2, doutb_br1};

// BRAM read/write physical-address generation
assign op2_sel = (~addsub_rst) ? polyas_op2_sel : (~mult_rst) ? polymult_op2_sel : 1'b0;    // Currently OP2 is disabled. 
assign OP1_or_OP2 = (op2_sel) ? OP2 : OP1;
assign addra = OP3 + wt_address;
assign addrb = OP1_or_OP2 + rd_address;
assign doutb_ext = doutb;

// Currently there is only one instruction.
assign done_ins_computation = (done_trng || done_aes || done_polyas || done_polymult);

wire [1:0] polymult_mode = INS[1:0];


/////////////////////////////////////////////////////////////////////////
////////////////// Start: Instantiation of poly multiplication unit ///////////////////////


polynomial_multiplication polymult(
  clk,
  mult_rst,
  polymult_mode,
  polymult_op2_sel,
  polymult_read_address,
  polymult_write_address,
  polymult_wea,
  doutb_128, 
  done_polymult,
  dout_128_mult
);

////////////////// End: Instantiation of poly multiplication unit /////////////////////////
/////////////////////////////////////////////////////////////////////////



////////////////// Start: Instantiation of BRAM /////////////////////////
/////////////////////////////////////////////////////////////////////////

// The BRAM memory of the cryptoprocessor. Different instructions read their operands from it and write results to it.
// The BRAM is in simple-dual-port configuration, i.e., port-A is used for writing and port-B is used for reading.           									
BRAM64_512 BR1 (
  .clka(clk), // input clka --> Clock signal to port-A 
  .wea(wea_br1), // input [0 : 0] wea --> Write enable signal to port-A
  .addra(addra[9:1]), // input [9 : 0] addra --> Address to port-A
  .dina(dina_br1), // input [63 : 0] dina --> Input data to port-A
  .clkb(clk), // input clkb --> Clock for port-B
  .addrb(addrb[9:1]), // input [9 : 0] addrb --> Address to port-B
  .doutb(doutb_br1) // output [63 : 0] doutb --> Data output from port-B
);

BRAM64_512 BR2 (
  .clka(clk), // input clka --> Clock signal to port-A 
  .wea(wea_br2), // input [0 : 0] wea --> Write enable signal to port-A
  .addra(addra[9:1]), // input [9 : 0] addra --> Address to port-A
  .dina(dina_br2), // input [63 : 0] dina --> Input data to port-A
  .clkb(clk), // input clkb --> Clock for port-B
  .addrb(addrb[9:1]), // input [9 : 0] addrb --> Address to port-B
  .doutb(doutb_br2) // output [63 : 0] doutb --> Data output from port-B
);

//////////////////// End: Instantiation of BRAM /////////////////////////
/////////////////////////////////////////////////////////////////////////


endmodule
