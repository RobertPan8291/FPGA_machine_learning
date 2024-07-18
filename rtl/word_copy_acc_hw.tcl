# TCL File Generated by Component Editor 18.1
# Wed Jul 03 13:50:37 PDT 2024
# DO NOT MODIFY


# 
# word_copy_acc "word_copy_acc" v1.0
#  2024.07.03.13:50:37
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module word_copy_acc
# 
set_module_property DESCRIPTION ""
set_module_property NAME word_copy_acc
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME word_copy_acc
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL wordcopy
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file wordcopy.sv SYSTEM_VERILOG PATH wordcopy.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter INIT STD_LOGIC_VECTOR 0 ""
set_parameter_property INIT DEFAULT_VALUE 0
set_parameter_property INIT DISPLAY_NAME INIT
set_parameter_property INIT WIDTH 32
set_parameter_property INIT TYPE STD_LOGIC_VECTOR
set_parameter_property INIT UNITS None
set_parameter_property INIT DESCRIPTION ""
set_parameter_property INIT HDL_PARAMETER true
add_parameter RECORD_DST STD_LOGIC_VECTOR 1
set_parameter_property RECORD_DST DEFAULT_VALUE 1
set_parameter_property RECORD_DST DISPLAY_NAME RECORD_DST
set_parameter_property RECORD_DST WIDTH 6
set_parameter_property RECORD_DST TYPE STD_LOGIC_VECTOR
set_parameter_property RECORD_DST UNITS None
set_parameter_property RECORD_DST ALLOWED_RANGES 0:63
set_parameter_property RECORD_DST HDL_PARAMETER true
add_parameter HOLD_DST STD_LOGIC_VECTOR 2
set_parameter_property HOLD_DST DEFAULT_VALUE 2
set_parameter_property HOLD_DST DISPLAY_NAME HOLD_DST
set_parameter_property HOLD_DST WIDTH 6
set_parameter_property HOLD_DST TYPE STD_LOGIC_VECTOR
set_parameter_property HOLD_DST UNITS None
set_parameter_property HOLD_DST ALLOWED_RANGES 0:63
set_parameter_property HOLD_DST HDL_PARAMETER true
add_parameter RECORD_SRC STD_LOGIC_VECTOR 3
set_parameter_property RECORD_SRC DEFAULT_VALUE 3
set_parameter_property RECORD_SRC DISPLAY_NAME RECORD_SRC
set_parameter_property RECORD_SRC WIDTH 6
set_parameter_property RECORD_SRC TYPE STD_LOGIC_VECTOR
set_parameter_property RECORD_SRC UNITS None
set_parameter_property RECORD_SRC ALLOWED_RANGES 0:63
set_parameter_property RECORD_SRC HDL_PARAMETER true
add_parameter HOLD_SRC STD_LOGIC_VECTOR 4
set_parameter_property HOLD_SRC DEFAULT_VALUE 4
set_parameter_property HOLD_SRC DISPLAY_NAME HOLD_SRC
set_parameter_property HOLD_SRC WIDTH 6
set_parameter_property HOLD_SRC TYPE STD_LOGIC_VECTOR
set_parameter_property HOLD_SRC UNITS None
set_parameter_property HOLD_SRC ALLOWED_RANGES 0:63
set_parameter_property HOLD_SRC HDL_PARAMETER true
add_parameter RECORD_N STD_LOGIC_VECTOR 5
set_parameter_property RECORD_N DEFAULT_VALUE 5
set_parameter_property RECORD_N DISPLAY_NAME RECORD_N
set_parameter_property RECORD_N WIDTH 6
set_parameter_property RECORD_N TYPE STD_LOGIC_VECTOR
set_parameter_property RECORD_N UNITS None
set_parameter_property RECORD_N ALLOWED_RANGES 0:63
set_parameter_property RECORD_N HDL_PARAMETER true
add_parameter HOLD_N STD_LOGIC_VECTOR 6
set_parameter_property HOLD_N DEFAULT_VALUE 6
set_parameter_property HOLD_N DISPLAY_NAME HOLD_N
set_parameter_property HOLD_N WIDTH 6
set_parameter_property HOLD_N TYPE STD_LOGIC_VECTOR
set_parameter_property HOLD_N UNITS None
set_parameter_property HOLD_N ALLOWED_RANGES 0:63
set_parameter_property HOLD_N HDL_PARAMETER true
add_parameter START_READ STD_LOGIC_VECTOR 7
set_parameter_property START_READ DEFAULT_VALUE 7
set_parameter_property START_READ DISPLAY_NAME START_READ
set_parameter_property START_READ WIDTH 6
set_parameter_property START_READ TYPE STD_LOGIC_VECTOR
set_parameter_property START_READ UNITS None
set_parameter_property START_READ ALLOWED_RANGES 0:63
set_parameter_property START_READ HDL_PARAMETER true
add_parameter WAIT_READ STD_LOGIC_VECTOR 8
set_parameter_property WAIT_READ DEFAULT_VALUE 8
set_parameter_property WAIT_READ DISPLAY_NAME WAIT_READ
set_parameter_property WAIT_READ WIDTH 6
set_parameter_property WAIT_READ TYPE STD_LOGIC_VECTOR
set_parameter_property WAIT_READ UNITS None
set_parameter_property WAIT_READ ALLOWED_RANGES 0:63
set_parameter_property WAIT_READ HDL_PARAMETER true
add_parameter COLLECT STD_LOGIC_VECTOR 9
set_parameter_property COLLECT DEFAULT_VALUE 9
set_parameter_property COLLECT DISPLAY_NAME COLLECT
set_parameter_property COLLECT WIDTH 6
set_parameter_property COLLECT TYPE STD_LOGIC_VECTOR
set_parameter_property COLLECT UNITS None
set_parameter_property COLLECT ALLOWED_RANGES 0:63
set_parameter_property COLLECT HDL_PARAMETER true
add_parameter SEND_DATA STD_LOGIC_VECTOR 10
set_parameter_property SEND_DATA DEFAULT_VALUE 10
set_parameter_property SEND_DATA DISPLAY_NAME SEND_DATA
set_parameter_property SEND_DATA WIDTH 6
set_parameter_property SEND_DATA TYPE STD_LOGIC_VECTOR
set_parameter_property SEND_DATA UNITS None
set_parameter_property SEND_DATA ALLOWED_RANGES 0:63
set_parameter_property SEND_DATA HDL_PARAMETER true
add_parameter INCREMENT STD_LOGIC_VECTOR 11
set_parameter_property INCREMENT DEFAULT_VALUE 11
set_parameter_property INCREMENT DISPLAY_NAME INCREMENT
set_parameter_property INCREMENT WIDTH 6
set_parameter_property INCREMENT TYPE STD_LOGIC_VECTOR
set_parameter_property INCREMENT UNITS None
set_parameter_property INCREMENT ALLOWED_RANGES 0:63
set_parameter_property INCREMENT HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point slave
# 
add_interface slave avalon end
set_interface_property slave addressUnits WORDS
set_interface_property slave associatedClock clock
set_interface_property slave associatedReset reset_sink
set_interface_property slave bitsPerSymbol 8
set_interface_property slave burstOnBurstBoundariesOnly false
set_interface_property slave burstcountUnits WORDS
set_interface_property slave explicitAddressSpan 0
set_interface_property slave holdTime 0
set_interface_property slave linewrapBursts false
set_interface_property slave maximumPendingReadTransactions 0
set_interface_property slave maximumPendingWriteTransactions 0
set_interface_property slave readLatency 0
set_interface_property slave readWaitTime 1
set_interface_property slave setupTime 0
set_interface_property slave timingUnits Cycles
set_interface_property slave writeWaitTime 0
set_interface_property slave ENABLED true
set_interface_property slave EXPORT_OF ""
set_interface_property slave PORT_NAME_MAP ""
set_interface_property slave CMSIS_SVD_VARIABLES ""
set_interface_property slave SVD_ADDRESS_GROUP ""

