# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {HDL-1065} -limit 10000
set_param project.vivado.isBlockSynthRun true
create_project -in_memory -part xc7z020clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/jharing/git/chw2022g3/project_1/project_1.cache/wt [current_project]
set_property parent.project_path /home/jharing/git/chw2022g3/project_1/project_1.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project]
set_property ip_repo_paths {
  /home/jharing/git/chw2022g3/ip_repo/AXI_Slave8Ports_new_1.0
  /home/jharing/git/chw2022g3/ip_repo/AXI_Slave8Ports_1.0
  /home/jharing/git/chw2022g3/ip_repo/AXIslave_1.0
} [current_project]
update_ip_catalog
set_property ip_output_repo /home/jharing/git/chw2022g3/project_1/project_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0.xci

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top cryptoprocessor_auto_pc_0 -part xc7z020clg400-1 -mode out_of_context

rename_ref -prefix_all cryptoprocessor_auto_pc_0_

# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef cryptoprocessor_auto_pc_0.dcp
create_report "cryptoprocessor_auto_pc_0_synth_1_synth_report_utilization_0" "report_utilization -file cryptoprocessor_auto_pc_0_utilization_synth.rpt -pb cryptoprocessor_auto_pc_0_utilization_synth.pb"

if { [catch {
  file copy -force /home/jharing/git/chw2022g3/project_1/project_1.runs/cryptoprocessor_auto_pc_0_synth_1/cryptoprocessor_auto_pc_0.dcp /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if {[file isdir /home/jharing/git/chw2022g3/project_1/project_1.ip_user_files/ip/cryptoprocessor_auto_pc_0]} {
  catch { 
    file copy -force /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_stub.v /home/jharing/git/chw2022g3/project_1/project_1.ip_user_files/ip/cryptoprocessor_auto_pc_0
  }
}

if {[file isdir /home/jharing/git/chw2022g3/project_1/project_1.ip_user_files/ip/cryptoprocessor_auto_pc_0]} {
  catch { 
    file copy -force /home/jharing/git/chw2022g3/project_1/project_1.srcs/sources_1/bd/cryptoprocessor/ip/cryptoprocessor_auto_pc_0/cryptoprocessor_auto_pc_0_stub.vhdl /home/jharing/git/chw2022g3/project_1/project_1.ip_user_files/ip/cryptoprocessor_auto_pc_0
  }
}
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]