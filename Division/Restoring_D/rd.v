module r_division_signed #(
  parameter N = 4  // bit-width
)(
  input clk,
  input rst,
  input signed [N-1:0] dd_in,  //dividend
  input signed [N-1:0] dr_in,  // divisor
  output reg signed [(2*N)-1:0] out  // {remainder, quotient}
);

  // Internal signals
  reg [N-1:0] dr_abs;   //abs value needed for signed  no.
  reg [N-1:0] dd, accu, arth;
  reg [$clog2(N+1)-1:0] cnt;
  reg [N-1:0] inv_dr;
  reg quotient_sign;

  always @(posedge clk or posedge rst) begin
    if (rst) begin

      // absolute values
      dr_abs <= (dr_in[N-1]) ? -dr_in : dr_in;

      // internal registers
      dd    <= (dd_in[N-1]) ? -dd_in : dd_in;
      accu  <= {N{1'b0}};
      arth  <= {N{1'b0}};
      cnt   <= N;
      out   <= {(2*N){1'b0}};
      inv_dr <= ~( (dr_in[N-1]) ? -dr_in : dr_in ) + 1;

      // quotient sign
      quotient_sign <= dd_in[N-1] ^ dr_in[N-1];
    end 
    else if (cnt != 0) begin
      // Unsigned restoring division
      accu = {accu[N-2:0], dd[N-1]};
      arth = accu + inv_dr;

      if (arth[N-1]) begin
        // negative → restore
        arth = arth + dr_abs;
        accu = arth;
        dd   = {dd[N-2:0], 1'b0};
      end 
      else begin
        accu = arth;
        dd   = {dd[N-2:0], 1'b1};
      end

      cnt = cnt - 1;

      if (cnt == 0) begin
        // Assign quotient and remainder with correct signs
        out[N-1:0]   <= quotient_sign ? ~dd+1 : dd;       // quotient
        out[(2*N)-1:N] <= dd_in[N-1] ? ~accu+1 : accu;   // remainder
      end
    end
  end
endmodule
