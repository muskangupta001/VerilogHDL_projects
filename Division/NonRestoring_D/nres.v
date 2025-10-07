module nr_division #(
  parameter N = 4              
)(
  input  wire clk,
  input  wire rst,
  input  wire [N-1:0] dd_in,    // Dividend
  input  wire [N-1:0] dr_in,    // Divisor
  output reg  [N-1:0] quotient, // Quotient 
  output reg  [N-1:0] remainder // Remainder 
);

  reg [N-1:0] dd;               //Divident operation will be done on this (quotient)
  reg [N-1:0] accu;             // Accumulator (partial remainder)
  reg [N-1:0] arth;             // Arithmetic result (temp)
  reg [$clog2(N+1)-1:0] cnt;    // Counter for N iterations
  reg [N-1:0] inv_dr;           // Two's complement of divisor
  reg flg;                      // 0 -> subtract, 1 -> Addition

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      accu      = {N{1'b0}};
      dd        = dd_in;
      arth      = {N{1'b0}};
      cnt       = N;
      quotient  = {N{1'b0}};
      remainder = {N{1'b0}};
      inv_dr    = ~dr_in + 1;   // Two's complement (for subtraction)
      flg       = 0;
    end
    else if (cnt != 0) begin
      // Step 1: Shift left {accu, dd}
      accu = {accu[N-2:0], dd[N-1]};
      
      // Step 2: Based on flg reg decided whether to do addtion or subtraction
      case (flg)
        0: arth = accu + inv_dr; // Sub divisor
        1: arth = accu + dr_in;  // Add divisor
      endcase

      // Step 3: Check sign and update quotient bit
      if (arth[N-1]) begin       // If negative ,then in next step we will perform add
        flg = 1;
        accu = arth;
        dd = {dd[N-2:0], 1'b0};   //updating quotient
      end
      else begin                 // Positive , then next step will be sub
        flg = 0;
        accu = arth;
        dd = {dd[N-2:0], 1'b1};   //updating quotient
      end

      cnt = cnt - 1;

      // Step 4: After all iterations, final correction
      if (cnt == 0) begin
        if (arth[N-1])
          accu = accu + dr_in; // if in last step accumulation value is negative, we will restore it

        remainder = accu;
        quotient  = dd;
      end
    end
  end
endmodule
