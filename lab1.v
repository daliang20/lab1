module lab1(
	//Clock Pins
	CLOCK_50, 
	
	// HEX Declarations
	HEX0, 
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	
	// General PIO
	SW,
	KEY,
	LEDR,
	
	//HPS DDR3 Declarations
	HPS_DDR3_ADDR, 
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE, 
	HPS_DDR3_CK_N,	
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM, 
	HPS_DDR3_DQ, 
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ, 
	HPS_DDR3_WE_N,
	
	// DRAM PORTS
	DRAM_CLK,
	DRAM_ADDR, 
	DRAM_DQ, // DRAM DATA
	DRAM_BA, // DRAM Bank Address
	DRAM_RAS_N, // DRAM Row Address Strobe
	DRAM_CAS_N, // DRAM Column Address Strobe
	DRAM_CKE, 	// DRAM Clock Enable 
	DRAM_WE_N, 
	DRAM_CS_N,
	DRAM_LDQM, 
	DRAM_UDQM
);

input CLOCK_50; 
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
input [3:0] KEY; 
output [9:0] LEDR; 
input [9:0] SW; 

output [14:0] 	HPS_DDR3_ADDR;
output [2:0]	HPS_DDR3_BA;
output HPS_DDR3_CAS_N;
output HPS_DDR3_CKE; 
output HPS_DDR3_CK_N;	
output HPS_DDR3_CK_P;
output HPS_DDR3_CS_N;
output [3:0] HPS_DDR3_DM; 
inout [31:0] HPS_DDR3_DQ; 
inout [3:0]	HPS_DDR3_DQS_N;
inout [3:0]	HPS_DDR3_DQS_P;
output HPS_DDR3_ODT;
output HPS_DDR3_RAS_N;
output HPS_DDR3_RESET_N;
input HPS_DDR3_RZQ; 
output HPS_DDR3_WE_N;

output [12:0] DRAM_ADDR; 
output [1:0] DRAM_BA;
output DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK;
output DRAM_CKE, DRAM_CS_N, DRAM_WE_N;
output DRAM_UDQM; 
output DRAM_LDQM;
inout [15:0] DRAM_DQ;


wire [31:0] hex5_0bus;

// These two form {led, hex} to_hex_to_led
wire [31:0] hex;


hex2seg f1(.hex(hex[3:0]), .seg(HEX0));
hex2seg f2(.hex(hex[7:4]), .seg(HEX1));
hex2seg f3(.hex(hex[11:8]), .seg(HEX2));     
hex2seg f4(.hex(hex[15:12]), .seg(HEX3));
hex2seg f5(.hex(hex[19:16]), .seg(HEX4));
hex2seg f6(.hex(hex[23:20]), .seg(HEX5));

//=======================================================
// HPS_to_FPGA FIFO state machine
//=======================================================
// --Check for data
//
// --Read data 
// --add one
// --write to SRAM
// --signal HPS data_ready
//=======================================================
// Controls for Qsys sram slave exported in system module
//=======================================================
wire [31:0] sram_readdata ;
reg [31:0] sram_writedata ;
reg [7:0] sram_address; 
reg sram_write ;
wire sram_clken = 1'b1;
wire sram_chipselect = 1'b1;
reg [7:0] state ;

//=======================================================
// Controls for HPS_to_FPGA FIFO
//=======================================================

reg [31:0] hps_to_fpga_readdata ; 
reg hps_to_fpga_read ; // read command
// status addresses
// base => fill level
// base+1 => status bits; 
//           bit0==1 if full
//           bit1==1 if empty
wire [31:0] hps_to_fpga_out_csr_address = 32'd1 ; // fill_level
reg[31:0] hps_to_fpga_out_csr_readdata ;
reg hps_to_fpga_out_csr_read ; // status regs read cmd
reg [7:0] HPS_to_FPGA_state ;
reg [31:0] data_buffer ;
reg data_buffer_valid ;

//=======================================================
// Controls for FPGA_to_HPS FIFO
//=======================================================

reg [31:0] fpga_to_hps_in_writedata ; 
reg fpga_to_hps_in_write ; // write command
// status addresses
// base => fill level
// base+1 => status bits; 
//           bit0==1 if full
//           bit1==1 if empty
wire [31:0] fpga_to_hps_in_csr_address = 32'd1 ; // fill_level
reg[31:0] fpga_to_hps_in_csr_readdata ;
reg fpga_to_hps_in_csr_read ; // status regs read cmd
reg [7:0] FPGA_to_HPS_state ;