add_interface_port slave slave_waitrequest waitrequest Output 1
add_interface_port slave slave_address address Input 4
add_interface_port slave slave_read read Input 1
add_interface_port slave slave_readdata readdata Output 32
add_interface_port slave slave_write write Input 1
add_interface_port slave slave_writedata writedata Input 32
set_interface_assignment slave embeddedsw.configuration.isFlash 0
set_interface_assignment slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst_n reset Input 1


# 
# connection point avalon_master_1_1
# 
add_interface avalon_master_1_1 avalon start
set_interface_property avalon_master_1_1 addressUnits WORDS
set_interface_property avalon_master_1_1 associatedClock clock
set_interface_property avalon_master_1_1 associatedReset reset_sink
set_interface_property avalon_master_1_1 bitsPerSymbol 8
set_interface_property avalon_master_1_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_master_1_1 burstcountUnits WORDS
set_interface_property avalon_master_1_1 doStreamReads false
set_interface_property avalon_master_1_1 doStreamWrites false
set_interface_property avalon_master_1_1 holdTime 0
set_interface_property avalon_master_1_1 linewrapBursts false
set_interface_property avalon_master_1_1 maximumPendingReadTransactions 0
set_interface_property avalon_master_1_1 maximumPendingWriteTransactions 0
set_interface_property avalon_master_1_1 readLatency 0
set_interface_property avalon_master_1_1 readWaitTime 1
set_interface_property avalon_master_1_1 setupTime 0
set_interface_property avalon_master_1_1 timingUnits Cycles
set_interface_property avalon_master_1_1 writeWaitTime 0
set_interface_property avalon_master_1_1 ENABLED true
set_interface_property avalon_master_1_1 EXPORT_OF ""
set_interface_property avalon_master_1_1 PORT_NAME_MAP ""
set_interface_property avalon_master_1_1 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master_1_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_1_1 master_address address Output 32
add_interface_port avalon_master_1_1 master_read read Output 1
add_interface_port avalon_master_1_1 master_readdata readdata Input 32
add_interface_port avalon_master_1_1 master_readdatavalid readdatavalid Input 1
add_interface_port avalon_master_1_1 master_waitrequest waitrequest Input 1
add_interface_port avalon_master_1_1 master_write write Output 1
add_interface_port avalon_master_1_1 master_writedata writedata Output 32

