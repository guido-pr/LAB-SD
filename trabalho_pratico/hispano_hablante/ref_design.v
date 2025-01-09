module topMotor( clk, M, B);

input clk;
output reg [3:0] M;
output reg [3:0] B;

reg [2:0] cont;

initial begin
    M = 4'b0000;
    B = 4'b0000;
    cont = 3'b000;
end

div_m div(clk, clk_1);

always @(posedge clk_1) begin
    case (cont)
        3'b000: begin M <= 4'b0001; B <= 4'b1001; end
        3'b001: begin M <= 4'b0010; B <= 4'b1000; end
        3'b010: begin M <= 4'b0100; B <= 4'b1100; end
        3'b011: begin M <= 4'b1000; B <= 4'b0100; end
        3'b100: begin M <= 4'b1000; B <= 4'b0010; end
        3'b101: begin M <= 4'b1100; B <= 4'b0001; end
        3'b110: begin M <= 4'b0110; B <= 4'b0001; end
        3'b111: begin M <= 4'b0011; B <= 4'b0001; end
        default: begin cont <= 3'b000; end
    endcase

    cont <= cont + 3'b001;
end

endmodule