//=======================================================
// do the work outlined above
always @(posedge CLOCK_50) begin // CLOCK_50

   // reset state machine and read/write controls
	if (~KEY[0]) begin
		HPS_to_FPGA_state <= 8'd0 ;
		sram_write <= 1'b0 ;
	end
	
	// =================================
	// HPS_to_FPGA state machine
	//==================================
	// Is there data in HPS_to_FPGA FIFO
	// and the last transfer is complete
	if (HPS_to_FPGA_state == 8'd0 && !(hps_to_fpga_out_csr_readdata[1]) && !data_buffer_valid)  begin
		hps_to_fpga_read <= 1'b1 ;
		HPS_to_FPGA_state <= 8'd2 ; //
	end
	
	// delay
	if (HPS_to_FPGA_state == 8'd2) begin
		// zero the read request BEFORE the data appears 
		// in the next state!
		hps_to_fpga_read <= 1'b0 ;
		HPS_to_FPGA_state <= 8'd4 ;
	end
	
	// read the word from the FIFO
	if (HPS_to_FPGA_state == 8'd4) begin
		data_buffer <= hps_to_fpga_readdata ; // send back data
		data_buffer_valid <= 1'b1 ; // set the data ready flag
		hps_to_fpga_read <= 1'b0 ;
		HPS_to_FPGA_state <= 8'd0 ; //6
	end
	
	// =================================
	// FPGA_to_HPS state machine
	//================================== 
	// is there space in the 
	// FPGA_to_HPS FIFO
	// and data is available
	if (FPGA_to_HPS_state==0 && !(fpga_to_hps_in_csr_readdata[0]) && data_buffer_valid) begin
		fpga_to_hps_in_writedata <= data_buffer ;	
		fpga_to_hps_in_write <= 1'b1 ;
		FPGA_to_HPS_state <= 8'd4 ;
	end
	
	// finish the write to FPGA_to_HPS FIFO
	//if (HPS_to_FPGA_state == 8'd8) begin
	if (FPGA_to_HPS_state==4) begin
		fpga_to_hps_in_write <= 1'b0 ;
		data_buffer_valid <= 1'b0 ; // used the data, so clear flag
		FPGA_to_HPS_state <= 8'd0 ;
	end
	
	//==================================
end // always @(posedge state_clock)


/*
    mysystem u0 (
        .hex5_0bus_export       (hex5_0bus),       //        hex5_0bus.export
        .memory_mem_a           (HPS_DDR3_ADDR),           //           memory.mem_a
        .memory_mem_ba          (HPS_DDR3_BA),          //                 .mem_ba
        .memory_mem_ck          (HPS_DDR3_CK_P),          //                 .mem_ck
        .memory_mem_ck_n        (HPS_DDR3_CK_N),        //                 .mem_ck_n
        .memory_mem_cke         (HPS_DDR3_CKE),         //                 .mem_cke
        .memory_mem_cs_n        (HPS_DDR3_CS_N),        //                 .mem_cs_n
        .memory_mem_ras_n       (HPS_DDR3_RAS_N),       //                 .mem_ras_n
        .memory_mem_cas_n       (HPS_DDR3_CAS_N),       //                 .mem_cas_n
        .memory_mem_we_n        (HPS_DDR3_WE_N),       //                 .mem_we_n
        .memory_mem_reset_n     (HPS_DDR3_RESET_N),     //                 .mem_reset_n
        .memory_mem_dq          (HPS_DDR3_DQ),          //                 .mem_dq
        .memory_mem_dqs         (HPS_DDR3_DQS_P),         //                 .mem_dqs
        .memory_mem_dqs_n       (HPS_DDR3_DQS_N),       //                 .mem_dqs_n
        .memory_mem_odt         (HPS_DDR3_ODT),         //                 .mem_odt
        .memory_mem_dm          (HPS_DDR3_DM),          //                 .mem_dm
        .memory_oct_rzqin       (HPS_DDR3_RZQ),       //                 .oct_rzqin
        .pushbutton_export      (~KEY[3:1]),      //       pushbutton.export
        .sdram_clk_clk          (DRAM_CLK),          //        sdram_clk.clk
        .sdram_wire_addr        (DRAM_ADDR),        //       sdram_wire.addr
        .sdram_wire_ba          (DRAM_BA),          //                 .ba
        .sdram_wire_cas_n       (DRAM_CAS_N),       //                 .cas_n
        .sdram_wire_cke         (DRAM_CKE),         //                 .cke
        .sdram_wire_cs_n        (DRAM_CS_N),        //                 .cs_n
        .sdram_wire_dq          (DRAM_DQ),          //                 .dq
        .sdram_wire_dqm         ({DRAM_UDQM, DRAM_LDQM}),         //                 .dqm
        .sdram_wire_ras_n       (DRAM_RAS_N),       //                 .ras_n
        .sdram_wire_we_n        (DRAM_WE_N),        //                 .we_n
        .system_ref_clk_clk     (CLOCK_50),     //   system_ref_clk.clk
        .system_ref_reset_reset (~KEY[0]), // system_ref_reset.reset
        .to_hex_to_led_readdata (hex)  //    to_hex_to_led.readdata
    );
*/
	 
    mysystem u0 (
        .clock_bridge_0_in_clk_clk          (CLOCK_50),          //    clock_bridge_0_in_clk.clk
		
		/* FPGA TO HPS */
        .fifo_fpga_to_hps_in_writedata      (fpga_to_hps_in_writedata),      //      fifo_fpga_to_hps_in.writedata
        .fifo_fpga_to_hps_in_write          (fpga_to_hps_in_write),          //                         .write
        .fifo_fpga_to_hps_in_waitrequest    (),    //                         .waitrequest
        .fifo_fpga_to_hps_in_csr_address    (32'd1),    //  fifo_fpga_to_hps_in_csr.address
        .fifo_fpga_to_hps_in_csr_read       (1'b1),       //                         .read
        .fifo_fpga_to_hps_in_csr_writedata  (),  //                         .writedata
        .fifo_fpga_to_hps_in_csr_write      (1'b0),      //                         .write
        .fifo_fpga_to_hps_in_csr_readdata   (fpga_to_hps_in_csr_readdata),   //                         .readdata
		
		/* HPS TO FPGA */
        .fifo_hps_to_fpga_out_readdata      (hps_to_fpga_readdata),      //     fifo_hps_to_fpga_out.readdata
        .fifo_hps_to_fpga_out_read          (hps_to_fpga_read),          //                         .read
        .fifo_hps_to_fpga_out_waitrequest   (),   //                         .waitrequest
        .fifo_hps_to_fpga_out_csr_address   (32'd1),   // fifo_hps_to_fpga_out_csr.address
        .fifo_hps_to_fpga_out_csr_read      (1'b1),      //                         .read
        .fifo_hps_to_fpga_out_csr_writedata (), //                         .writedata
        .fifo_hps_to_fpga_out_csr_write     (1'b0),     //                         .write
        .fifo_hps_to_fpga_out_csr_readdata  (hps_to_fpga_out_csr_readdata),  //                         .readdata

		/* HEX STUFF */
        .hex5_0bus_export                   (hex5_0bus),                   //                hex5_0bus.export

		/* HPS DDR3 MEMORY */
		.memory_mem_a           (HPS_DDR3_ADDR),           //           memory.mem_a
        .memory_mem_ba          (HPS_DDR3_BA),          //                 .mem_ba
        .memory_mem_ck          (HPS_DDR3_CK_P),          //                 .mem_ck
        .memory_mem_ck_n        (HPS_DDR3_CK_N),        //                 .mem_ck_n
        .memory_mem_cke         (HPS_DDR3_CKE),         //                 .mem_cke
        .memory_mem_cs_n        (HPS_DDR3_CS_N),        //                 .mem_cs_n
        .memory_mem_ras_n       (HPS_DDR3_RAS_N),       //                 .mem_ras_n
        .memory_mem_cas_n       (HPS_DDR3_CAS_N),       //                 .mem_cas_n
        .memory_mem_we_n        (HPS_DDR3_WE_N),       //                 .mem_we_n
        .memory_mem_reset_n     (HPS_DDR3_RESET_N),     //                 .mem_reset_n
        .memory_mem_dq          (HPS_DDR3_DQ),          //                 .mem_dq
        .memory_mem_dqs         (HPS_DDR3_DQS_P),         //                 .mem_dqs
        .memory_mem_dqs_n       (HPS_DDR3_DQS_N),       //                 .mem_dqs_n
        .memory_mem_odt         (HPS_DDR3_ODT),         //                 .mem_odt
        .memory_mem_dm          (HPS_DDR3_DM),          //                 .mem_dm
        .memory_oct_rzqin       (HPS_DDR3_RZQ),       //                 .oct_rzqin

		.pushbutton_export      (~KEY[3:1]),      //       pushbutton.export
        .sdram_clk_clk          (DRAM_CLK),          //        sdram_clk.clk
        .sdram_wire_addr        (DRAM_ADDR),        //       sdram_wire.addr
        .sdram_wire_ba          (DRAM_BA),          //                 .ba
        .sdram_wire_cas_n       (DRAM_CAS_N),       //                 .cas_n
        .sdram_wire_cke         (DRAM_CKE),         //                 .cke
        .sdram_wire_cs_n        (DRAM_CS_N),        //                 .cs_n
        .sdram_wire_dq          (DRAM_DQ),          //                 .dq
        .sdram_wire_dqm         ({DRAM_UDQM, DRAM_LDQM}),         //                 .dqm
        .sdram_wire_ras_n       (DRAM_RAS_N),       //                 .ras_n
        .sdram_wire_we_n        (DRAM_WE_N),        //                 .we_n
  
        .system_ref_clk_clk                 (CLOCK_50),                 //           system_ref_clk.clk
        .system_ref_reset_reset             (~KEY[0]),             //         system_ref_reset.reset
        .to_hex_to_led_readdata             (hex),             //            to_hex_to_led.readdata

        .ram_s2_address                     (sram_address),                     //                   ram_s2.address
        .ram_s2_chipselect                  (sram_chipselect),                  //                         .chipselect
        .ram_s2_clken                       (sram_clken),                       //                         .clken
        .ram_s2_write                       (sram_write),                       //                         .write
        .ram_s2_readdata                    (sram_readdata),                    //                         .readdata
        .ram_s2_writedata                   (sram_writedata),                   //                         .writedata
        .ram_s2_byteenable                  (4'b1111)                   //                         .byteenable
    );


endmodule