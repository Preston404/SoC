///////////////////////////////////////////////////////////////////
//=================================================================
//  Copyright (c) Alorium Technology 2016
//  ALL RIGHTS RESERVED
//  $Id:  $
//=================================================================
//
// File name:  : xlr8_lfsr.v
// Author      :  Bryan Craker
// Description : Simple XB instantiating an LFSR for XLR8
//=================================================================
///////////////////////////////////////////////////////////////////


module xlr8_esc (
   // Outputs
   dbus_out, io_out_en, /*heartbeat,*/ SD_1, SD_2, SD_3, IN_1, IN_2, IN_3, sync, sync2,
   // Inputs
   rstn, clk, clken, dbus_in, ramadr, ramre, ramwe, dm_sel, /*hb_enable, long_hb,*/ feedback_1, feedback_2, feedback_3
   );

   //parameter LFSR_CTRL_ADDR = 0;
   //parameter LFSR_SEED_ADDR = 0;
   //parameter LFSR_DATA_ADDR = 0;
	parameter ESC_PWM_ADDR = 0;
   parameter WIDTH = 8;

   // Clock and Reset
   input                     rstn;
   input                     clk;
   input                     clken;
   // I/O 
   input [7:0]               dbus_in;
   output [7:0]              dbus_out;
   output                    io_out_en;
   //input                     hb_enable;
   //input                     long_hb;
   //output                    heartbeat;
	
	
	// Fet Drivers
	output                    SD_1;
	output                    IN_1;
	output                    SD_2;
	output                    IN_2;
	output                    SD_3;
	output                    IN_3;
	output                    sync;
	output                    sync2;
	
	
	// Feedback Sensors
	input                     feedback_1;
	input                     feedback_2;
	input                     feedback_3;
	
	
   // DM
   input [7:0]               ramadr;
   input                     ramre;
   input                     ramwe;
   input                     dm_sel;

	/*
   logic new_seed;

	
   logic ctrl_sel;
   logic ctrl_we;
   logic ctrl_re;
   logic [WIDTH-1:0] lfsr_ctrl;
   logic seed_sel;
   logic seed_we;
   logic seed_re;
   logic [WIDTH-1:0] lfsr_seed;
   logic data_sel;
   logic data_we;
   logic data_re;
   logic [WIDTH-1:0] lfsr_data;

   assign ctrl_sel = (dm_sel && ramadr == LFSR_CTRL_ADDR);
   assign ctrl_we  = ctrl_sel && (ramwe);
   assign ctrl_re  = ctrl_sel && (ramre);
	
   assign seed_sel = (dm_sel && ramadr == LFSR_SEED_ADDR);
   assign seed_we  = seed_sel && (ramwe);
   assign seed_re  = seed_sel && (ramre);
	
   assign data_sel = (dm_sel && ramadr == LFSR_DATA_ADDR);
   assign data_we  = data_sel && (ramwe);
   assign data_re  = data_sel && (ramre);
	
   assign dbus_out =  ({8{ctrl_sel}} & lfsr_ctrl) |
                      ({8{seed_sel}} & lfsr_seed) |
                      ({8{data_sel}} & lfsr_data);
   assign io_out_en = ctrl_re ||
                      seed_re ||
                      data_re;
	*/	

	logic new_pwm;
	
	logic pwm_sel;
   logic pwm_we;
   logic pwm_re;
	logic [WIDTH-1:0] esc_pwm;
	
	assign pwm_sel = (dm_sel && ramadr == ESC_PWM_ADDR);
   assign pwm_we  = pwm_sel && (ramwe);
   assign pwm_re  = pwm_sel && (ramre);
	
   assign dbus_out = ({8{pwm_sel}} & esc_pwm);
	assign io_out_en = pwm_re;

	always @(posedge clk or negedge rstn) begin
      if (!rstn)  begin
         esc_pwm <= {WIDTH{1'b0}};
      end else if (clken && pwm_we) begin
         esc_pwm <= dbus_in[WIDTH-1:0];
			new_pwm <= pwm_we;
      end
		else begin
		   new_pwm <= pwm_we;
		end
   end
	
   /*
   always @(posedge clk or negedge rstn) begin
      if (!rstn)  begin
         lfsr_ctrl <= {WIDTH{1'b0}};
      end else if (clken && ctrl_we) begin
         lfsr_ctrl <= dbus_in[WIDTH-1:0];
      end
   end // always @ (posedge clk or negedge rstn)
   */
	
	/*
   always @(posedge clk or negedge rstn) begin
      if (!rstn)  begin
         lfsr_seed <= {WIDTH{1'b0}};
      end else if (clken && seed_we) begin
         lfsr_seed <= dbus_in[WIDTH-1:0];
         new_seed <= seed_we;
      end else begin
         new_seed <= seed_we;
      end
   end // always @ (posedge clk or negedge rstn)
   // note: new_seed needs to be offset one clock from seed_we to line 
   // seed data up correctly
   */
	
   alorium_esc esc_inst (
                        // Clock and Reset
                        .clk       (clk),
                        .reset_n   (rstn),
                        // Inputs
                        //.new_seed  (new_seed),
                        //.enable    (lfsr_ctrl[0] | data_re),
                        //.seed      (lfsr_seed),
                        //.long_hb   (lfsr_ctrl[1]),
                        // Output
                        //.heartbeat (heartbeat),
                        //.lfsr_data (lfsr_data),
						
						      .esc_pwm(esc_pwm),
								.new_pwm(new_pwm),
						      
						      .IN_1      (IN_1),
						      .IN_2      (IN_2),
						      .IN_3      (IN_3),
						      .SD_1      (SD_1),
						      .SD_2      (SD_2),
						      .SD_3      (SD_3),
						      
						      .feedback_1(feedback_1),
							   .feedback_2(feedback_2),
						      .feedback_3(feedback_3),
								
								.sync(sync),
								.sync2(sync2)
								
						);

endmodule // xlr8_esc
