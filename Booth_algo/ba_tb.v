`timescale 1ns/1ps

module tb_booths_algo;

    parameter N = 4;
    parameter Tclk = 10;  // time period 10ns
  
    reg clk;
    reg rst;
    reg [N-1:0] mr_in;
    reg [N-1:0] md;
    wire [2*N-1:0] out;

    // Instantiate the Booth's multiplier
    booths_algo #(N) uut (
        .clk(clk),
        .rst(rst),
        .mr_in(mr_in),
        .md(md),
        .out(out)
    );

    // Clock generation
    initial clk = 0;
    always #(Tclk/2) clk = ~clk;

    // Test sequence
    initial begin
        
        $dumpfile("booths_shift.vcd");
        $dumpvars(0, tb_booths_algo);

        // Test Case 1
        rst = 1;
        mr_in = 4'b0111; //7
        md    = 4'b0101; //5
        #10;
        rst = 0;
        
        #(Tclk * (N + 1));              // Wait for N iterations
         $display("-----------------------------------------------------");
         $display("Test1 Output => Time=%0t | Multiplier=%0d | Multiplicant=%0d | Output=%0d",
         $time, $signed(mr_in), $signed(md), $signed(out));
         $display("-----------------------------------------------------");

        
        // Test Case 2
        rst = 1; 
        mr_in = 4'b0011;  //3
        md    = 4'b1011;  //-5
        #10;
        rst = 0;
        
      #(Tclk * (N + 1));               // Wait for N iterations
      $display("-----------------------------------------------------"); 
      $display("Test2 Output => Time=%0t | Multiplier=%0d | Multiplicant=%0d | Output=%0d",
         $time, $signed(mr_in), $signed(md), $signed(out));
      $display("-----------------------------------------------------");


        $finish;
    end

    // print output at each positive edge
    always @(posedge clk) begin
        $display("Time=%0t | ACC=%b | MR=%b | OUT=%b", $time, uut.accu, uut.mr, out);
    end

endmodule
