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

    initial begin
    // Test 2: Addition and Branching
    uut2.mem[0] = 16'b0111010000000001; // CPi R1 1       // R1 = 1
    uut2.mem[1] = 16'b0111100000000010; // CPi R3 2       // R3 = 2
    uut2.mem[2] = 16'b0000010010000000; // ADD R2 R1 R0  // R2 = R1 + R0 (R0 = 0)
    uut2.mem[3] = 16'b0000010100010000; // ADD R4 R1 R2  // R4 = R1 + R2 (R1 = 1, R2 = 1)
    uut2.mem[4] = 16'b1001100100111010; // BLT R1 R3 -6   // if (R1 < R3) then PC = PC - 6
    uut2.mem[5] = 16'b0111111000000000; // CPi R7 0       // R7 = 0
    uut2.mem[6] = 16'b0000100000000000; // ADD R0 R0 R0  // R0 = R0 + R0 (R0 = 0)
    uut2.mem[7] = 16'b0000100001000000; // ADD R0 R0 R1  // R0 = R0 + R1 (R0 = 1)
    uut2.mem[8] = 16'b0001000100000001; // ADDi R1 R0 1   // R1 = R1 + 1 (R1 = 2)
    uut2.mem[9] = 16'b1001100100111010; // BLT R1 R3 -6   // if (R1 < R3) then PC = PC - 6
    uut2.mem[10] = 16'b0000000000000000; // Halt
end

initial begin
    // Test 3: Multiplication and Immediate Branching
    uut2.mem[0] = 16'b0111010000000010; // CPi R1 2       // R1 = 2
    uut2.mem[1] = 16'b0111100000000011; // CPi R3 3       // R3 = 3
    uut2.mem[2] = 16'b1110010010000000; // MUL R2 R1 R0   // R2 = R1 * R0 (R0 = 0)
    uut2.mem[3] = 16'b1110010100010000; // MUL R4 R1 R2   // R4 = R1 * R2 (R1 = 2, R2 = 0)
    uut2.mem[4] = 16'b1000100111111010; // BLTi R1 6      // if (R1 < 6) then PC = PC + 6
    uut2.mem[5] = 16'b0111111000000000; // CPi R7 0       // R7 = 0
    uut2.mem[6] = 16'b0000100000000000; // ADD R0 R0 R0  // R0 = R0 + R0 (R0 = 0)
    uut2.mem[7] = 16'b0000100001000000; // ADD R0 R0 R1  // R0 = R0 + R1 (R0 = 2)
    uut2.mem[8] = 16'b0001000100000001; // ADDi R1 R0 1   // R1 = R1 + 1 (R1 = 3)
    uut2.mem[9] = 16'b1000100111111010; // BLTi R1 6      // if (R1 < 6) then PC = PC + 6
    uut2.mem[10] = 16'b0000000000000000; // Halt
end

initial begin
    // Test 4: NAND and Immediate Copy Instructions
    uut2.mem[0] = 16'b0111010000000101; // CPi R1 5       // R1 = 5
    uut2.mem[1] = 16'b0111100000000010; // CPi R3 2       // R3 = 2
    uut2.mem[2] = 16'b0010110010000000; // NAND R2 R1 R0  // R2 = ~(R1 & R0) (R0 = 0)
    uut2.mem[3] = 16'b0010110100010000; // NAND R4 R1 R2  // R4 = ~(R1 & R2) (R1 = 5, R2 = 0)
    uut2.mem[4] = 16'b1010100111111010; // BLTi R1 6      // if (R1 < 6) then PC = PC + 6
    uut2.mem[5] = 16'b1000100111111010; // BLTi R1 6      // if (R1 < 6) then PC = PC + 6
    uut2.mem[6] = 16'b0111111000000000; // CPi R7 0       // R7 = 0
    uut2.mem[7] = 16'b0000100000000000; // ADD R0 R0 R0  // R0 = R0 + R0 (R0 = 0)
    uut2.mem[8] = 16'b0000100001000000; // ADD R0 R0 R1  // R0 = R0 + R1 (R0 = 5)
    uut2.mem[9] = 16'b0001000100000001; // ADDi R1 R0 1   // R1 = R1 + 1 (R1 = 6)
    uut2.mem[10] = 16'b1000100111111010; // BLTi R1 6      // if (R1 < 6) then PC = PC + 6
    uut2.mem[11] = 16'b0000000000000000; // Halt
end

endmodule