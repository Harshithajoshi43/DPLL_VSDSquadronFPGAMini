# Project Configuration
TOP := dpll_top
DEVICE := up5k
PACKAGE := sg48
PCF := constraints.pcf
SRC := dpll_top.v
TB := dpll_tb.v
SIM_LIB := sim_lib.v

# Toolchain Paths
YOSYS := yosys
NEXTPNR := nextpnr-ice40
ICEPACK := icepack
ICEPROG := iceprog
IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave

# Build Targets
all: clean build flash

build: build/$(TOP).bin

build/$(TOP).bin: build/$(TOP).asc
	@echo "Packing bitstream..."
	$(ICEPACK) $< $@

build/$(TOP).asc: build/$(TOP).json
	@echo "Place and route..."
	$(NEXTPNR) --$(DEVICE) --package $(PACKAGE) --json $< \
		--pcf $(PCF) --asc $@ --log build/nextpnr.log

build/$(TOP).json: $(SRC)
	@echo "Synthesizing..."
	@mkdir -p build
	$(YOSYS) -p "synth_ice40 -top $(TOP) -json $@" $^

flash: build/$(TOP).bin
	@echo "Flashing to board..."
	sudo $(ICEPROG) $<

sim: sim/$(TOP).vcd

sim/$(TOP).vcd: sim/$(TOP).vvp
	@echo "Running simulation..."
	$(VVP) $<

sim/$(TOP).vvp: $(SRC) $(TB) $(SIM_LIB)
	@echo "Compiling testbench..."
	@mkdir -p sim
	$(IVERILOG) -o $@ -s dpll_tb $^ -D SIM

view: sim/$(TOP).vcd
	@echo "Opening GTKWave..."
	$(GTKWAVE) $<

clean:
	@echo "Cleaning build files..."
	rm -rf build/* sim/*

.PHONY: all build flash sim view clean
