`timescale 1ns/1ps

module tb_booths_algo;

reg clk;
reg rst;
reg [3:0] mr_in;
reg [3:0] md;
wire [7:0] out;

// Instantiate the Booth's multiplier
booths_algo uut (
    .clk(clk),
    .rst(rst),
    .mr_in(mr_in),
    .md(md),
    .out(out)
);

// Clock generation: 10ns period
initial clk = 0;
always #5 clk = ~clk;

// Test sequence
initial begin
    // Dump waveform
    $dumpfile("booths_shift.vcd");
    $dumpvars(0, tb_booths_algo);

    // Test Case 1
    rst = 1; mr_in = 4'b0111; md = 4'b0101; #10;
    rst = 0;        
    #50;             // Wait for 4 iterations

    $finish;
end

// Optional: print output at each positive edge
always @(posedge clk) begin
    $display("Time=%0t | ACC=%b | MR=%b | OUT=%b", $time, uut.accu, uut.mr, out);
end

endmodule
