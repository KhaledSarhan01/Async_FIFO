vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.tb_FIFO
add wave -position insertpoint  \
sim:/tb_FIFO/tb_W_CLK \
sim:/tb_FIFO/tb_W_RST \
sim:/tb_FIFO/tb_W_INC \
sim:/tb_FIFO/tb_WR_DATA \
sim:/tb_FIFO/tb_FULL \
sim:/tb_FIFO/tb_R_CLK \
sim:/tb_FIFO/tb_R_RST \
sim:/tb_FIFO/tb_R_INC \
sim:/tb_FIFO/tb_RD_DATA \
sim:/tb_FIFO/tb_EMPTY 
add wave -position insertpoint  \
sim:/tb_FIFO/DUT/FIFO_MEMORY/MEM \
sim:/tb_FIFO/DUT/sync_rd_ptr \
sim:/tb_FIFO/DUT/sync_wr_ptr
add wave -position insertpoint  \
sim:/tb_FIFO/DUT/Wr_ADDR \
sim:/tb_FIFO/DUT/Rd_ADDR
add wave -position insertpoint  \
sim:/tb_FIFO/DUT/FIFO_MEMORY/g_clk
run -all
