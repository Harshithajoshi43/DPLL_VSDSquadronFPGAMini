// dpll_tb.v — testbench for your dpll_top.v
`timescale 1ns/1ps

module dpll_tb;
  reg        clk_12MHz = 0;
  reg        reset_n   = 0;
  wire [2:0] leds;

  // DUT
  dpll_top dut (
    .clk_12MHz(clk_12MHz),
    .reset_n  (reset_n),
    .leds     (leds)
  );

  // 12 MHz clock: toggle every 41.667 ns
  always #41.667 clk_12MHz = ~clk_12MHz;

  // release reset after 200 ns
  initial begin
    #200;
    reset_n = 1;
  end

  // VCD dump & finish after 10 ms
  initial begin
    $dumpfile("dpll.vcd");
    $dumpvars(0, dpll_tb);
    #10_000_000; // 10 ms → ~5 cycles @2 ms per step
    $finish;
  end
endmodule
