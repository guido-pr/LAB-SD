module clock_div(input clk, output reg new_clk);

  // definir a velocidade
  // fator_vel = clk/velocidade desejada x 2

    localparam fator_vel =26'd25000000;
  
    reg [25:0] count;
    always @ (posedge clk)
    begin
      if (count == fator_vel) begin
          count = 26'b0;
          new_clk = ~new_clk;
      end
      else begin
          count = count + 1'b1;
          new_clk = new_clk;
      end
    end
endmodule
        
