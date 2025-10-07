`timescale 1ns/1ps
module booths_algo #(
    parameter N = 4           
)(
    input clk,                // Clock 
    input rst,                // Active-high reset
    input [N-1:0] mr_in,      // Multiplier
    input [N-1:0] md,         // Multiplicand
    output reg [2*N-1:0] out  // Final Product (2*N bits)
);

    
    reg [N-1:0] mr;           // Multiplier register
    reg [N-1:0] accu;         // Accumulator
    reg [N-1:0] arth;         // Arithmetic temporary reg 
    reg q1;                   // Booth’s extra bit
    reg [N-1:0] inv_md;       // Two’s complement of multiplicand
    reg [$clog2(N):0] count;  // Counter (steps= no. of bits input have)


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mr     <= mr_in;           // Load multiplier
            accu   <= {N{1'b0}};       // Clear accumulator
            q1     <= 1'b0;            // Reset q1
            inv_md <= ~md + 1;         // Compute 2's complement of md
            count  <= N;               // Set iteration count
            out    <= {2*N{1'b0}};     // Clear output
        end 
        else if (count != 0) begin
            // Step 1: Booth’s Decision Logic
            if (mr[0] & ~q1)
                arth = accu + inv_md;   // 0->1; Subtract multiplicand
            else if (~mr[0] & q1)
                arth = accu + md;       // 1->0 ; Add multiplicand
            else
                arth = accu;            // no transition → No operation

            // Step 2: Arithmetic Right Shift
            q1  = mr[0];                           // Update q1
            mr  = {arth[0], mr[N-1:1]};            // Shift MR with sign bit
            accu = {arth[N-1], arth[N-1:1]};       // Shift Accumulator with sign bit

            count = count - 1;

            // Step 3: Store Final Product After N Iterations
            if (count == 0) begin
                out = {accu, mr};       // Concatenate ACCU and MR
            end
        end
    end

endmodule
