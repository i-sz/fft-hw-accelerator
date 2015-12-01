onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {input buffer}
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/rdclock
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/wrclock
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/data
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/wraddress
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/rdaddress
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/wren
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/rden
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/q
add wave -noupdate /tb_fft_controller/DUT/ibuf_inst/ram_block
add wave -noupdate -divider wr_ptr
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_clk_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/rst_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_addr_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_window_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_addr_reg
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_window_reg
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_addr_s
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_done_s
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_done_fe_d
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_done_fe
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/wr_init_done_d
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_ptr_inst/window_cnt
add wave -noupdate -divider rd_ptr
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_clk_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rst_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_init_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_addr_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_samples_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_ptr_reg
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_ptr_next
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_addr_reg
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/rd_samples_done_s
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_ptr_inst/window_cnt
add wave -noupdate -divider {cb_ctrl cdc}
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_clk_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_clk_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rst_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_init_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_init_i
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_addr_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_addr_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_init_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_window_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/rd_samples_done_o
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_init_d2
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_init_d1
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_init_done_sync
add wave -noupdate /tb_fft_controller/DUT/cb_ctrl_inst/wr_window_done_sync
add wave -noupdate -divider stream_ins
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/clk_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/rst_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/start_cmd_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/stop_cmd_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/sink_valid
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/sink_sop
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/sink_eop
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_ready
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/sink_ready
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_sop
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_eop
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_valid
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/rd_o
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/wr_init_o
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/rd_init_o
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/wr_init_done_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/wr_window_done_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/rd_samples_done_i
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/result_wr_en_o
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/result_wr_addr_o
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/state
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/next_state
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/result_wr_addr_reg
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/wr_init_done_d
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/wr_window_done_d
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_valid_s
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_sop_s
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/source_eop_s
add wave -noupdate -divider fft_64
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_eop
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/clk
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/fftpts_in
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/fftpts_out
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/inverse
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/reset_n
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_eop
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_error
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_imag
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_ready
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_real
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_sop
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/sink_valid
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_eop
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_error
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_imag
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_ready
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_real
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_sop
add wave -noupdate /tb_fft_controller/DUT/fft_64_inst/source_valid
add wave -noupdate -divider output_buffer
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/rdclock
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/wrclock
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/data
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/wren
add wave -noupdate /tb_fft_controller/DUT/stream_ins_inst/s4_state_tr
add wave -noupdate -radix unsigned /tb_fft_controller/DUT/output_buffer_inst/wraddress
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/rdaddress
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/rden
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/q
add wave -noupdate /tb_fft_controller/DUT/output_buffer_inst/ram_block
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {854831 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {856680 ns} {856796 ns}
