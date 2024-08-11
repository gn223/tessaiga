module single_line_cache#(
  parameter ADDR_WIDTH = 52,
  parameter DATA_WIDTH = 512,
  parameter ARRY_DEPTH = 1,
  parameter CACHE_LINE_SIZE = 64
)(
  input logic clk,
  input logic rst,
  input logic val,
  input logic rw,
  input logic [ADDR_WIDTH-1:0] addr,
  inout logic [DATA_WIDTH-1:0] data,
  output logic rdy,
  output logic hit
);

  localparam CACHE_LSB = ($clog2(CACHE_LINE_SIZE));
  struct {
    logic val;
    logic [ADDR_WIDTH-1:0] addr; 
  } tag_arr_s;
  tag_arr_s tag_arr[ARRY_DEPTH];
  logic [DATA_WIDTH-1:0] data_arr[ARRY_DEPTH]; 

  always@(posedge clk) begin
    if(!rst) begin
      rdy <= 'h1;
      data <= 'h0;
    end else begin
      if(val && rdy) begin
        if(rw)begin
          rdy <= 'h0;
          if(tag_arr.val) begin
            if(addr[ADDR_WIDTH-1:CACHE_LSB] == tag_arr.addr[ADDR_WIDTH-1:CACHE_LSB]) begin
              hit <= 'h1;
	      `ifdef CXL_32B_ACCESS		
	      data <= addr[CACHE_LSB]? data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)]: data_arr[0][(((ADDR_WIDTH)/2)-1):0];
	      `else 
	      data <= data_arr[0];
	      `endif
            end else begin
              hit <= 'h0;
              data <= {((DATA_WIDTH)/16){'hdead}};
            end
          end else begin
            hit <= 'h0;
            data <= {((DATA_WIDTH)/16){'hdead}};
          end
        end else begin
          rdy <= 'h1;
          if(tag_arr.val) begin
            if(addr[ADDR_WIDTH-1:CACHE_LSB] == tag_arr.addr[ADDR_WIDTH-1:CACHE_LSB]) begin
              hit <= 'h1;
	      `ifdef CXL_32B_ACCESS		
 	      if(addr[CACHE_LSB]) begin
	        data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= data[(ADDR_WIDTH-1):(ADDR_WIDTH/2)];
	        data_arr[0][((ADDR_WIDTH/2)-1):0] <= 'h0;
	      end else begin
	        data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= 'h0;
	        data_arr[0][((ADDR_WIDTH/2)-1):0] <= data[((ADDR_WIDTH/2)-1):0];
	      end
	      `else
	      data_arr <= data;
	      `endif
            end else begin
	      hit <= 'h0;
              tag_arr.addr <= addr;
	      `ifdef CXL_32B_ACCESS		
 	      if(addr[CACHE_LSB]) begin
	        data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= data[(ADDR_WIDTH-1):(ADDR_WIDTH/2)];
	        data_arr[0][((ADDR_WIDTH/2)-1):0] <= 'h0;
	      end else begin
	        data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= 'h0;
	        data_arr[((ADDR_WIDTH/2)-1):0] <= data[((ADDR_WIDTH/2)-1):0];
	      end
	      `else
	      data_arr[0] <= data;
	      `endif
	    end
	  end else begin
	    hit <= 'h0;
            tag_arr.val <= val;
            tag_arr.addr <= addr;
	    `ifdef CXL_32B_ACCESS		
 	    if(addr[CACHE_LSB]) begin
	      data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= data[(ADDR_WIDTH-1):(ADDR_WIDTH/2)];
	      data_arr[0][((ADDR_WIDTH/2)-1):0] <= 'h0;
	    end else begin
	      data_arr[0][(ADDR_WIDTH-1):(ADDR_WIDTH/2)] <= 'h0;
	      data_arr[0][((ADDR_WIDTH/2)-1):0] <= data[((ADDR_WIDTH/2)-1):0];
	    end
	    `else
	    data_arr[0] <= data;
	    `endif
	  end		
        end
      end 
    end
  end

endmodule
