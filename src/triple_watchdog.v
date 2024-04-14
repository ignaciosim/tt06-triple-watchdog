`default_nettype none
`timescale 1ns/1ns

module tt_um_triple_watchdog (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// Instantiate three watchdog instances
watchdog watchdog1(
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .watchdog_expired(uo_out[0])
);

watchdog watchdog2(
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .watchdog_expired(uo_out[1])
);

watchdog watchdog3(
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .watchdog_expired(uo_out[2])
);


assign uo_out[7:3] = 0; // Clear undriven bits while preserving driven bits
assign uio_out=0;
assign uio_oe=0;

endmodule
