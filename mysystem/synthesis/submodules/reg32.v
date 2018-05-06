module reg32(
	input clock, 
	input reset_n,
	input [31:0] D,
	input [3:0] byteenable,
	output [31:0] Q
); 

reg [31:0] ram;

always @(posedge clock) 
begin 
	if(reset_n) 
	begin 
		ram <= 0;
	end 
	else 
	begin
		case(byteenable)
			4'b1111: ram <= D;
			4'b0011: ram[15:0]  <= D[15:0];
			4'b1100: ram[31:16] <= D[31:16];
			4'b0001: ram[7:0]   <= D[7:0]; 
			4'b0010: ram[15:8]  <= D[15:8];
			4'b0100: ram[23:16] <= D[23:16];
			4'b1000: ram[31:24] <= D[31:24];
			default: ram <= ram;
		endcase
	end 
end 

assign Q = ram;

endmodule 