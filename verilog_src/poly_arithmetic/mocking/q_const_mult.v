`timescale 1ns / 1ps


module q_const_mult
(
    input CLK,
    input [63:0] A,
    output [127:0] P
);

localparam q = 64'd18434813901432784897;
reg [127:0] P_delay [2:0];

always @(posedge CLK)
begin
    P_delay[0] <= A * q;
    P_delay[1] <= P_delay[0];
    P_delay[2] <= P_delay[1];
end

assign P = P_delay[2];

endmodule
