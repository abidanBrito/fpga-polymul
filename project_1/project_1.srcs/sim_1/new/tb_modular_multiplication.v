`timescale 1ns / 1ps

module tb_modular_multiplication();

    reg clk;
    reg mult_rst;

    reg [63:0] test_data_a [2:0];
    reg [63:0] test_data_b [2:0];
    reg [8:0] i;
    reg [8:0] n_rec;
            
            
    reg [63:0] mul_ina, mul_inb; 
    wire [63:0] mul_out;
    reg mul_start; 
    wire mul_done;
            
    modular_multiplier Mult(
        .clk(clk),
        .mul_ina(mul_ina),
        .mul_inb(mul_inb),
        .mul_start(mul_start),
        .mul_out(mul_out),
        .mul_done(mul_done)
    );

    initial begin
        clk = 0;
        mult_rst = 1;
        mul_start = 0;
        #1;
        #10;
        #10;
        mul_start = 1; 
        mul_ina = 64'd2; // 4
        mul_inb = 64'd2;
        #10;
        mul_ina = 64'd18434813901432784897; // 0
        mul_inb = 64'd1;
        #10;
        mul_ina = 64'd13901706437927406777; // 2165091042952656860 = 1e0bf2d51992b7dc
        mul_inb = 64'd15700958295376441594;
        #10;
        mul_ina = 64'd1835666423505824111; // 14699318972420960652 = cbfe78b99f4fb18c
        mul_inb = 64'd4408257175847215637;
        #10;
        mul_ina = 64'd2; // 4
        mul_inb = 64'd2;
        #10;
        mul_ina = 64'd2; // 4
        mul_inb = 64'd2;
        #10;
        mul_ina = 64'd2; // 4
        mul_inb = 64'd2;
        #10;
        mul_start = 0;

        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        $display("--- end ---");
        $finish;
    end

    always @(negedge clk) begin
        $write("start %01d ", mul_start);
        $write("ina %016x ", mul_ina);
        $write("inb %016x ", mul_inb);
        $write("done %01d ", mul_done);
        $write("out %08x ", mul_out);
        $display("");
        $write("mul_ina_reg %016x ", Mult.mul_ina_reg);
        $write("mul_inb_reg %016x ", Mult.mul_inb_reg);
        $write("int_mul_result %016x ", Mult.int_mul_result);
        $write("sx_low %016x ", Mult.sx_low);
        $write("sx_high %016x ", Mult.sx_high);
        $display("");
        $write("rx_low %016x ", Mult.rx_low);
        $write("mul_1 %016x ", Mult.mul_1);
        $write("s %016x ", Mult.s);
        $write("r1 %016x ", Mult.r1);
        $display("");
        $display("");
    end


    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,tb_modular_multiplication);
    end


    always #5 clk = ~clk;


endmodule