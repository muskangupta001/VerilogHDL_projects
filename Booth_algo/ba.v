module booths_algo(
    input clk,
    input rst,
    input [3:0] mr_in,
    input [3:0] md,
    output reg [7:0] out
);

reg [3:0] mr, accu, arth;
reg q1;
reg [3:0] inv_md;
reg [2:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mr <= mr_in;
        accu <= 4'b0000;
        q1 <= 0;
        inv_md <= ~md + 1;  // 2's complement
        count <= 4;          // 4 iterations
        out <= 8'b0;
    end else if (count != 0) begin
        // Booth's decision
        if (mr[0] & ~q1)
            arth = accu + inv_md; // Subtract multiplicand
        else if (~mr[0] & q1)
            arth = accu + md;     // Add multiplicand
        else
            arth = accu;

        // Shifting step (your original code)
        q1 = mr[0];
        mr = {arth[0], mr[3:1]};
        accu = {arth[3], arth[3:1]};

        count = count - 1;

      if (count == 0)
            out <= {accu, mr};
    end
end

endmodule

    
    
