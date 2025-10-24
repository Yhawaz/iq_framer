
`timescale 1 ns / 1 ps

	module iq_framer2 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S01_AXIS
		parameter integer C_S01_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S01_AXIS
		input wire  s01_axis_aclk,
		input wire  s01_axis_aresetn,
		output wire  s01_axis_tready,
		input wire [C_S01_AXIS_TDATA_WIDTH/2-1 : 0] s01_axis_tdata,
		input wire [(C_S01_AXIS_TDATA_WIDTH/8)-1 : 0] s01_axis_tstrb,
		input wire  s01_axis_tlast,
		input wire  s01_axis_tvalid,

		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH/2-1 : 0] s00_axis_tdata,
		input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready,
		output reg [3:0] probe,
		input wire [3:0] control
	);
// Instantiation of Axi Bus Interface S01_AXIS

	// Add user logic here
	reg [31:0] small_counter;
	reg [31:0] big_counter;
	
	assign m00_axis_tlast=(control[3]==1)? small_counter==65535:big_counter==262143;
	assign m00_axis_tdata = control==1?{small_counter, small_counter}:control==3?{big_counter, big_counter}:{s01_axis_tdata, s00_axis_tdata};
	assign m00_axis_tvalid = 1;
	assign m00_axis_tstrb = 4'b1111;
	

	always @(posedge s00_axis_aclk)begin
	
	   if(m00_axis_tready) begin
	       small_counter<=(small_counter==65535)? 0:small_counter+1;
	       big_counter<=(big_counter==262143)? 0:big_counter+1;
	   end
	end

	// User logic ends

	endmodule
