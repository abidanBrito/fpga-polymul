`timescale 1ns / 1ps


module mu_const_mult
(
    input CLK,
    input [63:0] A,
    output [127:0] P
);

localparam mu= 65'd18458681966650671896;
reg [127:0] P_delay [2:0];

always @(posedge CLK)
begin
    P_delay[0] <= A * (mu >> 1);
    P_delay[1] <= P_delay[0];
    P_delay[2] <= P_delay[1];
end

assign P = P_delay[2];

endmodule
