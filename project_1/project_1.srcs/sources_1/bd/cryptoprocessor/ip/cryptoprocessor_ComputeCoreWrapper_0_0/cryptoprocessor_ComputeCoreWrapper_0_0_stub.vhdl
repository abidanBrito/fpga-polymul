-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Fri Dec 16 11:29:08 2022
-- Host        : ipn040 running 64-bit Ubuntu 22.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/jharing/git/2nd/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_ComputeCoreWrapper_0_0/cryptoprocessor_ComputeCoreWrapper_0_0_stub.vhdl
-- Design      : cryptoprocessor_ComputeCoreWrapper_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cryptoprocessor_ComputeCoreWrapper_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    control_low_word : in STD_LOGIC_VECTOR ( 31 downto 0 );
    control_high_word : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina_ext_low_word : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina_ext_high_word : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dout_ext_low_word : out STD_LOGIC_VECTOR ( 31 downto 0 );
    dout_ext_high_word : out STD_LOGIC_VECTOR ( 31 downto 0 );
    status : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end cryptoprocessor_ComputeCoreWrapper_0_0;

architecture stub of cryptoprocessor_ComputeCoreWrapper_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,control_low_word[31:0],control_high_word[31:0],dina_ext_low_word[31:0],dina_ext_high_word[31:0],dout_ext_low_word[31:0],dout_ext_high_word[31:0],status[31:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ComputeCoreWrapper,Vivado 2019.1";
begin
end;
