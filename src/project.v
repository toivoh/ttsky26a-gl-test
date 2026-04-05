/*
 * Copyright (c) 2026 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module tt_um_example (
		input  wire [7:0] ui_in,    // Dedicated inputs
		output wire [7:0] uo_out,   // Dedicated outputs
		input  wire [7:0] uio_in,   // IOs: Input path
		output wire [7:0] uio_out,  // IOs: Output path
		output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
		input  wire       ena,      // always 1 when the design is powered, so you can ignore it
		input  wire       clk,      // clock
		input  wire       rst_n     // reset_n - low to reset
	);

	wire reset = !rst_n;
/*
	wire vsync0 = ui_in[0];
	wire new_line = !ui_in[1];

	reg vsync_reg;
	always_ff @(posedge clk) begin
		if (reset) begin
			vsync_reg <= 1;
		end else begin
			vsync_reg <= vsync0;
		end
	end

	assign uo_out = vsync_reg;
*/
	reg [14:0] data;
	always_ff @(posedge clk) begin
		if (reset) data <= '0;
		else if (uio_in[7]) data <= {uio_in[6:0], ui_in};
	end

	assign {uio_out, uo_out} = data;
	assign uio_oe  = 0;

	// List all unused inputs to prevent warnings
	wire _unused = &{ena, clk, rst_n, 1'b0};
endmodule
