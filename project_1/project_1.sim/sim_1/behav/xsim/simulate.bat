@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Thu Nov 24 14:00:26 +0100 2022
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim tb_modular_multiplication_behav -key {Behavioral:sim_1:Functional:tb_modular_multiplication} -tclbatch tb_modular_multiplication.tcl -protoinst "protoinst_files/cryptoprocessor.protoinst" -view E:/OneDrive - UPV/__TUG/Cryptography on Hardware Platforms/02 - Labs/chw2022g3/project_1/tb_behav.wcfg -view E:/OneDrive - UPV/__TUG/Cryptography on Hardware Platforms/02 - Labs/chw2022g3/project_1/tb_modular_mult_behav.wcfg -log simulate.log"
call xsim  tb_modular_multiplication_behav -key {Behavioral:sim_1:Functional:tb_modular_multiplication} -tclbatch tb_modular_multiplication.tcl -protoinst "protoinst_files/cryptoprocessor.protoinst" -view E:/OneDrive - UPV/__TUG/Cryptography on Hardware Platforms/02 - Labs/chw2022g3/project_1/tb_behav.wcfg -view E:/OneDrive - UPV/__TUG/Cryptography on Hardware Platforms/02 - Labs/chw2022g3/project_1/tb_modular_mult_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
