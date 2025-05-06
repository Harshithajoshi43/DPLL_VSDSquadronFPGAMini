// dpll_top.v — LED demo of DPLL with color‐coded presets
`timescale 1ns/1ps

module dpll_top(
    input  wire       clk_12MHz,  // 12 MHz onboard clock
    input  wire       reset_n,    // Active-low reset
    output wire [2:0] leds        // {blue, green, red}
);

  // 1) Global clock buffer
  wire clk;
  SB_GB clkbuf(
    .USER_SIGNAL_TO_GLOBAL_BUFFER(clk_12MHz),
    .GLOBAL_BUFFER_OUTPUT(clk)
  );

  // 2) DPLL phase accumulator
  reg  [15:0] phase_inc;
  reg  [31:0] phase_accum;
  wire        blue_out = phase_accum[31];

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      phase_accum <= 0;
    else
      phase_accum <= phase_accum + phase_inc;
  end

  // 3) Preset control words for ~1,2,4,8 Hz (at 12 MHz)
  wire [15:0] preset_inc [0:3];
  assign preset_inc[0] = 16'd358;   // ≈1 Hz
  assign preset_inc[1] = 16'd716;   // ≈2 Hz
  assign preset_inc[2] = 16'd1432;  // ≈4 Hz
  assign preset_inc[3] = 16'd2864;  // ≈8 Hz

  // 4) Step interval: 2 s on hardware, 2 µs in sim
`ifdef SIM
  localparam STEP_MAX = 12_000 * 2;     // ≈2 µs at 12 MHz → fast sim cycles
`else
  localparam STEP_MAX = 12_000_000 * 2; // ≈2 s at 12 MHz → real hardware
`endif

  reg [24:0] step_cnt;
  reg  [1:0] phase_idx;
  reg        update;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      step_cnt  <= 0;
      phase_idx <= 0;
      phase_inc <= preset_inc[0];
      update    <= 1;
    end else begin
      update <= 0;
      if (step_cnt == STEP_MAX - 1) begin
        step_cnt  <= 0;
        phase_idx <= phase_idx + 1;
        phase_inc <= preset_inc[phase_idx + 1];
        update    <= 1;
      end else
        step_cnt <= step_cnt + 1;
    end
  end

  // 5) Color‐code each step:  
  //    idx=0 → blue; 1 → red+blue; 2 → green+blue; 3 → yellow+blue
  reg red_on, green_on;
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      {red_on, green_on} <= 2'b00;
    else if (update) begin
      case (phase_idx)
        2'd0: {red_on, green_on} <= 2'b00; // BLUE only
        2'd1: {red_on, green_on} <= 2'b10; // RED + BLUE
        2'd2: {red_on, green_on} <= 2'b01; // GREEN + BLUE
        2'd3: {red_on, green_on} <= 2'b11; // YELLOW + BLUE
      endcase
    end
  end

  // 6) Heartbeat on red when not color-coded
  wire heartbeat = step_cnt[23];  // ~0.7 s toggle (unused in SIM)

  // 7) Final LED outputs {blue, green, red}
  assign leds[0] = blue_out;
  assign leds[1] = green_on;
  assign leds[2] = red_on ? 1'b1 : heartbeat;

endmodule
