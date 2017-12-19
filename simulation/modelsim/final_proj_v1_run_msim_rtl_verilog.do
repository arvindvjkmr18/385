transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/vram.v}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/game_over_engine.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/position_buffer.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/positionController.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/opcode_MUX.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/detect_collision.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/ai_control_system.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/addr_MUX.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/motion.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/VGA_controller.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/vga_clk_generator.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/upscaler.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/systemController.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/sprite_queue.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/sprite_engine.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/palette_LUT.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/page_controller.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/kbPS2.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/get_keypress.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/frame_buffer.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/env_engine.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/entity_file.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/engine_MUX.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/Dreg.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/detectPageFlip.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/11_reg.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/file_MUX.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/gameoverROM.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/user_control_system.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/video_comp.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/spriteROM.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/keyboard.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/envROM.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/game_over_subsystem.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/position_subsystem.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/sprite_subsystem.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/envir_subsystem.sv}
vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/system_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2 {C:/Users/ndfil/Documents/ECE385/Final_Project/final_proj_v2/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 70 ms
