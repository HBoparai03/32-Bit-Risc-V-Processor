# Run from the MSYS2 UCRT64 shell (or a terminal with C:\msys64\ucrt64\bin
# and C:\msys64\usr\bin on PATH).
#
#   make sim  TOP=tb_counter   - compile + run with Icarus Verilog (fast)
#   make vsim TOP=tb_counter   - compile + run with Verilator (stricter SV)
#   make lint                  - Verilator lint of everything in rtl/
#   make wave TOP=tb_counter   - open the VCD in GTKWave
#   make clean

TOP     ?= tb_counter
RTL     := $(wildcard rtl/*.sv)
TB      := tb/$(TOP).sv
SIM_DIR := build
# GNU make (used by Verilator) can't build in paths containing spaces, so
# Verilator's generated C++ goes to a space-free directory instead.
VL_DIR  ?= /tmp/rv32i_verilator
# MSYS2's GCC 16.2 fails to link C++ built with -Os (Verilator's default),
# hence the OPT_* overrides in the vsim recipe.

.PHONY: sim vsim lint wave clean

sim: $(SIM_DIR)
	iverilog -g2012 -Wall -I rtl -s $(TOP) -o $(SIM_DIR)/$(TOP).vvp $(RTL) $(TB)
	vvp -n $(SIM_DIR)/$(TOP).vvp

vsim: $(SIM_DIR)
	mkdir -p $(VL_DIR)/obj_$(TOP)
	verilator --binary --timing -Wall -Wno-fatal -Irtl --top-module $(TOP) \
		-MAKEFLAGS "OPT_FAST=-O2 OPT_SLOW=-O1 OPT_GLOBAL=-O2" \
		--Mdir $(VL_DIR)/obj_$(TOP) $(RTL) $(TB)
	$(VL_DIR)/obj_$(TOP)/V$(TOP)

lint:
	verilator --lint-only -Wall -Irtl $(RTL)

wave:
	gtkwave $(SIM_DIR)/$(TOP).vcd &

$(SIM_DIR):
	mkdir -p $(SIM_DIR)

clean:
	rm -rf $(SIM_DIR) $(VL_DIR)
