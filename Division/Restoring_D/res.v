module r_division #(
  parameter N = 4  
)(
  input  wire clk,                       // Clock signal
  input  wire rst,                       // Active-high reset
  input  wire signed [N-1:0] dd_in,      // Dividend 
  input  wire signed [N-1:0] dr_in,      // Divisor 
  output reg  signed [N-1:0] quotient,   // Quotient 
  output reg  signed [N-1:0] remainder   // Remainder 
);

  reg [N-1:0] dr_abs;     // Absolute value of divisor
  reg [N-1:0] dd;         // Divident operation will be done on this
  reg [N-1:0] accu;       // Accumulator (partial remainder)
  reg [N-1:0] arth;       // Temporary arithmetic result
  reg [N-1:0] inv_dr;     // Two’s complement of divisor
  reg [$clog2(N+1)-1:0] cnt; // Iteration counter
  reg quotient_sign;      // Sign of quotient (determined by input signs)


  always @(posedge clk or posedge rst) begin
    if (rst) begin
      //  Step 1: Initialize all registers 
      dr_abs        = (dr_in[N-1]) ? -dr_in : dr_in;   
      dd            = (dd_in[N-1]) ? -dd_in : dd_in;   
      accu          = {N{1'b0}};                       
      arth          = {N{1'b0}};    
      quotient      = {N{1'b0}};
      remainder     = {N{1'b0}};                    
      cnt           = N;                                
      inv_dr        = ~((dr_in[N-1]) ? -dr_in : dr_in) + 1; 
      quotient_sign = dd_in[N-1] ^ dr_in[N-1];          // XOR of signs for quotient
    end 

    else if (cnt != 0) begin
      // Step 2: Shift left 
      accu = {accu[N-2:0], dd[N-1]};

      // Step 3: Subtract divisor from partial remainder(divident)
      arth = accu + inv_dr;

      // Step 4: Check if result is negative 
      if (arth[N-1]) begin
        // If negative, restore (add divisor back) and and set quotient bit to 1
        arth = arth + dr_abs;
        accu = arth;
        dd   = {dd[N-2:0], 1'b0}; 
      end 
      else begin
        // If positive, keep result and set quotient bit to 1
        accu = arth;
        dd   = {dd[N-2:0], 1'b1};
      end

    
      cnt = cnt - 1;

      // Step 5: Final correction and sign adjustment
      if (cnt == 0) begin
        quotient  = quotient_sign ?  ~dd+1 : dd;
        remainder = dd_in[N-1] ? ~accu+1 : accu; 
      end
    end
  end
endmodule
