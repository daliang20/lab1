module lab1(
	CLOCK_50, 
	DRAM_CLK,
	HEX0, 
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	
	SW,
	
	KEY,
	
	LEDR,
	
	// DDR3
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
	HPS_DDR3_WE_N
);

input CLOCK_50; 
output [0:6] 	HEX0, HEX1,HEX2,HEX3, HEX4, HEX5;
input [3:0] KEY; 
output [9:0] LEDR; 
input [9:0] SW; 

input DRAM_CLK;
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

wire [31:0] hex5_hex0;
wire [31:0] hex5_0bus;

// These two form {led, hex} to_hex_to_led
wire [31:0] hex;


hex2seg f1(.hex(hex[3:0]), .seg(HEX0));
hex2seg f2(.hex(hex[7:4]), .seg(HEX1));
hex2seg f3(.hex(hex[11:8]), .seg(HEX2));     
hex2seg f4(.hex(hex[15:12]), .seg(HEX3));
hex2seg f5(.hex(hex[19:16]), .seg(HEX4));
hex2seg f6(.hex(hex[23:20]), .seg(HEX5));


    mysystem u0 (
        .hex5_0bus_export       (hex5_0bus),       //        hex5_0bus.export
        .memory_mem_a       (HPS_DDR3_ADDR),       //      memory.mem_a
        .memory_mem_ba      (HPS_DDR3_BA),      //            .mem_ba
        .memory_mem_ck      (HPS_DDR3_CK_P),      //            .mem_ck
        .memory_mem_ck_n    (HPS_DDR3_CK_N),    //            .mem_ck_n
        .memory_mem_cke     (HPS_DDR3_CKE),     //            .mem_cke
        .memory_mem_cs_n    (HPS_DDR3_CS_N),    //            .mem_cs_n
        .memory_mem_ras_n   (HPS_DDR3_RAS_N),   //            .mem_ras_n
        .memory_mem_cas_n   (HPS_DDR3_CAS_N),   //            .mem_cas_n
        .memory_mem_we_n    (HPS_DDR3_WE_N),    //            .mem_we_n
        .memory_mem_reset_n (HPS_DDR3_RESET_N), //            .mem_reset_n
        .memory_mem_dq      (HPS_DDR3_DQ),      //            .mem_dq
        .memory_mem_dqs     (HPS_DDR3_DQS_P),     //            .mem_dqs
        .memory_mem_dqs_n   (HPS_DDR3_DQS_N),   //            .mem_dqs_n
        .memory_mem_odt     (HPS_DDR3_ODT),     //            .mem_odt
        .memory_mem_dm      (HPS_DDR3_DM),      //            .mem_dm
        .memory_oct_rzqin   (HPS_DDR3_RZQ),   //            .oct_rzqin
        .pushbutton_export      (~KEY[3:1]),      //       pushbutton.export
        .sdram_clk_clk          (DRAM_CLK),          //        sdram_clk.clk
        .system_ref_clk_clk     (CLOCK_50),     //   system_ref_clk.clk
        .system_ref_reset_reset (~KEY[0]), // system_ref_reset.reset
        .to_hex_to_led_readdata (hex)  //    to_hex_to_led.readdata
    );



/* old for lab1
    mysystem u0 (
        .clk_clk            (CLOCK_50),            //         clk.clk
        .memory_mem_a       (HPS_DDR3_ADDR),       //      memory.mem_a
        .memory_mem_ba      (HPS_DDR3_BA),      //            .mem_ba
        .memory_mem_ck      (HPS_DDR3_CK_P),      //            .mem_ck
        .memory_mem_ck_n    (HPS_DDR3_CK_N),    //            .mem_ck_n
        .memory_mem_cke     (HPS_DDR3_CKE),     //            .mem_cke
        .memory_mem_cs_n    (HPS_DDR3_CS_N),    //            .mem_cs_n
        .memory_mem_ras_n   (HPS_DDR3_RAS_N),   //            .mem_ras_n
        .memory_mem_cas_n   (HPS_DDR3_CAS_N),   //            .mem_cas_n
        .memory_mem_we_n    (HPS_DDR3_WE_N),    //            .mem_we_n
        .memory_mem_reset_n (HPS_DDR3_RESET_N), //            .mem_reset_n
        .memory_mem_dq      (HPS_DDR3_DQ),      //            .mem_dq
        .memory_mem_dqs     (HPS_DDR3_DQS_P),     //            .mem_dqs
        .memory_mem_dqs_n   (HPS_DDR3_DQS_N),   //            .mem_dqs_n
        .memory_mem_odt     (HPS_DDR3_ODT),     //            .mem_odt
        .memory_mem_dm      (HPS_DDR3_DM),      //            .mem_dm
        .memory_oct_rzqin   (HPS_DDR3_RZQ),   //            .oct_rzqin
        .rled_export        (LEDR),        //        rled.export
        .hex3_hex0_export   (),   //   hex3_hex0.export
        .hex5_hex4_export   (),   //   hex5_hex4.export
        .switches_export    (SW),    //    switches.export
		   .to_hex_to_led_readdata (to_hex_to_led),
        .pushbuttons_export (~KEY[3:0]), // pushbuttons.export
        .reset_reset_n      (1'b1)       //       reset.reset_n
    );
*/
endmodule