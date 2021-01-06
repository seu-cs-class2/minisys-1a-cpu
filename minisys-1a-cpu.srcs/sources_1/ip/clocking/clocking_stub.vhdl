-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Wed Jan  6 14:34:38 2021
-- Host        : DESKTOP-ED5SFTK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/ProgramSave/minisys-1a-cpu/minisys-1a-cpu.srcs/sources_1/ip/clocking/clocking_stub.vhdl
-- Design      : clocking
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clocking is
  Port ( 
    cpu_clk : out STD_LOGIC;
    uart_clk : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clocking;

architecture stub of clocking is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "cpu_clk,uart_clk,clk_in1";
begin
end;
