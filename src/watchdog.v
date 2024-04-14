`default_nettype none
`timescale 1ns/1ns
module watchdog (
    input wire clk,          // Clock input
    input wire rst_n,        // Reset input
    input wire [7:0] ui_in,  // Dedicated inputs
    output wire watchdog_expired // Watchdog expiration signal
);

// Parameters
parameter TIMEOUT_VALUE = 100000; // Timeout value (in clock cycles)

// Internal signals
reg [7:0] ui_in_reg;
reg [31:0] counter;
reg [1:0] state;

// Watchdog states
parameter IDLE = 2'b00;
parameter ACTIVE = 2'b01;

// Watchdog expiration flag
reg expired;

// Watchdog expiration detection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        state <= IDLE;
        expired <= 0;
        ui_in_reg<=0;
    end else begin
        case (state)
            IDLE: begin
                if (ui_in != ui_in_reg) begin
                    state <= ACTIVE;
                    expired <= 0;
                    counter <= 0;
                    ui_in_reg <= ui_in;
                end
            end
            ACTIVE: begin
                if (ui_in == ui_in_reg) begin
                    counter <= counter + 1;
                    if (counter == TIMEOUT_VALUE) begin
                        expired <= 1;
                        state<=IDLE;
                    end
                end else begin
                    counter <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output expiration signal when expired
assign watchdog_expired = expired;


endmodule
