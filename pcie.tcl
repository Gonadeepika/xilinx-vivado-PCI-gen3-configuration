
################################################################
# This is a generated script based on design: pcie
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source pcie_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1902-vsva6865-2MP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name pcie

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:qdma:5.1\
xilinx.com:ip:pcie_versal:1.1\
xilinx.com:ip:pcie_phy_versal:1.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:gt_quad_base:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: pcie_axi_bridge_support
proc create_hier_cell_pcie_axi_bridge_support { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pcie_axi_bridge_support() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 pcie_mgt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_cq

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_rc

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_cfg_fc_rtl:1.1 pcie_cfg_fc

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie3_cfg_interrupt_rtl:1.0 pcie_cfg_interrupt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_cfg_msg_received_rtl:1.0 pcie_cfg_mesg_rcvd

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_cfg_mesg_tx_rtl:1.0 pcie_cfg_mesg_tx

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_cc

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_rq

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie5_cfg_control_rtl:1.0 pcie_cfg_control

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie4_cfg_msix_rtl:1.0 pcie_cfg_external_msix_without_msi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie4_cfg_mgmt_rtl:1.0 pcie_cfg_mgmt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie5_cfg_status_rtl:1.0 pcie_cfg_status

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_transmit_fc_rtl:1.0 pcie_transmit_fc


  # Create pins
  create_bd_pin -dir I -type rst sys_reset
  create_bd_pin -dir I -from 0 -to 0 BUFG_GT_CE
  create_bd_pin -dir I -type clk apb3clk
  create_bd_pin -dir O phy_rdy_out
  create_bd_pin -dir O -type clk user_clk
  create_bd_pin -dir O user_lnk_up
  create_bd_pin -dir O -type rst user_reset

  # Create instance: pcie, and set properties
  set pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_versal:1.1 pcie ]
  set_property -dict [list \
    CONFIG.AXISTEN_IF_CQ_ALIGNMENT_MODE {Address_Aligned} \
    CONFIG.AXISTEN_IF_RQ_ALIGNMENT_MODE {DWORD_Aligned} \
    CONFIG.MSI_X_OPTIONS {MSI-X_External} \
    CONFIG.PF0_AER_CAP_ECRC_GEN_AND_CHECK_CAPABLE {false} \
    CONFIG.PF0_DEVICE_ID {B034} \
    CONFIG.PF0_INTERRUPT_PIN {INTA} \
    CONFIG.PF0_LINK_STATUS_SLOT_CLOCK_CONFIG {true} \
    CONFIG.PF0_REVISION_ID {00} \
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {C034} \
    CONFIG.PF0_SUBSYSTEM_ID {0007} \
    CONFIG.PF0_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF0_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF1_DEVICE_ID {B134} \
    CONFIG.PF1_INTERRUPT_PIN {INTA} \
    CONFIG.PF1_REVISION_ID {00} \
    CONFIG.PF1_SUBSYSTEM_ID {0007} \
    CONFIG.PF1_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF1_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF2_DEVICE_ID {B234} \
    CONFIG.PF2_INTERRUPT_PIN {INTA} \
    CONFIG.PF2_REVISION_ID {00} \
    CONFIG.PF2_SUBSYSTEM_ID {0007} \
    CONFIG.PF2_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF2_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF3_DEVICE_ID {B334} \
    CONFIG.PF3_INTERRUPT_PIN {INTA} \
    CONFIG.PF3_REVISION_ID {00} \
    CONFIG.PF3_SUBSYSTEM_ID {0007} \
    CONFIG.PF3_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF3_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PL_DISABLE_LANE_REVERSAL {TRUE} \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {8.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
    CONFIG.REF_CLK_FREQ {100_MHz} \
    CONFIG.SRIOV_CAP_ENABLE {false} \
    CONFIG.TL_PF_ENABLE_REG {4} \
    CONFIG.acs_ext_cap_enable {false} \
    CONFIG.all_speeds_all_sides {NO} \
    CONFIG.axisten_freq {250} \
    CONFIG.axisten_if_enable_client_tag {true} \
    CONFIG.axisten_if_enable_msg_route {1EFFF} \
    CONFIG.axisten_if_enable_msg_route_override {true} \
    CONFIG.axisten_if_width {128_bit} \
    CONFIG.cfg_ext_if {false} \
    CONFIG.cfg_mgmt_if {true} \
    CONFIG.copy_pf0 {true} \
    CONFIG.datapath_reorder {false} \
    CONFIG.dedicate_perst {false} \
    CONFIG.device_port_type {PCI_Express_Endpoint_device} \
    CONFIG.en_dbg_descramble {false} \
    CONFIG.en_ext_clk {FALSE} \
    CONFIG.en_l23_entry {false} \
    CONFIG.en_parity {false} \
    CONFIG.en_transceiver_status_ports {false} \
    CONFIG.enable_auto_rxeq {False} \
    CONFIG.enable_ccix {FALSE} \
    CONFIG.enable_code {0000} \
    CONFIG.enable_dvsec {FALSE} \
    CONFIG.enable_gen4 {true} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.enable_ibert {false} \
    CONFIG.enable_jtag_dbg {false} \
    CONFIG.enable_more_clk {false} \
    CONFIG.ext_pcie_cfg_space_enabled {false} \
    CONFIG.extended_tag_field {true} \
    CONFIG.insert_cips {false} \
    CONFIG.lane_order {Bottom} \
    CONFIG.lane_reversal {false} \
    CONFIG.legacy_ext_pcie_cfg_space_enabled {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {S0X0Y1} \
    CONFIG.pcie_link_debug {false} \
    CONFIG.pcie_link_debug_axi4_st {false} \
    CONFIG.pf0_ari_enabled {false} \
    CONFIG.pf0_bar0_64bit {true} \
    CONFIG.pf0_bar0_enabled {true} \
    CONFIG.pf0_bar0_prefetchable {false} \
    CONFIG.pf0_bar0_scale {Gigabytes} \
    CONFIG.pf0_bar0_size {16} \
    CONFIG.pf0_bar2_64bit {true} \
    CONFIG.pf0_bar2_enabled {true} \
    CONFIG.pf0_bar2_prefetchable {false} \
    CONFIG.pf0_bar2_scale {Gigabytes} \
    CONFIG.pf0_bar2_size {1} \
    CONFIG.pf0_bar4_enabled {false} \
    CONFIG.pf0_bar5_enabled {false} \
    CONFIG.pf0_base_class_menu {Memory_controller} \
    CONFIG.pf0_class_code_base {05} \
    CONFIG.pf0_class_code_interface {00} \
    CONFIG.pf0_class_code_sub {80} \
    CONFIG.pf0_expansion_rom_enabled {false} \
    CONFIG.pf0_msi_enabled {false} \
    CONFIG.pf0_msix_enabled {true} \
    CONFIG.pf0_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf1_base_class_menu {Memory_controller} \
    CONFIG.pf1_class_code_base {05} \
    CONFIG.pf1_class_code_interface {00} \
    CONFIG.pf1_class_code_sub {80} \
    CONFIG.pf1_msi_enabled {false} \
    CONFIG.pf1_msix_enabled {false} \
    CONFIG.pf1_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf1_vendor_id {10EE} \
    CONFIG.pf2_base_class_menu {Memory_controller} \
    CONFIG.pf2_class_code_base {05} \
    CONFIG.pf2_class_code_interface {00} \
    CONFIG.pf2_class_code_sub {80} \
    CONFIG.pf2_msi_enabled {false} \
    CONFIG.pf2_msix_enabled {false} \
    CONFIG.pf2_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf2_vendor_id {10EE} \
    CONFIG.pf3_base_class_menu {Memory_controller} \
    CONFIG.pf3_class_code_base {05} \
    CONFIG.pf3_class_code_interface {00} \
    CONFIG.pf3_class_code_sub {80} \
    CONFIG.pf3_msi_enabled {false} \
    CONFIG.pf3_msix_enabled {false} \
    CONFIG.pf3_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf3_vendor_id {10EE} \
    CONFIG.pipe_line_stage {2} \
    CONFIG.pipe_sim {false} \
    CONFIG.replace_uram_with_bram {false} \
    CONFIG.sys_reset_polarity {ACTIVE_LOW} \
    CONFIG.vendor_id {10EE} \
    CONFIG.warm_reboot_sbr_fix {false} \
    CONFIG.xlnx_ref_board {None} \
  ] $pcie


  # Create instance: pcie_phy, and set properties
  set pcie_phy [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_phy_versal:1.1 pcie_phy ]
  set_property -dict [list \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {8.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
    CONFIG.aspm {No_ASPM} \
    CONFIG.async_mode {SRNS} \
    CONFIG.datapath_reorder {false} \
    CONFIG.disable_double_pipe {YES} \
    CONFIG.en_gt_pclk {false} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.ins_loss_profile {Add-in_Card} \
    CONFIG.lane_order {Bottom} \
    CONFIG.lane_reversal {false} \
    CONFIG.phy_async_en {true} \
    CONFIG.phy_coreclk_freq {500_MHz} \
    CONFIG.phy_refclk_freq {100_MHz} \
    CONFIG.phy_userclk_freq {250_MHz} \
    CONFIG.pipeline_stages {2} \
    CONFIG.sim_model {NO} \
    CONFIG.tx_preset {4} \
  ] $pcie_phy


  # Create instance: bufg_gt_sysclk, and set properties
  set bufg_gt_sysclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 bufg_gt_sysclk ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {BUFG_GT} \
  ] $bufg_gt_sysclk


  # Create instance: refclk_ibuf, and set properties
  set refclk_ibuf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 refclk_ibuf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $refclk_ibuf


  # Create instance: gt_quad_0, and set properties
  set gt_quad_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_0 ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {200.0} \
    CONFIG.CHANNEL_ORDERING {/pcie_axi_bridge_support/gt_quad_0/TX0_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_TX0.0 /pcie_axi_bridge_support/gt_quad_0/TX1_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_TX1.1\
/pcie_axi_bridge_support/gt_quad_0/TX2_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_TX2.2 /pcie_axi_bridge_support/gt_quad_0/TX3_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_TX3.3\
/pcie_axi_bridge_support/gt_quad_0/RX0_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_RX0.0 /pcie_axi_bridge_support/gt_quad_0/RX1_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_RX1.1\
/pcie_axi_bridge_support/gt_quad_0/RX2_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_RX2.2 /pcie_axi_bridge_support/gt_quad_0/RX3_GT_IP_Interface pcie_pcie_phy_0./pcie_axi_bridge_support/pcie_phy/GT_RX3.3}\
\
    CONFIG.GT_TYPE {GTYP} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTYP REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 2.5 TX_PLL_TYPE LCPLL\
TX_REFCLK_FREQUENCY 100 TX_ACTUAL_REFCLK_FREQUENCY 100.000000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING 8B10B TX_USER_DATA_WIDTH 16 TX_INT_DATA_WIDTH\
20 TX_BUFFER_MODE 0 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 500.000 TX_DIFF_SWING_EMPH_MODE\
CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE GT_TYPE GTYP PRESET None RX_PAM_SEL NRZ\
RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 2.5 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 100 RX_ACTUAL_REFCLK_FREQUENCY\
100.000000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING 8B10B RX_USER_DATA_WIDTH 16 RX_INT_DATA_WIDTH 20 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 125.000000 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 20 RX_EQ_MODE LPM RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE true RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE true RX_COMMA_P_ENABLE true RX_COMMA_M_ENABLE true RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 1010000011 RX_COMMA_M_VAL 0101111100 RX_COMMA_MASK 1111111111 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 1 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE ENABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000011100\
RX_CC_K 00000001 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00011100 RX_CC_K_0_0 true RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false\
RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0\
00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2\
false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 1 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE\
MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET K28.5 RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 5.0 TX_PLL_TYPE LCPLL\
TX_REFCLK_FREQUENCY 100 TX_ACTUAL_REFCLK_FREQUENCY 100.000000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING 8B10B TX_USER_DATA_WIDTH 16 TX_INT_DATA_WIDTH\
20 TX_BUFFER_MODE 0 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 500.000 TX_DIFF_SWING_EMPH_MODE\
CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE GT_TYPE GTYP PRESET None RX_PAM_SEL NRZ\
RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 5.0 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 100 RX_ACTUAL_REFCLK_FREQUENCY\
100.000000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING 8B10B RX_USER_DATA_WIDTH 16 RX_INT_DATA_WIDTH 20 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 250.000000 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 20 RX_EQ_MODE LPM RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE true RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE true RX_COMMA_P_ENABLE true RX_COMMA_M_ENABLE true RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 1010000011 RX_COMMA_M_VAL 0101111100 RX_COMMA_MASK 1111111111 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 1 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE ENABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000011100\
RX_CC_K 00000001 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00011100 RX_CC_K_0_0 true RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false\
RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0\
00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2\
false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 1 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE\
MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET K28.5 RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR2_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 8.0 TX_PLL_TYPE LCPLL\
TX_REFCLK_FREQUENCY 100 TX_ACTUAL_REFCLK_FREQUENCY 100.000000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING 128B130B TX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH\
32 TX_BUFFER_MODE 0 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 500.000 TX_DIFF_SWING_EMPH_MODE\
CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE GT_TYPE GTYP PRESET None RX_PAM_SEL NRZ\
RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 8.0 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 100 RX_ACTUAL_REFCLK_FREQUENCY\
100.000000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING 128B130B RX_USER_DATA_WIDTH 32 RX_INT_DATA_WIDTH 32 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 250.000000 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 20 RX_EQ_MODE DFE RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE true RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE true RX_COMMA_P_ENABLE true RX_COMMA_M_ENABLE true RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 1010000011 RX_COMMA_M_VAL 0101111100 RX_COMMA_MASK 1111111111 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 1 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE ENABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000011100\
RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00011100 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false\
RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0\
00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2\
false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 1 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE\
MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET K28.5 RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {4} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/pcie_axi_bridge_support/gt_quad_0 {/pcie_axi_bridge_support/gt_quad_0 pcie_pcie_phy_0.IP_CH0,pcie_pcie_phy_0.IP_CH1,pcie_pcie_phy_0.IP_CH2,pcie_pcie_phy_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/pcie_axi_bridge_support/gt_quad_0 {/pcie_axi_bridge_support/gt_quad_0 pcie_pcie_phy_0.IP_CH0,pcie_pcie_phy_0.IP_CH1,pcie_pcie_phy_0.IP_CH2,pcie_pcie_phy_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_100_MHz_unique1 HSCLK0_RPLLGTREFCLK0 refclk_PROT0_R0_100_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_100_MHz_unique1 HSCLK1_RPLLGTREFCLK0\
refclk_PROT0_R0_100_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT0} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {PROT0} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT0} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {PROT0} \
  ] $gt_quad_0

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.REFCLK_LIST.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins refclk_ibuf/CLK_IN_D] [get_bd_intf_pins pcie_refclk]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins pcie_phy/pcie_mgt] [get_bd_intf_pins pcie_mgt]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins pcie/m_axis_cq] [get_bd_intf_pins m_axis_cq]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins pcie/m_axis_rc] [get_bd_intf_pins m_axis_rc]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins pcie/pcie_cfg_fc] [get_bd_intf_pins pcie_cfg_fc]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins pcie/pcie_cfg_interrupt] [get_bd_intf_pins pcie_cfg_interrupt]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins pcie/pcie_cfg_mesg_rcvd] [get_bd_intf_pins pcie_cfg_mesg_rcvd]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins pcie/pcie_cfg_mesg_tx] [get_bd_intf_pins pcie_cfg_mesg_tx]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins pcie/s_axis_cc] [get_bd_intf_pins s_axis_cc]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins pcie/s_axis_rq] [get_bd_intf_pins s_axis_rq]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins pcie/pcie_cfg_control] [get_bd_intf_pins pcie_cfg_control]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins pcie/pcie_cfg_external_msix_without_msi] [get_bd_intf_pins pcie_cfg_external_msix_without_msi]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins pcie/pcie_cfg_mgmt] [get_bd_intf_pins pcie_cfg_mgmt]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins pcie/pcie_cfg_status] [get_bd_intf_pins pcie_cfg_status]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins pcie/pcie_transmit_fc] [get_bd_intf_pins pcie_transmit_fc]
  connect_bd_intf_net -intf_net gt_quad_0_GT0_BUFGT [get_bd_intf_pins pcie_phy/GT_BUFGT] [get_bd_intf_pins gt_quad_0/GT0_BUFGT]
  connect_bd_intf_net -intf_net gt_quad_0_GT_Serial [get_bd_intf_pins pcie_phy/GT0_Serial] [get_bd_intf_pins gt_quad_0/GT_Serial]
  connect_bd_intf_net -intf_net pcie_phy_GT_RX0 [get_bd_intf_pins pcie_phy/GT_RX0] [get_bd_intf_pins gt_quad_0/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_RX1 [get_bd_intf_pins pcie_phy/GT_RX1] [get_bd_intf_pins gt_quad_0/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_RX2 [get_bd_intf_pins pcie_phy/GT_RX2] [get_bd_intf_pins gt_quad_0/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_RX3 [get_bd_intf_pins pcie_phy/GT_RX3] [get_bd_intf_pins gt_quad_0/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_TX0 [get_bd_intf_pins pcie_phy/GT_TX0] [get_bd_intf_pins gt_quad_0/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_TX1 [get_bd_intf_pins pcie_phy/GT_TX1] [get_bd_intf_pins gt_quad_0/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_TX2 [get_bd_intf_pins pcie_phy/GT_TX2] [get_bd_intf_pins gt_quad_0/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_GT_TX3 [get_bd_intf_pins pcie_phy/GT_TX3] [get_bd_intf_pins gt_quad_0/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net pcie_phy_gt_rxmargin_q0 [get_bd_intf_pins pcie_phy/gt_rxmargin_q0] [get_bd_intf_pins gt_quad_0/gt_rxmargin_intf]
  connect_bd_intf_net -intf_net pcie_phy_mac_rx [get_bd_intf_pins pcie_phy/phy_mac_rx] [get_bd_intf_pins pcie/phy_mac_rx]
  connect_bd_intf_net -intf_net pcie_phy_mac_tx [get_bd_intf_pins pcie_phy/phy_mac_tx] [get_bd_intf_pins pcie/phy_mac_tx]
  connect_bd_intf_net -intf_net pcie_phy_phy_mac_command [get_bd_intf_pins pcie_phy/phy_mac_command] [get_bd_intf_pins pcie/phy_mac_command]
  connect_bd_intf_net -intf_net pcie_phy_phy_mac_rx_margining [get_bd_intf_pins pcie_phy/phy_mac_rx_margining] [get_bd_intf_pins pcie/phy_mac_rx_margining]
  connect_bd_intf_net -intf_net pcie_phy_phy_mac_status [get_bd_intf_pins pcie_phy/phy_mac_status] [get_bd_intf_pins pcie/phy_mac_status]
  connect_bd_intf_net -intf_net pcie_phy_phy_mac_tx_drive [get_bd_intf_pins pcie_phy/phy_mac_tx_drive] [get_bd_intf_pins pcie/phy_mac_tx_drive]
  connect_bd_intf_net -intf_net pcie_phy_phy_mac_tx_eq [get_bd_intf_pins pcie_phy/phy_mac_tx_eq] [get_bd_intf_pins pcie/phy_mac_tx_eq]

  # Create port connections
  connect_bd_net -net BUFG_GT_CE_1  [get_bd_pins BUFG_GT_CE] \
  [get_bd_pins bufg_gt_sysclk/BUFG_GT_CE]
  connect_bd_net -net apb3clk_1  [get_bd_pins apb3clk] \
  [get_bd_pins gt_quad_0/apb3clk]
  connect_bd_net -net bufg_gt_sysclk_BUFG_GT_O  [get_bd_pins bufg_gt_sysclk/BUFG_GT_O] \
  [get_bd_pins pcie_phy/phy_refclk] \
  [get_bd_pins pcie/sys_clk]
  connect_bd_net -net gt_quad_0_ch0_phyready  [get_bd_pins gt_quad_0/ch0_phyready] \
  [get_bd_pins pcie_phy/ch0_phyready]
  connect_bd_net -net gt_quad_0_ch0_phystatus  [get_bd_pins gt_quad_0/ch0_phystatus] \
  [get_bd_pins pcie_phy/ch0_phystatus]
  connect_bd_net -net gt_quad_0_ch0_rxoutclk  [get_bd_pins gt_quad_0/ch0_rxoutclk] \
  [get_bd_pins pcie_phy/gt_rxoutclk]
  connect_bd_net -net gt_quad_0_ch0_txoutclk  [get_bd_pins gt_quad_0/ch0_txoutclk] \
  [get_bd_pins pcie_phy/gt_txoutclk]
  connect_bd_net -net gt_quad_0_ch1_phyready  [get_bd_pins gt_quad_0/ch1_phyready] \
  [get_bd_pins pcie_phy/ch1_phyready]
  connect_bd_net -net gt_quad_0_ch1_phystatus  [get_bd_pins gt_quad_0/ch1_phystatus] \
  [get_bd_pins pcie_phy/ch1_phystatus]
  connect_bd_net -net gt_quad_0_ch2_phyready  [get_bd_pins gt_quad_0/ch2_phyready] \
  [get_bd_pins pcie_phy/ch2_phyready]
  connect_bd_net -net gt_quad_0_ch2_phystatus  [get_bd_pins gt_quad_0/ch2_phystatus] \
  [get_bd_pins pcie_phy/ch2_phystatus]
  connect_bd_net -net gt_quad_0_ch3_phyready  [get_bd_pins gt_quad_0/ch3_phyready] \
  [get_bd_pins pcie_phy/ch3_phyready]
  connect_bd_net -net gt_quad_0_ch3_phystatus  [get_bd_pins gt_quad_0/ch3_phystatus] \
  [get_bd_pins pcie_phy/ch3_phystatus]
  connect_bd_net -net pcie_pcie_ltssm_state  [get_bd_pins pcie/pcie_ltssm_state] \
  [get_bd_pins pcie_phy/pcie_ltssm_state]
  connect_bd_net -net pcie_phy_gt_pcieltssm  [get_bd_pins pcie_phy/gt_pcieltssm] \
  [get_bd_pins gt_quad_0/pcieltssm]
  connect_bd_net -net pcie_phy_gtrefclk  [get_bd_pins pcie_phy/gtrefclk] \
  [get_bd_pins gt_quad_0/GT_REFCLK0]
  connect_bd_net -net pcie_phy_pcierstb  [get_bd_pins pcie_phy/pcierstb] \
  [get_bd_pins gt_quad_0/ch0_pcierstb] \
  [get_bd_pins gt_quad_0/ch1_pcierstb] \
  [get_bd_pins gt_quad_0/ch2_pcierstb] \
  [get_bd_pins gt_quad_0/ch3_pcierstb]
  connect_bd_net -net pcie_phy_phy_coreclk  [get_bd_pins pcie_phy/phy_coreclk] \
  [get_bd_pins pcie/phy_coreclk]
  connect_bd_net -net pcie_phy_phy_mcapclk  [get_bd_pins pcie_phy/phy_mcapclk] \
  [get_bd_pins pcie/phy_mcapclk]
  connect_bd_net -net pcie_phy_phy_pclk  [get_bd_pins pcie_phy/phy_pclk] \
  [get_bd_pins pcie/phy_pclk] \
  [get_bd_pins gt_quad_0/ch0_txusrclk] \
  [get_bd_pins gt_quad_0/ch1_txusrclk] \
  [get_bd_pins gt_quad_0/ch2_txusrclk] \
  [get_bd_pins gt_quad_0/ch3_txusrclk] \
  [get_bd_pins gt_quad_0/ch0_rxusrclk] \
  [get_bd_pins gt_quad_0/ch1_rxusrclk] \
  [get_bd_pins gt_quad_0/ch2_rxusrclk] \
  [get_bd_pins gt_quad_0/ch3_rxusrclk]
  connect_bd_net -net pcie_phy_phy_userclk  [get_bd_pins pcie_phy/phy_userclk] \
  [get_bd_pins pcie/phy_userclk]
  connect_bd_net -net pcie_phy_phy_userclk2  [get_bd_pins pcie_phy/phy_userclk2] \
  [get_bd_pins pcie/phy_userclk2]
  connect_bd_net -net pcie_phy_rdy_out  [get_bd_pins pcie/phy_rdy_out] \
  [get_bd_pins phy_rdy_out]
  connect_bd_net -net pcie_user_clk  [get_bd_pins pcie/user_clk] \
  [get_bd_pins user_clk]
  connect_bd_net -net pcie_user_lnk_up  [get_bd_pins pcie/user_lnk_up] \
  [get_bd_pins user_lnk_up]
  connect_bd_net -net pcie_user_reset  [get_bd_pins pcie/user_reset] \
  [get_bd_pins user_reset]
  connect_bd_net -net refclk_ibuf_IBUF_DS_ODIV2  [get_bd_pins refclk_ibuf/IBUF_DS_ODIV2] \
  [get_bd_pins bufg_gt_sysclk/BUFG_GT_I]
  connect_bd_net -net refclk_ibuf_IBUF_OUT  [get_bd_pins refclk_ibuf/IBUF_OUT] \
  [get_bd_pins pcie_phy/phy_gtrefclk] \
  [get_bd_pins pcie/sys_clk_gt]
  connect_bd_net -net sys_reset_1  [get_bd_pins sys_reset] \
  [get_bd_pins pcie_phy/phy_rst_n] \
  [get_bd_pins pcie/sys_reset]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set S_AXI_BRIDGE [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_BRIDGE ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {12} \
   CONFIG.AWUSER_WIDTH {12} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {4} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {32} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {32} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {16} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {16} \
   ] $S_AXI_BRIDGE

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 pcie_mgt ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]

  set M_AXI_BRIDGE [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_BRIDGE ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {32} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M_AXI_BRIDGE

  set usr_irq [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_eqdma:usr_irq_rtl:1.0 usr_irq ]

  set S_AXI_LITE [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {13} \
   CONFIG.AWUSER_WIDTH {13} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_LITE


  # Create ports
  set phy_rdy_out [ create_bd_port -dir O phy_rdy_out ]
  set sys_reset [ create_bd_port -dir I -type rst sys_reset ]
  set user_lnk_up [ create_bd_port -dir O user_lnk_up ]
  set axi_aclk [ create_bd_port -dir O -type clk axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M_AXI_BRIDGE:S_AXI_BRIDGE:S_AXI_LITE} \
 ] $axi_aclk
  set axi_aresetn [ create_bd_port -dir O -type rst axi_aresetn ]
  set BUFG_GT_CE [ create_bd_port -dir I -from 0 -to 0 BUFG_GT_CE ]
  set apb3clk [ create_bd_port -dir I -type clk -freq_hz 200000000 apb3clk ]
  set soft_reset_n [ create_bd_port -dir I -type rst soft_reset_n ]

  # Create instance: pcie_axi_bridge, and set properties
  set pcie_axi_bridge [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:5.1 pcie_axi_bridge ]
  set_property -dict [list \
    CONFIG.EGW_IS_PARENT_IP {1} \
    CONFIG.INS_LOSS_NYQ {15} \
    CONFIG.MAILBOX_ENABLE {false} \
    CONFIG.MSI_X_OPTIONS {MSI-X_External} \
    CONFIG.PCIE_BOARD_INTERFACE {Custom} \
    CONFIG.PF0_MSIX_CAP_TABLE_SIZE_qdma {007} \
    CONFIG.PF0_SRIOV_FUNC_DEP_LINK {0000} \
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {C034} \
    CONFIG.PF1_INTERRUPT_PIN {INTA} \
    CONFIG.PF1_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PF2_INTERRUPT_PIN {INTA} \
    CONFIG.PF2_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PF3_INTERRUPT_PIN {INTA} \
    CONFIG.PF3_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PL_DISABLE_LANE_REVERSAL {TRUE} \
    CONFIG.PL_DISABLE_LANE_REVERSAL_NV {false} \
    CONFIG.PS_TYPE_IN {PS9} \
    CONFIG.RX_PPM_OFFSET {0} \
    CONFIG.RX_SSC_PPM {0} \
    CONFIG.SRIOV_CAP_ENABLE {false} \
    CONFIG.SRIOV_FIRST_VF_OFFSET {16} \
    CONFIG.SYS_RST_N_BOARD_INTERFACE {Custom} \
    CONFIG.Shared_Logic_Both {false} \
    CONFIG.Shared_Logic_Clk {false} \
    CONFIG.Shared_Logic_Gtc {false} \
    CONFIG.VFG0_MSIX_CAP_TABLE_SIZE_qdma {007} \
    CONFIG.acs_ext_cap_enable {false} \
    CONFIG.adv_int_usr {false} \
    CONFIG.alf_cap_enable {false} \
    CONFIG.all_speeds_all_sides {NO} \
    CONFIG.async_clk_enable {false} \
    CONFIG.axi_aclk_loopback {false} \
    CONFIG.axi_addr_width {64} \
    CONFIG.axi_data_width {128_bit} \
    CONFIG.axi_id_width {4} \
    CONFIG.axi_vip_in_exdes {false} \
    CONFIG.axibar2pciebar_0 {0x0000000000000000} \
    CONFIG.axibar_notranslate {false} \
    CONFIG.axilite_master_en {false} \
    CONFIG.axist_bypass_en {false} \
    CONFIG.axisten_freq {250} \
    CONFIG.axisten_if_enable_msg_route {1EFFF} \
    CONFIG.axisten_if_enable_msg_route_override {true} \
    CONFIG.bar0_indicator {1} \
    CONFIG.bar1_indicator {0} \
    CONFIG.bar2_indicator {0} \
    CONFIG.bar3_indicator {0} \
    CONFIG.bar4_indicator {0} \
    CONFIG.bar5_indicator {0} \
    CONFIG.bar_indicator {BAR_0} \
    CONFIG.barlite2 {7} \
    CONFIG.barlite_mb_pf0 {0} \
    CONFIG.barlite_mb_pf1 {0} \
    CONFIG.barlite_mb_pf2 {0} \
    CONFIG.barlite_mb_pf3 {0} \
    CONFIG.bridge_burst {TRUE} \
    CONFIG.bridge_register_access {false} \
    CONFIG.bridge_registers_offset_enable {false} \
    CONFIG.c2h_stream_cpl_col_bit_pos0 {1} \
    CONFIG.c2h_stream_cpl_col_bit_pos1 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos2 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos3 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos4 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos5 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos6 {0} \
    CONFIG.c2h_stream_cpl_col_bit_pos7 {0} \
    CONFIG.c2h_stream_cpl_data_size {8_Bytes} \
    CONFIG.c2h_stream_cpl_err_bit_pos0 {2} \
    CONFIG.c2h_stream_cpl_err_bit_pos1 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos2 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos3 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos4 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos5 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos6 {0} \
    CONFIG.c2h_stream_cpl_err_bit_pos7 {0} \
    CONFIG.c_ats_enable {false} \
    CONFIG.c_m_axi_num_write {32} \
    CONFIG.c_pri_enable {false} \
    CONFIG.cfg_mgmt_if {true} \
    CONFIG.cfg_space_enable {false} \
    CONFIG.comp_timeout {50ms} \
    CONFIG.copy_pf0 {true} \
    CONFIG.copy_sriov_pf0 {true} \
    CONFIG.csr_axilite_slave {false} \
    CONFIG.csr_module {1} \
    CONFIG.data_mover {false} \
    CONFIG.datapath_reorder {false} \
    CONFIG.debug_mode {DEBUG_NONE} \
    CONFIG.descriptor_bypass_exdes {false} \
    CONFIG.device_port_type {PCI_Express_Endpoint_device} \
    CONFIG.disable_bram_pipeline {false} \
    CONFIG.disable_eq_synchronizer {false} \
    CONFIG.disable_gt_loc {false} \
    CONFIG.disable_speed_width_drc {false} \
    CONFIG.disable_user_clock_root {true} \
    CONFIG.dma_2rp {false} \
    CONFIG.dma_intf_sel_qdma {AXI_MM} \
    CONFIG.dma_mode_en {false} \
    CONFIG.dma_reset_source_sel {PCIe_User_Reset} \
    CONFIG.double_quad {false} \
    CONFIG.dsc_byp_mode {None} \
    CONFIG.dsc_bypass_rd_out {false} \
    CONFIG.dsc_bypass_wr_out {false} \
    CONFIG.en_axi_master_if {true} \
    CONFIG.en_axi_mm_qdma {true} \
    CONFIG.en_axi_slave_if {true} \
    CONFIG.en_axi_st_qdma {false} \
    CONFIG.en_bridge {true} \
    CONFIG.en_coreclk_es1 {false} \
    CONFIG.en_dbg_descramble {false} \
    CONFIG.en_debug_ports {false} \
    CONFIG.en_dma_and_bridge {false} \
    CONFIG.en_dma_completion {false} \
    CONFIG.en_ext_ch_gt_drp {false} \
    CONFIG.en_gt_selection {false} \
    CONFIG.en_l23_entry {false} \
    CONFIG.en_legacy_intrs_bridge {false} \
    CONFIG.en_pcie_drp {false} \
    CONFIG.en_qdma {true} \
    CONFIG.en_transceiver_status_ports {false} \
    CONFIG.enable_64bit {true} \
    CONFIG.enable_at_ports {false} \
    CONFIG.enable_ats_switch {FALSE} \
    CONFIG.enable_auto_rxeq {False} \
    CONFIG.enable_ccix {FALSE} \
    CONFIG.enable_clock_delay_grp {true} \
    CONFIG.enable_code {0000} \
    CONFIG.enable_dvsec {FALSE} \
    CONFIG.enable_error_injection {false} \
    CONFIG.enable_gen4 {true} \
    CONFIG.enable_gen4_low_sp_gra {false} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.enable_ibert {false} \
    CONFIG.enable_jtag_dbg {false} \
    CONFIG.enable_mark_debug {false} \
    CONFIG.enable_more_clk {false} \
    CONFIG.enable_multi_pcie {false} \
    CONFIG.enable_pcie_debug_ports {True} \
    CONFIG.enable_resource_reduction {false} \
    CONFIG.enable_x16 {false} \
    CONFIG.example_design_type {RTL} \
    CONFIG.exdes_flow {false} \
    CONFIG.ext_sys_clk_bufg {false} \
    CONFIG.flr_enable {false} \
    CONFIG.free_run_freq {100_MHz} \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.gen4_eieos_0s7 {true} \
    CONFIG.gt_loc_num {X99Y99} \
    CONFIG.gt_quad_sharing {false} \
    CONFIG.gtcom_in_core_usp {2} \
    CONFIG.gtwiz_in_core_us {1} \
    CONFIG.gtwiz_in_core_usp {1} \
    CONFIG.iep_enable {false} \
    CONFIG.ins_loss_profile {Add-in_Card} \
    CONFIG.insert_cips {false} \
    CONFIG.lane_order {Bottom} \
    CONFIG.lane_reversal {false} \
    CONFIG.last_core_cap_addr {0x100} \
    CONFIG.local_test {false} \
    CONFIG.master_cal_only {true} \
    CONFIG.mhost_en {false} \
    CONFIG.minimal_dma_en {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.msix_pcie_internal {false} \
    CONFIG.msix_preset {0} \
    CONFIG.mult_pf_des {false} \
    CONFIG.num_queues {512} \
    CONFIG.old_bridge_timeout {false} \
    CONFIG.parity_settings {None} \
    CONFIG.pcie_blk_locn {S0X0Y1} \
    CONFIG.pcie_extended_tag {true} \
    CONFIG.pcie_id_if {true} \
    CONFIG.performance {false} \
    CONFIG.performance_exdes {false} \
    CONFIG.pf0_Use_Class_Code_Lookup_Assistant_qdma {false} \
    CONFIG.pf0_aer_cap_ecrc_gen_and_check_capable {false} \
    CONFIG.pf0_ari_enabled {false} \
    CONFIG.pf0_ats_enabled {false} \
    CONFIG.pf0_bar0_64bit_qdma {true} \
    CONFIG.pf0_bar0_index {0} \
    CONFIG.pf0_bar0_prefetchable_qdma {false} \
    CONFIG.pf0_bar0_scale_qdma {Gigabytes} \
    CONFIG.pf0_bar0_size_qdma {16} \
    CONFIG.pf0_bar0_type_qdma {AXI_Bridge_Master} \
    CONFIG.pf0_bar1_index {7} \
    CONFIG.pf0_bar2_64bit_qdma {true} \
    CONFIG.pf0_bar2_enabled_qdma {true} \
    CONFIG.pf0_bar2_index {7} \
    CONFIG.pf0_bar2_prefetchable_qdma {false} \
    CONFIG.pf0_bar2_scale_qdma {Gigabytes} \
    CONFIG.pf0_bar2_size_qdma {1} \
    CONFIG.pf0_bar2_type_qdma {AXI_Bridge_Master} \
    CONFIG.pf0_bar3_index {7} \
    CONFIG.pf0_bar4_enabled_qdma {false} \
    CONFIG.pf0_bar4_index {7} \
    CONFIG.pf0_bar5_enabled_qdma {false} \
    CONFIG.pf0_bar5_index {7} \
    CONFIG.pf0_bar5_prefetchable_qdma {false} \
    CONFIG.pf0_base_class_menu_qdma {Memory_controller} \
    CONFIG.pf0_class_code_base_qdma {05} \
    CONFIG.pf0_class_code_interface_qdma {00} \
    CONFIG.pf0_class_code_sub_qdma {80} \
    CONFIG.pf0_device_id {B034} \
    CONFIG.pf0_expansion_rom_enabled_qdma {false} \
    CONFIG.pf0_interrupt_pin {INTA} \
    CONFIG.pf0_link_status_slot_clock_config {true} \
    CONFIG.pf0_msix_cap_pba_offset {00008FE0} \
    CONFIG.pf0_msix_cap_table_offset {00008000} \
    CONFIG.pf0_msix_cap_table_size {020} \
    CONFIG.pf0_msix_enabled_qdma {true} \
    CONFIG.pf0_msix_impl_locn {External} \
    CONFIG.pf0_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf0_pciebar2axibar_2 {0x0000000000000000} \
    CONFIG.pf0_pri_enabled {false} \
    CONFIG.pf0_rbar_cap_bar0 {0x00000000fff0} \
    CONFIG.pf0_rbar_cap_bar1 {0x000000000000} \
    CONFIG.pf0_rbar_cap_bar2 {0x000000000000} \
    CONFIG.pf0_rbar_cap_bar3 {0x000000000000} \
    CONFIG.pf0_rbar_cap_bar4 {0x000000000000} \
    CONFIG.pf0_rbar_cap_bar5 {0x000000000000} \
    CONFIG.pf0_rbar_num {1} \
    CONFIG.pf0_revision_id {00} \
    CONFIG.pf0_sriov_bar0_64bit {true} \
    CONFIG.pf0_sriov_bar0_prefetchable {true} \
    CONFIG.pf0_sriov_bar0_scale {Kilobytes} \
    CONFIG.pf0_sriov_bar0_size {4} \
    CONFIG.pf0_sriov_bar0_type {AXI_Bridge_Master} \
    CONFIG.pf0_sriov_bar2_64bit {true} \
    CONFIG.pf0_sriov_bar2_enabled {true} \
    CONFIG.pf0_sriov_bar2_prefetchable {true} \
    CONFIG.pf0_sriov_bar2_scale {Kilobytes} \
    CONFIG.pf0_sriov_bar2_size {4} \
    CONFIG.pf0_sriov_bar2_type {AXI_Bridge_Master} \
    CONFIG.pf0_sriov_bar4_enabled {false} \
    CONFIG.pf0_sriov_bar5_64bit {false} \
    CONFIG.pf0_sriov_bar5_enabled {false} \
    CONFIG.pf0_sriov_bar5_prefetchable {false} \
    CONFIG.pf0_sriov_cap_ver {1} \
    CONFIG.pf0_sub_class_interface_menu_qdma {Other_memory_controller} \
    CONFIG.pf0_subsystem_id {0007} \
    CONFIG.pf0_subsystem_vendor_id {10EE} \
    CONFIG.pf0_vc_cap_enabled {true} \
    CONFIG.pf0_vf_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf0_vf_pciebar2axibar_2 {0x0000000040000000} \
    CONFIG.pf1_Use_Class_Code_Lookup_Assistant_qdma {false} \
    CONFIG.pf1_bar0_index {0} \
    CONFIG.pf1_bar1_index {7} \
    CONFIG.pf1_bar2_index {7} \
    CONFIG.pf1_bar3_index {7} \
    CONFIG.pf1_bar4_index {7} \
    CONFIG.pf1_bar5_index {7} \
    CONFIG.pf1_bar5_prefetchable_qdma {false} \
    CONFIG.pf1_base_class_menu_qdma {Memory_controller} \
    CONFIG.pf1_class_code_base_qdma {05} \
    CONFIG.pf1_class_code_interface_qdma {00} \
    CONFIG.pf1_class_code_sub_qdma {80} \
    CONFIG.pf1_device_id {B134} \
    CONFIG.pf1_msi_enabled {false} \
    CONFIG.pf1_msix_enabled {true} \
    CONFIG.pf1_msix_enabled_qdma {false} \
    CONFIG.pf1_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf1_pciebar2axibar_2 {0x0000000010000000} \
    CONFIG.pf1_rbar_cap_bar0 {0x00000000fff0} \
    CONFIG.pf1_rbar_cap_bar1 {0x000000000000} \
    CONFIG.pf1_rbar_cap_bar2 {0x000000000000} \
    CONFIG.pf1_rbar_cap_bar3 {0x000000000000} \
    CONFIG.pf1_rbar_cap_bar4 {0x000000000000} \
    CONFIG.pf1_rbar_cap_bar5 {0x000000000000} \
    CONFIG.pf1_rbar_num {1} \
    CONFIG.pf1_revision_id {00} \
    CONFIG.pf1_sriov_bar5_64bit {false} \
    CONFIG.pf1_sriov_bar5_prefetchable {false} \
    CONFIG.pf1_sub_class_interface_menu_qdma {Other_memory_controller} \
    CONFIG.pf1_subsystem_id {0007} \
    CONFIG.pf1_vf_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf1_vf_pciebar2axibar_2 {0x0000000050000000} \
    CONFIG.pf2_Use_Class_Code_Lookup_Assistant_qdma {false} \
    CONFIG.pf2_bar0_index {0} \
    CONFIG.pf2_bar1_index {7} \
    CONFIG.pf2_bar2_index {7} \
    CONFIG.pf2_bar3_index {7} \
    CONFIG.pf2_bar4_index {7} \
    CONFIG.pf2_bar5_index {7} \
    CONFIG.pf2_bar5_prefetchable_qdma {false} \
    CONFIG.pf2_base_class_menu_qdma {Memory_controller} \
    CONFIG.pf2_class_code_base_qdma {05} \
    CONFIG.pf2_class_code_interface_qdma {00} \
    CONFIG.pf2_class_code_sub_qdma {80} \
    CONFIG.pf2_device_id {B234} \
    CONFIG.pf2_msi_enabled {false} \
    CONFIG.pf2_msix_enabled_qdma {false} \
    CONFIG.pf2_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf2_pciebar2axibar_2 {0x0000000020000000} \
    CONFIG.pf2_rbar_cap_bar0 {0x00000000fff0} \
    CONFIG.pf2_rbar_cap_bar1 {0x000000000000} \
    CONFIG.pf2_rbar_cap_bar2 {0x000000000000} \
    CONFIG.pf2_rbar_cap_bar3 {0x000000000000} \
    CONFIG.pf2_rbar_cap_bar4 {0x000000000000} \
    CONFIG.pf2_rbar_cap_bar5 {0x000000000000} \
    CONFIG.pf2_rbar_num {1} \
    CONFIG.pf2_revision_id {00} \
    CONFIG.pf2_sriov_bar5_64bit {false} \
    CONFIG.pf2_sriov_bar5_prefetchable {false} \
    CONFIG.pf2_sub_class_interface_menu_qdma {Other_memory_controller} \
    CONFIG.pf2_subsystem_id {0007} \
    CONFIG.pf2_vf_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf2_vf_pciebar2axibar_2 {0x0000000060000000} \
    CONFIG.pf3_Use_Class_Code_Lookup_Assistant_qdma {false} \
    CONFIG.pf3_bar0_index {0} \
    CONFIG.pf3_bar1_index {7} \
    CONFIG.pf3_bar2_index {7} \
    CONFIG.pf3_bar3_index {7} \
    CONFIG.pf3_bar4_index {7} \
    CONFIG.pf3_bar5_index {7} \
    CONFIG.pf3_bar5_prefetchable_qdma {false} \
    CONFIG.pf3_base_class_menu_qdma {Memory_controller} \
    CONFIG.pf3_class_code_base_qdma {05} \
    CONFIG.pf3_class_code_interface_qdma {00} \
    CONFIG.pf3_class_code_sub_qdma {80} \
    CONFIG.pf3_device_id {B334} \
    CONFIG.pf3_msi_enabled {false} \
    CONFIG.pf3_msix_enabled_qdma {false} \
    CONFIG.pf3_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf3_pciebar2axibar_2 {0x0000000030000000} \
    CONFIG.pf3_rbar_cap_bar0 {0x00000000fff0} \
    CONFIG.pf3_rbar_cap_bar1 {0x000000000000} \
    CONFIG.pf3_rbar_cap_bar2 {0x000000000000} \
    CONFIG.pf3_rbar_cap_bar3 {0x000000000000} \
    CONFIG.pf3_rbar_cap_bar4 {0x000000000000} \
    CONFIG.pf3_rbar_cap_bar5 {0x000000000000} \
    CONFIG.pf3_rbar_num {1} \
    CONFIG.pf3_revision_id {00} \
    CONFIG.pf3_sriov_bar5_64bit {false} \
    CONFIG.pf3_sriov_bar5_prefetchable {false} \
    CONFIG.pf3_sub_class_interface_menu_qdma {Other_memory_controller} \
    CONFIG.pf3_subsystem_id {0007} \
    CONFIG.pf3_vf_pciebar2axibar_0 {0x0000000000000000} \
    CONFIG.pf3_vf_pciebar2axibar_2 {0x0000000070000000} \
    CONFIG.pfch_cache_depth {16} \
    CONFIG.pipe_line_stage {2} \
    CONFIG.pipe_sim {false} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
    CONFIG.rbar_enable {false} \
    CONFIG.ref_clk_freq {100_MHz} \
    CONFIG.replace_uram_with_bram {false} \
    CONFIG.rq_rcfg_en {TRUE} \
    CONFIG.rx_detect {Default} \
    CONFIG.set_finite_credit {false} \
    CONFIG.silicon_rev {Pre-Production} \
    CONFIG.sim_model {NO} \
    CONFIG.soft_nic {false} \
    CONFIG.soft_nic_bridge {false} \
    CONFIG.split_dma {true} \
    CONFIG.tandem_enable_rfsoc {false} \
    CONFIG.testname {mm} \
    CONFIG.three_port_switch {false} \
    CONFIG.timeout0_sel {14} \
    CONFIG.timeout1_sel {15} \
    CONFIG.timeout_mult {3} \
    CONFIG.tl_credits_cd {15} \
    CONFIG.tl_credits_ch {15} \
    CONFIG.tl_pf_enable_reg {4} \
    CONFIG.tl_tx_mux_strict_priority {false} \
    CONFIG.two_port_switch {false} \
    CONFIG.usplus_es1_seqnum_bypass {false} \
    CONFIG.usr_irq_exdes {false} \
    CONFIG.usr_irq_xdma_type_interface {false} \
    CONFIG.vcu118_board {false} \
    CONFIG.vcu118_ddr_ex {false} \
    CONFIG.vdpa_exdes {false} \
    CONFIG.vendor_id {10EE} \
    CONFIG.virtio_en {false} \
    CONFIG.virtio_exdes {false} \
    CONFIG.virtio_perf_exdes {false} \
    CONFIG.vsec_cap_addr {0xE00} \
    CONFIG.vu9p_board {false} \
    CONFIG.vu9p_tul_ex {false} \
    CONFIG.warm_reboot_sbr_fix {false} \
    CONFIG.wrb_coal_loop_fix_disable {false} \
    CONFIG.wrb_coal_max_buf {16} \
    CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
    CONFIG.xdma_dsc_bypass {false} \
    CONFIG.xdma_non_incremental_exdes {false} \
    CONFIG.xdma_num_usr_irq {16} \
    CONFIG.xdma_pcie_64bit_en {false} \
    CONFIG.xdma_rnum_chnl {4} \
    CONFIG.xdma_rnum_rids {32} \
    CONFIG.xdma_st_infinite_desc_exdes {false} \
    CONFIG.xdma_sts_ports {false} \
    CONFIG.xdma_wnum_chnl {4} \
    CONFIG.xdma_wnum_rids {32} \
    CONFIG.xlnx_ddr_ex {false} \
    CONFIG.xlnx_ref_board {None} \
  ] $pcie_axi_bridge


  # Create instance: pcie_axi_bridge_support
  create_hier_cell_pcie_axi_bridge_support [current_bd_instance .] pcie_axi_bridge_support

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_BRIDGE_1 [get_bd_intf_ports S_AXI_BRIDGE] [get_bd_intf_pins pcie_axi_bridge/S_AXI_BRIDGE]
  connect_bd_intf_net -intf_net S_AXI_LITE_0_1 [get_bd_intf_ports S_AXI_LITE] [get_bd_intf_pins pcie_axi_bridge/S_AXI_LITE]
  connect_bd_intf_net -intf_net pcie_axi_bridge_M_AXI_BRIDGE [get_bd_intf_ports M_AXI_BRIDGE] [get_bd_intf_pins pcie_axi_bridge/M_AXI_BRIDGE]
  connect_bd_intf_net -intf_net pcie_axi_bridge_pcie_cfg_control_if [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_control_if] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_control]
  connect_bd_intf_net -intf_net pcie_axi_bridge_pcie_cfg_external_msix_without_msi_if [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_external_msix_without_msi_if] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_external_msix_without_msi]
  connect_bd_intf_net -intf_net pcie_axi_bridge_pcie_cfg_interrupt [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_interrupt] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_interrupt]
  connect_bd_intf_net -intf_net pcie_axi_bridge_pcie_cfg_mgmt_if [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_mgmt_if] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_mgmt]
  connect_bd_intf_net -intf_net pcie_axi_bridge_s_axis_cc [get_bd_intf_pins pcie_axi_bridge/s_axis_cc] [get_bd_intf_pins pcie_axi_bridge_support/s_axis_cc]
  connect_bd_intf_net -intf_net pcie_axi_bridge_s_axis_rq [get_bd_intf_pins pcie_axi_bridge/s_axis_rq] [get_bd_intf_pins pcie_axi_bridge_support/s_axis_rq]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_m_axis_cq [get_bd_intf_pins pcie_axi_bridge/m_axis_cq] [get_bd_intf_pins pcie_axi_bridge_support/m_axis_cq]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_m_axis_rc [get_bd_intf_pins pcie_axi_bridge/m_axis_rc] [get_bd_intf_pins pcie_axi_bridge_support/m_axis_rc]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_cfg_fc [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_fc] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_fc]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_cfg_mesg_rcvd [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_mesg_rcvd] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_mesg_rcvd]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_cfg_mesg_tx [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_mesg_tx] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_mesg_tx]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_cfg_status [get_bd_intf_pins pcie_axi_bridge/pcie_cfg_status_if] [get_bd_intf_pins pcie_axi_bridge_support/pcie_cfg_status]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins pcie_axi_bridge_support/pcie_mgt]
  connect_bd_intf_net -intf_net pcie_axi_bridge_support_pcie_transmit_fc [get_bd_intf_pins pcie_axi_bridge/pcie_transmit_fc_if] [get_bd_intf_pins pcie_axi_bridge_support/pcie_transmit_fc]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins pcie_axi_bridge_support/pcie_refclk]
  connect_bd_intf_net -intf_net usr_irq_0_1 [get_bd_intf_ports usr_irq] [get_bd_intf_pins pcie_axi_bridge/usr_irq]

  # Create port connections
  connect_bd_net -net BUFG_GT_CE_0_1  [get_bd_ports BUFG_GT_CE] \
  [get_bd_pins pcie_axi_bridge_support/BUFG_GT_CE]
  connect_bd_net -net apb3clk_0_1  [get_bd_ports apb3clk] \
  [get_bd_pins pcie_axi_bridge_support/apb3clk]
  connect_bd_net -net pcie_axi_bridge_axi_aclk  [get_bd_pins pcie_axi_bridge/axi_aclk] \
  [get_bd_ports axi_aclk]
  connect_bd_net -net pcie_axi_bridge_axi_aresetn  [get_bd_pins pcie_axi_bridge/axi_aresetn] \
  [get_bd_ports axi_aresetn]
  connect_bd_net -net pcie_axi_bridge_support_phy_rdy_out  [get_bd_pins pcie_axi_bridge_support/phy_rdy_out] \
  [get_bd_pins pcie_axi_bridge/phy_rdy_out_sd] \
  [get_bd_ports phy_rdy_out]
  connect_bd_net -net pcie_axi_bridge_support_user_clk  [get_bd_pins pcie_axi_bridge_support/user_clk] \
  [get_bd_pins pcie_axi_bridge/user_clk_sd]
  connect_bd_net -net pcie_axi_bridge_support_user_lnk_up  [get_bd_pins pcie_axi_bridge_support/user_lnk_up] \
  [get_bd_pins pcie_axi_bridge/user_lnk_up_sd] \
  [get_bd_ports user_lnk_up]
  connect_bd_net -net pcie_axi_bridge_support_user_reset  [get_bd_pins pcie_axi_bridge_support/user_reset] \
  [get_bd_pins pcie_axi_bridge/user_reset_sd]
  connect_bd_net -net soft_reset_n_0_1  [get_bd_ports soft_reset_n] \
  [get_bd_pins pcie_axi_bridge/soft_reset_n]
  connect_bd_net -net sys_reset_1  [get_bd_ports sys_reset] \
  [get_bd_pins pcie_axi_bridge_support/sys_reset]

  # Create address segments
  assign_bd_address -offset 0x44A00000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces pcie_axi_bridge/M_AXI_BRIDGE] [get_bd_addr_segs M_AXI_BRIDGE/Reg] -force
  assign_bd_address -offset 0x76000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces S_AXI_BRIDGE] [get_bd_addr_segs pcie_axi_bridge/S_AXI_BRIDGE/BAR0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


