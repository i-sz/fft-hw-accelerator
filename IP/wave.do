onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_fft_hw_accelerator/rd_clk_s
add wave -noupdate /tb_fft_hw_accelerator/wr_clk_s
add wave -noupdate /tb_fft_hw_accelerator/rst_s
add wave -noupdate /tb_fft_hw_accelerator/wr_s
add wave -noupdate /tb_fft_hw_accelerator/start_cmd_s
add wave -noupdate /tb_fft_hw_accelerator/stop_cmd_s
add wave -noupdate /tb_fft_hw_accelerator/start_s
add wave -noupdate /tb_fft_hw_accelerator/stop_s
add wave -noupdate /tb_fft_hw_accelerator/read_status_s
add wave -noupdate /tb_fft_hw_accelerator/read_buffer_s
add wave -noupdate /tb_fft_hw_accelerator/mcmd_s
add wave -noupdate /tb_fft_hw_accelerator/maddr_s
add wave -noupdate /tb_fft_hw_accelerator/mdata_s
add wave -noupdate /tb_fft_hw_accelerator/sresp_s
add wave -noupdate /tb_fft_hw_accelerator/sdata_s
add wave -noupdate /tb_fft_hw_accelerator/IO_DEVICE/clock
add wave -noupdate -radix unsigned /tb_fft_hw_accelerator/IO_DEVICE/address
add wave -noupdate /tb_fft_hw_accelerator/IO_DEVICE/rden
add wave -noupdate -radix unsigned /tb_fft_hw_accelerator/IO_DEVICE/q
add wave -noupdate -radix unsigned /tb_fft_hw_accelerator/m1_samples_s
add wave -noupdate -divider OCP_SLAVE_CTRL
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/rd_clk_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/rst_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/MCmd_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/MAddr_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/MData_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/MByteEn_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/SResp_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/SData_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/start_cmd_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/stop_cmd_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/result_ready_fft_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/obuf_data_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/obuf_rd_en_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/obuf_rd_addr_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/state
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/next_state
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/clr_status_r
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/result_ready_r
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/next_SResp
add wave -noupdate /tb_fft_hw_accelerator/DUT/ocp_slave_ctrl_inst/status_zero_pad
add wave -noupdate -divider IBUF
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/clk_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/rst_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/wr_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/data_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/wr_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/data_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/wr_d
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/wr_dd
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/data_d
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_delay_inst/data_dd
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/rdclock
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/wrclock
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/rdaddress
add wave -noupdate -radix unsigned /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/wraddress
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/wren
add wave -noupdate -radix decimal /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/data
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/rden
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/q
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/ibuf_inst/ram_block
add wave -noupdate -divider CB_CTRL
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_clk_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rd_clk_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rst_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rd_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rd_init_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_init_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_addr_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rd_addr_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_init_done_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_window_done_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/rd_samples_done_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_init_d2
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_init_d1
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_init_done_sync
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/cb_ctrl_inst/wr_window_done_sync
add wave -noupdate -divider STREAM_INS
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/clk_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/rst_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/start_cmd_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/stop_cmd_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/sink_valid
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/sink_sop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/sink_eop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_ready
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/sink_ready
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_sop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_eop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_valid
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/rd_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/wr_init_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/rd_init_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/wr_init_done_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/wr_window_done_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/rd_samples_done_i
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/result_wr_en_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/result_ready_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/result_wr_addr_o
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/state
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/next_state
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/result_wr_addr_reg
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/s4_state_tr
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/s4_state_tr_d
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/wr_init_done_d
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/wr_window_done_d
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_valid_s
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_sop_s
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/stream_ins_inst/source_eop_s
add wave -noupdate -divider fft_64
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/clk
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/fftpts_in
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/fftpts_out
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/inverse
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/reset_n
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_eop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_error
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_imag
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_ready
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_real
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_sop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/sink_valid
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_eop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_error
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_imag
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_ready
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_real
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_sop
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/fft_64_inst/source_valid
add wave -noupdate -divider OBUF
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/rdclock
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/wrclock
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/data
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/wraddress
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/rdaddress
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/wren
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/rden
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/q
add wave -noupdate /tb_fft_hw_accelerator/DUT/fft_ctrl_inst/obuf_inst/ram_block
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {56250 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {182622 ns}
