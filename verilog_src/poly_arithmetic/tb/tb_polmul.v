`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2022 21:07:37
// Design Name: 
// Module Name: tb_polmul
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


module tb_polmul( );

    reg clk;
    reg mult_rst;
    wire [127:0] mult_data128_in; 
         
    wire [9:0] mult_read_base_address;
    reg [9:0] mult_write_base_address;
    reg [9:0] op_a_base, op_b_base;
         
    wire mult_read_poly_op_sel;
    wire [9:0] mult_read_address, mult_write_address;
    wire mult_wea;
    wire mult_done;
    wire [127:0] mult_data128_out;

    wire bram_wea, bram_wea_1, bram_wea_2;
    wire [9:0] bram_addra;
    wire [9:0] bram_addrb;
    wire [127:0] bram_dina;
    wire [63:0] bram_din1a;
    wire [63:0] bram_din2a;
    wire [63:0] bram_doutb_1, bram_doutb_2;
    wire [63:0] bram_doutb;
    
    wire bram_slice1;
    
    reg tb_interrupt;
    reg tb_wea;
    reg [9:0] tb_addra, tb_addrb;
    reg [63:0] tb_dina;

    reg [63:0] test_data_a [255:0];
    reg [63:0] test_data_b [255:0];
    reg [8:0] i;

    reg [1:0] mult_mode;
            
    polynomial_multiplication pmult(
         clk, 
         mult_rst,
         mult_mode,
         mult_read_poly_op_sel,
         mult_read_address,
         mult_write_address, 
         mult_wea,
         mult_data128_in, 
         mult_done,
         mult_data128_out
    );
    
    BRAM64_512 BR1 (
         .clka(clk), // input clka --> Clock signal to port-A 
         .wea(bram_wea_1), // input [0 : 0] wea --> Write enable signal to port-A
         .addra(bram_addra[9:1]), // input [9 : 0] addra --> Address to port-A
         .dina(bram_din1a), // input [63 : 0] dina --> Input data to port-A
         .clkb(clk), // input clkb --> Clock for port-B
         .addrb(bram_addrb[9:1]), // input [9 : 0] addrb --> Address to port-B
         .doutb(bram_doutb_1) // output [63 : 0] doutb --> Data output from port-B
    );
    
    BRAM64_512 BR2 (
         .clka(clk), // input clka --> Clock signal to port-A 
         .wea(bram_wea_2), // input [0 : 0] wea --> Write enable signal to port-A
         .addra(bram_addra[9:1]), // input [9 : 0] addra --> Address to port-A
         .dina(bram_din2a), // input [63 : 0] dina --> Input data to port-A
         .clkb(clk), // input clkb --> Clock for port-B
         .addrb(bram_addrb[9:1]), // input [9 : 0] addrb --> Address to port-B
         .doutb(bram_doutb_2) // output [63 : 0] doutb --> Data output from port-B
    );

    //assign mult_read_base_address = (mult_read_poly_op_sel) ? 10'd256 : 10'd0;
    assign mult_read_base_address = (mult_read_poly_op_sel) ? op_b_base : op_a_base;
    //assign mult_write_base_address = 10'd512;
    
    //assign bram_wea = (tb_interrupt) ? tb_wea : mult_wea;
    assign bram_wea_1 = (tb_interrupt) ? (tb_wea & bram_slice1) : mult_wea;
    assign bram_wea_2 = (tb_interrupt) ? (tb_wea & ~bram_slice1) : mult_wea;
    assign bram_addra = (tb_interrupt) ? tb_addra : (mult_write_address+mult_write_base_address);
    assign bram_dina = (tb_interrupt) ? {2{tb_dina}} : mult_data128_out;
    assign bram_addrb = (tb_interrupt) ? tb_addrb : (mult_read_address+mult_read_base_address);
    assign bram_slice1 = ~bram_addra[0];
    assign bram_doutb = bram_slice1 ? bram_doutb_1 : bram_doutb_2;
    assign bram_din1a = bram_dina[63:0];
    assign bram_din2a = bram_dina[127:64];
    assign mult_data128_in = {bram_doutb_2, bram_doutb_1};

    always @(posedge clk) begin
        if (~tb_interrupt && mult_wea) begin
            $display("ram[%04x] <= %08x", bram_addra+0, bram_dina[63:0]);
            $display("ram[%04x] <= %08x", bram_addra+1, bram_dina[127:64]);
        end
    end

    initial begin
        clk = 0;
        mult_rst = 1;
        tb_interrupt = 1;
        mult_mode = 0;
        mult_write_base_address = 10'd0;
        op_a_base = 10'd0;
        op_b_base = 10'd0;


        tb_wea = 0;
        tb_addra = 0;
        tb_addrb = 0;
        tb_dina = 0;

        #2;

        $readmemh("/home/jharing/git/chw2022g3/Verilog_src/poly_arithmetic/tb/poly_a.txt", test_data_a);
        $readmemh("/home/jharing/git/chw2022g3/Verilog_src/poly_arithmetic/tb/poly_b.txt", test_data_b);        
        
        #10;
        #10;
        for(i=0; i<256; i=i+1)
        begin
            #10;
            tb_wea = 1;
            tb_addra = i;
            tb_dina = test_data_a[i];
        end
        #10;
        tb_wea = 0;
        tb_addra = 0;
        tb_dina = 0;
        

        #10;
        #10;
        for(i=0; i<256; i=i+1)
        begin
            #10;
            tb_wea = 1;
            tb_addra = i+256;
            tb_dina = test_data_b[i];
        end
        #10;
        tb_wea = 0;
        tb_addra = 0;
        tb_dina = 0;


        #10;
        tb_interrupt = 0;

        for(i=0; i<128; i=i+1)
        begin
            $display("RAM[%02x]=%08x", i*2, BR1.ram[i]);
            $display("RAM[%02x]=%08x", i*2+1, BR2.ram[i]);
        end

        $display("-- start --");
        
        #10;
        mult_rst = 0;

        wait(mult_done);  
        repeat (3) #10; 

        mult_write_base_address = 10'd256;
        op_a_base = 10'd256;
        op_b_base = 10'd256;
        repeat (3) #10;
        wait(mult_done);  

        mult_write_base_address = 10'd512;
        op_a_base = 10'd0;
        op_b_base = 10'd256;
        mult_mode = 2'd2;
        repeat (3) #10;
        wait(mult_done);  

        mult_write_base_address = 10'd512;
        op_a_base = 10'd512;
        op_b_base = 10'd512;
        mult_mode = 2'd1;
        repeat (3) #10;
        wait(mult_done);  

        
        #10;
        mult_rst = 1;

        #250;

        #10;
        tb_interrupt = 1;

        #10;
        #10;
        for(i=0; i<256; i=i+1)
        begin
            tb_addrb = i+512;
            #10;
        end
        #10;


        for(i=0; i<128; i=i+1)
        begin
            $display("RAM[%02x]=%08x", i*2, BR1.ram[i]);
            $display("RAM[%02x]=%08x", i*2+1, BR2.ram[i]);
        end

        $display("--- end ---");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
