
module mysystem (
	clock_bridge_0_in_clk_clk,
	fifo_fpga_to_hps_in_writedata,
	fifo_fpga_to_hps_in_write,
	fifo_fpga_to_hps_in_waitrequest,
	fifo_fpga_to_hps_in_csr_address,
	fifo_fpga_to_hps_in_csr_read,
	fifo_fpga_to_hps_in_csr_writedata,
	fifo_fpga_to_hps_in_csr_write,
	fifo_fpga_to_hps_in_csr_readdata,
	fifo_hps_to_fpga_out_readdata,
	fifo_hps_to_fpga_out_read,
	fifo_hps_to_fpga_out_waitrequest,
	fifo_hps_to_fpga_out_csr_address,
	fifo_hps_to_fpga_out_csr_read,
	fifo_hps_to_fpga_out_csr_writedata,
	fifo_hps_to_fpga_out_csr_write,
	fifo_hps_to_fpga_out_csr_readdata,
	hex5_0bus_export,
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
	ram_s2_address,
	ram_s2_chipselect,
	ram_s2_clken,
	ram_s2_write,
	ram_s2_readdata,
	ram_s2_writedata,
	ram_s2_byteenable,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	system_ref_clk_clk,
	system_ref_reset_reset,
	to_hex_to_led_readdata,
	sdram_clk_clk);	

	input		clock_bridge_0_in_clk_clk;
	input	[31:0]	fifo_fpga_to_hps_in_writedata;
	input		fifo_fpga_to_hps_in_write;
	output		fifo_fpga_to_hps_in_waitrequest;
	input	[2:0]	fifo_fpga_to_hps_in_csr_address;
	input		fifo_fpga_to_hps_in_csr_read;
	input	[31:0]	fifo_fpga_to_hps_in_csr_writedata;
	input		fifo_fpga_to_hps_in_csr_write;
	output	[31:0]	fifo_fpga_to_hps_in_csr_readdata;
	output	[31:0]	fifo_hps_to_fpga_out_readdata;
	input		fifo_hps_to_fpga_out_read;
	output		fifo_hps_to_fpga_out_waitrequest;
	input	[2:0]	fifo_hps_to_fpga_out_csr_address;
	input		fifo_hps_to_fpga_out_csr_read;
	input	[31:0]	fifo_hps_to_fpga_out_csr_writedata;
	input		fifo_hps_to_fpga_out_csr_write;
	output	[31:0]	fifo_hps_to_fpga_out_csr_readdata;
	output	[31:0]	hex5_0bus_export;
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
	input	[11:0]	ram_s2_address;
	input		ram_s2_chipselect;
	input		ram_s2_clken;
	input		ram_s2_write;
	output	[31:0]	ram_s2_readdata;
	input	[31:0]	ram_s2_writedata;
	input	[3:0]	ram_s2_byteenable;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input		system_ref_clk_clk;
	input		system_ref_reset_reset;
	output	[31:0]	to_hex_to_led_readdata;
	output		sdram_clk_clk;
endmodule
