`timescale 1ns / 1ps

module BRAM64_512
(
    input clka,
    input wea,
    input [8:0] addra,
    input [63:0] dina,
    input clkb,
    input [8:0] addrb,
    output [63:0] doutb
);

reg [63:0] ram [511:0];

always @(posedge clka) begin
    if (wea) begin
      ram[addra] <= dina;
      //$display("ram[%04x] <= %08x", addra, dina);
    end
end

always @(posedge clkb) begin
    //doutb <= ram[addrb];
end

//always @(addrb) begin
//    $display("addrb=%x", addrb);
//end

assign doutb = ram[addrb];

endmodule
