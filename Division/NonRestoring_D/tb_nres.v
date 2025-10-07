`timescale 1ns/1ps

module tb_nr_division;

  parameter N = 4;             
  parameter Tclk = 10;         // Clock period in ns

  // Signals
  reg clk;
  reg rst;
  reg  [N-1:0] dd_in;          // Dividend
  reg  [N-1:0] dr_in;          // Divisor
  wire [N-1:0] quotient;       // Quotient
  wire [N-1:0] remainder;      // Remainder

  // Instantiate the DUT
  nr_division #(.N(N)) uut (
    .clk(clk),
    .rst(rst),
    .dd_in(dd_in),
    .dr_in(dr_in),
    .quotient(quotient),
    .remainder(remainder)
  );

  // Clock generation
  initial clk = 0;
  always #(Tclk/2) clk = ~clk;

  // Test sequence
  initial begin
    $dumpfile("nr_division.vcd");
    $dumpvars(0, tb_nr_division);

    // Initialize inputs
    rst   = 1;
    dd_in = 4'b0111;   // Dividend = 7
    dr_in = 4'b0010;   // Divisor  = 2
    #Tclk;
    rst = 0;

    // Wait for division to complete
    #(Tclk * (N + 1));

    // Display final result
    $display("-----------------------------------------------------");
    $display("Final Output => Time=%0t", $time);
    $display("Dividend = %0d | Divisor = %0d | Quotient = %0d | Remainder = %0d",
             dd_in, dr_in,
             quotient,remainder);
    $display("-----------------------------------------------------");


    rst   = 1;
    dd_in = 4'b0011;   // Dividend = 7
    dr_in = 4'b0101;   // Divisor  = 3
    #Tclk;
    rst = 0;

    // Wait for division to complete
    #(Tclk * (N + 1));

    // Display final result
    $display("-----------------------------------------------------");
    $display("Final Output => Time=%0t", $time);
    $display("Dividend = %0d | Divisor = %0d | Quotient = %0d | Remainder = %0d",
             dd_in, dr_in,
             quotient,remainder);
    $display("-----------------------------------------------------");

    $finish;
  end

  // Debug at every clock edge
  always @(posedge clk) begin
    $display("Time=%0t | Accumulator=%b | Divident=%b | Cnt=%d",
             $time, uut.accu, uut.dd,uut.cnt);
  end

endmodule
