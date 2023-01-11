`timescale 1ns / 1ps

module top_system(
  input         clk,
  input         resetn,

  //uart
  output        uart_txd,
  input         uart_rxd,

	output        trap
  );
   //
   // CLOCK MANAGEMENT
   //

   //system clock
   wire 			sys_clk = clk;

   //
   // RESET MANAGEMENT
   //

   //system reset

   wire                         sys_rst;

   reg [15:0] 			rst_cnt;

   always @(posedge sys_clk, negedge resetn)
     if(!resetn)
       rst_cnt <= 16'hFFFF;
     else if (rst_cnt != 16'h0)
       rst_cnt <= rst_cnt - 1'b1;

   assign sys_rst  = (rst_cnt != 16'h0);

   wire [1:0]                   trap_signals;
   assign trap = trap_signals[0] || trap_signals[1];

   //
   // TESTER (includes UUT)
   //
   tester tester (
      .clk           (sys_clk),
		  .reset         (sys_rst),
		  .trap          (trap_signals),
      //UART
		  .UART0_txd      (uart_txd),
		  .UART0_rxd      (uart_rxd),
		  .UART0_rts      (),
		  .UART0_cts      (1'b1)
		);

endmodule