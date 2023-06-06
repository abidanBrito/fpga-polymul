`timescale 1ns / 1ps


module mult_64
(
    input CLK,
    input [63:0] A,
    input [63:0] B,
    output [127:0] P
);

wire [127:0] P_next = A * B;
reg [127:0] P_delay [5:0];

always @(posedge CLK) begin
    //$write("A %016x ", A);
    //$write("B %016x ", B);
    //$write("P_next %016x ", P_next);
    //$write("P %016x ", P);
    //$display("");
    P_delay[0] <= P_next;
    P_delay[1] <= P_delay[0];
    P_delay[2] <= P_delay[1];
    P_delay[3] <= P_delay[2];
    P_delay[4] <= P_delay[3];
    P_delay[5] <= P_delay[4];
end

assign P = P_delay[5];

endmodule
