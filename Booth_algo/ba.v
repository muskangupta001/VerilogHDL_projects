module booths_algo #(
    parameter N = 4           
)(
    input clk,
    input rst,
    input [N-1:0] mr_in,      // Multiplier
    input [N-1:0] md,         // Multiplicand
    output reg [2*N-1:0] out  // Product is 2*N bits
);

reg [N-1:0] mr, accu, arth;
reg q1;
reg [N-1:0] inv_md;
reg [$clog2(N):0] count;      // Enough bits to count up to N

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mr <= mr_in;
        accu <= {N{1'b0}};
        q1 <= 0;
        inv_md <= ~md + 1;      
        count <= N;             // N iterations
        out <= {2*N{1'b0}};
    end 
  
     else if (count != 0) begin
        // Booth's decision
        if (mr[0] & ~q1)
            arth = accu + inv_md; // Subtract multiplicand
        else if (~mr[0] & q1)
            arth = accu + md;     // Add multiplicand
        else
            arth = accu;         // remain same 

        // Shifting step 
        q1 = mr[0];
        mr = {arth[0], mr[N-1:1]};
        accu = {arth[N-1], arth[N-1:1]};

        count = count - 1;

       if (count == 0)begin
            out <= {accu, mr};
          
       end
    end
end
  
endmodule
