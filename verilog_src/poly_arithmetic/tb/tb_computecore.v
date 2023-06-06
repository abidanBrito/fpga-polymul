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


module tb_computecore( );

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
        
reg clk, rst; 
reg [9:0] address_ext;
reg [63:0] dina_ext;
reg wea_ext;

reg [34:0] command_in;
reg command_we0, command_we1;
wire [63:0] doutb_ext;
wire done_ins_computation; // This becomes 1 when the instruction has finished. 
wire error_trng;
    
ComputeCore cc(
    clk, rst, address_ext, dina_ext, wea_ext,
    command_in, command_we0, command_we1, 
    doutb_ext,
    done_ins_computation,
    error_trng
);

    initial begin
        clk = 0;
        rst = 1;
        address_ext = 0;
        dina_ext = 64'd0;
        wea_ext = 0;
        command_in = 35'd0;
        command_we0 = 0;
        command_we1 = 0;

        #2;

        $readmemh("/home/jharing/git/chw2022g3/Verilog_src/poly_arithmetic/tb/poly_a.txt", test_data_a);
        $readmemh("/home/jharing/git/chw2022g3/Verilog_src/poly_arithmetic/tb/poly_b.txt", test_data_b);        
        
        #10;
        #10;
        for(i=0; i<256; i=i+1)
        begin
            #10;
            wea_ext = 1;
            address_ext = i;
            dina_ext = test_data_a[i];
        end
        #10;
        wea_ext = 0;
        address_ext = 0;
        dina_ext = 0;
        

        #10;
        #10;
        for(i=0; i<256; i=i+1)
        begin
            #10;
            wea_ext = 1;
            address_ext = i+256;
            dina_ext = test_data_b[i];
        end
        #10;
        wea_ext = 0;
        address_ext = 0;
        dina_ext = 0;


        #10;
        //tb_interrupt = 0;

//        for(i=0; i<128; i=i+1)
//        begin
//            $display("RAM[%02x]=%08x", i*2, BR1.ram[i]);
//            $display("RAM[%02x]=%08x", i*2+1, BR2.ram[i]);
//        end

        $display("-- start --");
        
        #10;
//
//        wait(done_ins_computation);  
//        repeat (3) #10; 
//        rst = 0;
//        mult_write_base_address = 10'd256;
//        op_a_base = 10'd256;
//        op_b_base = 10'd256;
//        repeat (3) #10;
//        wait(done_ins_computation);  
//
//        mult_write_base_address = 10'd512;
//        op_a_base = 10'd0;
//        op_b_base = 10'd256;
//        mult_mode = 2'd2;
//        repeat (3) #10;
//        wait(done_ins_computation);  
//
//        mult_write_base_address = 10'd512;
//        op_a_base = 10'd512;
//        op_b_base = 10'd512;
//        mult_mode = 2'd1;
//        repeat (3) #10;
//        wait(done_ins_computation);  
//
//        
//        #10;
//        mult_rst = 1;
//
//        #250;
//
//        #10;
//        tb_interrupt = 1;
//
//        #10;
//        #10;
//        for(i=0; i<256; i=i+1)
//        begin
//            tb_addrb = i+512;
//            #10;
//        end
//        #10;
        #250;

        $display("--- end ---");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
