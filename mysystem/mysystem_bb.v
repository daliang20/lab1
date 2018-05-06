
module mysystem (
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	pushbutton_export,
	system_ref_clk_clk,
	system_ref_reset_reset,
	sdram_clk_clk,
	to_hex_to_led_readdata,
	hex5_0bus_export);	

	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
	input	[3:0]	pushbutton_export;
	input		system_ref_clk_clk;
	input		system_ref_reset_reset;
	output		sdram_clk_clk;
	output	[31:0]	to_hex_to_led_readdata;
	output	[31:0]	hex5_0bus_export;
endmodule
