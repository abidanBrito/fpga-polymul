`timescale 1ns / 1ps

module ntt_index_generator #(parameter INCREMENT=2)
(
    input clk,
    input rst,
    input forward,                  // select forward or backward direction
    input element_wise,             // element wise multiplication
    output [7:0] psi_idx,           // index of the current constant
    output [7:0] pol_a_offset,      // index a into polinomial
    output reorder
);

reg [7:0] idx_a;
reg [7:0] idx_distance;
reg [7:0] psi_idx_ctr;
reg odd_step;

wire [7:0] even_idx_distance = {idx_distance[7:1], 1'd0};
//wire [7:0] collapsed_idx_distance = (idx_distance | {idx_distance[0], 1'd0});
wire next_jump = ((idx_a + INCREMENT) & idx_distance) != 8'd0;
wire next_iteration = (pol_a_offset == 8'd255 - INCREMENT + 1);

assign reorder = ~idx_distance[0];
assign psi_idx = psi_idx_ctr;
assign pol_a_offset = odd_step ? (idx_a + even_idx_distance) : idx_a;

always @(posedge clk)
begin
    psi_idx_ctr <= psi_idx_ctr;
    idx_distance <= idx_distance;
    if (rst) begin
        idx_a <= 8'd0;
        idx_distance <= element_wise ? 8'd0 : (forward ? 8'd128 : 8'd1);
        psi_idx_ctr <= 0;
        odd_step <= 0;
    end else begin
        if (odd_step) begin
            if (next_iteration) begin
                idx_a <= 0;
                if (forward) begin
                    idx_distance <= (idx_distance >> 1);
                end else begin
                    idx_distance <= (idx_distance << 1); 
                end
                psi_idx_ctr <= psi_idx_ctr + 1;
            end else if (next_jump) begin
                idx_a <= idx_a + idx_distance + INCREMENT;
                psi_idx_ctr <= psi_idx_ctr + 1;
            end else begin
                idx_a <= idx_a + INCREMENT;
                psi_idx_ctr <= (idx_distance == 8'd1) ? psi_idx_ctr + 1 : psi_idx_ctr;
            end
        end else begin
            psi_idx_ctr <= (idx_distance == 8'd1) ? psi_idx_ctr + 1 : psi_idx_ctr;
            idx_a <= (idx_distance == 8'd1) ? idx_a + INCREMENT : idx_a;
        end
        odd_step <= ~odd_step;
    end
end

endmodule
