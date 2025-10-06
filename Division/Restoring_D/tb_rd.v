`timescale 1ns/1ps

module tb_r_division;

 
  parameter N = 4;  
  parameter Tclk = 10; 
  
  //  Signals
  reg clk;
  reg rst;
  reg  [N-1:0] dd_in;   // dividend
  reg  [N-1:0] dr_in;   // divisor
  wire [(2*N)-1:0] out; // {remainder, quotient}

 
  r_division_signed #(N) uut (
    .clk(clk),
    .rst(rst),
    .dd_in(dd_in),
    .dr_in(dr_in),
    .out(out)
  );

  // Clock Generation
  initial clk = 0;
  always #(Tclk/2) clk = ~clk;  // 10ns clock period


  initial begin
    $dumpfile("restoring_d.vcd");
    $dumpvars(0, tb_r_division);
    
    // Initialize
    rst   = 1;
    dd_in = 4'b1001;   // Dividend = -7
    dr_in = 4'b0011;   // Divisor  = 3
    #10;
    rst = 0;

    // Wait for operation to finish
     #(Tclk * (N + 1)); 
     $display("Final Output => Time=%0t | Dividend=%0d | Divisor=%0d | Quotient=%0d | Remainder=%0d",
              $time, $signed(dd_in),$signed( dr_in), $signed(out[N-1:0]), $signed(out[(2*N)-1:N]));
    
    rst   = 1;
    dd_in = 4'b0100;   // Dividend = 4
    dr_in = 4'b0010;   // Divisor  = 2
    #10;
    rst = 0;

    // Wait for operation to finish
     #(Tclk * (N + 1)); 

    // Display Final Output
    $display("Final Output => Time=%0t | Dividend=%0d | Divisor=%0d | Quotient=%0d | Remainder=%0d",
             $time, $signed(dd_in),$signed( dr_in), $signed(out[N-1:0]), out[(2*N)-1:N]);

    $finish;
  end

  // Internal States
  always @(posedge clk) begin
    $display("Time=%0t | ACCU=%b | DD=%b | OUT(quotient)=%b | OUT(remainder)=%b",
             $time, uut.accu, uut.dd, out[N-1:0], out[(2*N)-1:N]);
  end

endmodule
