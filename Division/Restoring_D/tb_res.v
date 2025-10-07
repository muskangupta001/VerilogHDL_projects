`timescale 1ns/1ps

module tb_r_division;

  parameter N = 4;           // Bit width
  parameter Tclk = 10;       // Clock period = 10ns
  
  // Testbench signals
  reg clk;
  reg rst;
  reg signed [N-1:0] dd_in;  // Dividend
  reg signed [N-1:0] dr_in;  // Divisor

  wire signed [N-1:0] quotient;
  wire signed [N-1:0] remainder;

  // DUT instantiation
  r_division #(N) uut (
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
    $dumpfile("restoring_d.vcd");
    $dumpvars(0, tb_r_division);
    
    //Test1
    rst   = 1;
    dd_in = 4'b0111;   // 7
    dr_in = 4'b0010;   // 2
    #Tclk;
    rst = 0;

    #(Tclk * (N + 1));
    // Display final result
    $display("-----------------------------------------------------");
    $display("TEST 1 Output => Time=%0t", $time);
    $display(" Dividend=%0d, Divisor=%0d => Quotient=%0d, Remainder=%0d",
              $signed(dd_in), $signed(dr_in), $signed(quotient), $signed(remainder));
     $display("-----------------------------------------------------");

    //Test2 
    rst   = 1;
    dd_in = 4'b1011;   // -5
    dr_in = 9'b0011;   // +3
    #Tclk;
    rst = 0;

    #(Tclk * (N + 1));
    $display("-----------------------------------------------------");
    $display("TEST 2 Output => Time=%0t", $time);
    $display(" Dividend=%0d, Divisor=%0d => Quotient=%0d, Remainder=%0d",
              $signed(dd_in), $signed(dr_in), $signed(quotient), $signed(remainder));
     $display("-----------------------------------------------------");

    $finish;
  end

  // Debug at every clock edge
  always @(posedge clk) begin
    $display("Time=%0t | Accumulator=%b | Divident=%b | Cnt=%d ",
             $time, uut.accu, uut.dd,uut.cnt);
  end

endmodule
