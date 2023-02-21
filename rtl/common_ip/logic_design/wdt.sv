// Code your design here
module wdt#(
)(
  input logic clk, 
  input logic rst,
  input logic alarm_set,
  input logic time_set,
  input logic up,
  input logic down,
  output logic [4:0] hr,
  output logic [5:0] mn,
  output logic [5:0] sc
);
  typedef enum logic [2:0] {
    SC = 3'b001,
    MN = 3'b010,
    HR = 3'b100
  } time_set_ptr;
  time_set_ptr tsp;
  int raw_clk_speed;
  
  always@(posedge clk) begin
    if(rst) begin
      raw_clk_speed <= 0; 
    end else begin
      raw_clk_speed <= raw_clk_speed + 1; 
    end
  end 
  
  always@(posedge clk or posedge time_set) begin
    if(rst) begin
      sc <= 0;
    end else begin
      sc <= (time_set && tsp == SC)? (up? sc +1: down? sc-1: sc) : (&raw_clk_speed[9:0] == 1)? sc+ 1: (sc == 'd59)? 'h0: sc;
    end 
  end
  
  always@(posedge clk or posedge time_set) begin
    if(rst) begin
      mn <= 0;
    end else begin
      mn <= (time_set && tsp == MN)? (up? mn +1: down? mn-1: mn) : (mn == 'd59 && sc == 'd59)? 'h0: (sc == 'd59)? mn+ 1: mn;
    end 
  end
  
  always@(posedge clk or posedge time_set) begin
    if(rst) begin
      hr <= 0;
    end else begin
      hr <= (time_set && tsp == HR)? (up? hr +1: down? hr-1: hr) : (hr == 'd23 && mn == 'd59 && sc == 'd59)? 'h0: (mn == 'd59 && sc == 'd59)? hr+ 1: hr;
    end 
  end
  
  always@(posedge clk or posedge time_set) begin
    if(rst || (tsp == HR && time_set)) begin
      tsp <= SC;
    end else begin
      if(time_set) begin
        tsp <= tsp << 1;
      end
    end
  end
  
endmodule
