`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:49:42 05/03/2024
// Design Name:   TinyMIPS
// Module Name:   C:/Users/gurhan/Desktop/gurhan/CSE224/sp24/Project/TinyMIPS/tb_TinyMIPS.v
// Project Name:  TinyMIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TinyMIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_TinyMIPS;
	parameter SIZE = 8, DEPTH = 2**SIZE;
	reg clk, rst;
	wire wrEn;
	wire [SIZE-1:0] addr_toRAM;
	wire [15:0] data_toRAM, data_fromRAM;
	
	TinyMIPS uut1 (clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

	blram #(SIZE, DEPTH) uut2 (clk, rst, wrEn, addr_toRAM, data_toRAM, data_fromRAM);

	initial begin
		clk = 1;
		forever
			#5 clk = ~clk;
	end

	initial begin
		rst = 1;
		repeat (10) @(posedge clk);
		rst <= #1 0;
		repeat (600) @(posedge clk);
		$finish;
	end

	initial begin
		// Test 1: Sum of 1 to 5
		uut2.mem[0] = 16'b0111001000000001; // CPi R1 1			// i = 1
		uut2.mem[1] = 16'b0111010000000000; // CPi R2 0			// sum = 0
		uut2.mem[2] = 16'b0111011000000110; // CPi R3 6			// max = 6
		uut2.mem[3] = 16'b0000010010001000; // ADD R2 R2 R1	// sum = sum + i
		uut2.mem[4] = 16'b0001001001000001; // ADDi R1 R1 1	// i++
		uut2.mem[5] = 16'b1001001011111110; // BLT R1 R3 -2	// if (i < max) then go back to address 5-2=3
	end
endmodule