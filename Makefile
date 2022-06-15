ROOT_DIR:=.
include ./config.mk

# Generate configuration file for port mapping between this (tester) system's peripherals (including UUT and other peripherals added in tester.mk)
portmap: $(BUILD_DEPS)
	$(SW_DIR)/python/portmap_utils.py generate_portmap $(ROOT_DIR) "$(GET_DIRS)" "../../peripheral_portmap.conf" "$(PERIPHERALS)"
	@echo Portmap template generated in peripheral_portmap.conf

#
# BUILD EMBEDDED SOFTWARE
#

fw-build: $(BUILD_DEPS)
	make -C $(FIRM_DIR) build-all

fw-clean:
	make -C $(FIRM_DIR) clean-all

#
# EMULATE ON PC
#

pc-emul-build:
	make fw-build
	make -C $(PC_DIR)

pc-emul-run: pc-emul-build
	make -C $(PC_DIR) run

pc-emul-clean: fw-clean
	make -C $(PC_DIR) clean

pc-emul-test: pc-emul-clean
	make -C $(PC_DIR) test

#
# SIMULATE RTL
#

sim-build: $(SIM_DEPS)
	make fw-build
	make -C $(SIM_DIR) build

sim-run: sim-build
	make -C $(SIM_DIR) run

sim-clean: fw-clean
	make -C $(SIM_DIR) clean

sim-test:
	make -C $(SIM_DIR) test

#
# BUILD, LOAD AND RUN ON FPGA BOARD
#

fpga-build: $(FPGA_DEPS)
	make fw-build BAUD=115200
	make -C $(BOARD_DIR) build

fpga-run: #fpga-build Remove this prerequisite temporarily because its always rebuilding the system
	make -C $(BOARD_DIR) run TEST_LOG="$(TEST_LOG)"
	make fpga-post-run

fpga-clean: fw-clean
	make -C $(BOARD_DIR) clean

fpga-test:
	make -C $(BOARD_DIR) test

fpga-post-run: $(FPGA_POST_RUN_DEPS)

#
# COMPILE DOCUMENTS
#

doc-build:
	make -C $(DOC_DIR) $(DOC).pdf

doc-clean:
	make -C $(DOC_DIR) clean

doc-test:
	make -C $(DOC_DIR) test

#
# CLEAN
#

clean: pc-emul-clean sim-clean fpga-clean doc-clean python-cache-clean $(CLEAN_DEPS)

#
# TEST ALL PLATFORMS
#

test-pc-emul: pc-emul-test

test-pc-emul-clean: pc-emul-clean

test-sim:
	make sim-test SIMULATOR=verilator
	make sim-test SIMULATOR=icarus

test-sim-clean:
	make sim-clean SIMULATOR=verilator
	make sim-clean SIMULATOR=icarus

test-fpga:
	make fpga-test BOARD=CYCLONEV-GT-DK
	make fpga-test BOARD=AES-KU040-DB-G

test-fpga-clean:
	make fpga-clean BOARD=CYCLONEV-GT-DK
	make fpga-clean BOARD=AES-KU040-DB-G

test-doc:
	make fpga-clean BOARD=CYCLONEV-GT-DK
	make fpga-clean BOARD=AES-KU040-DB-G
	make fpga-build BOARD=CYCLONEV-GT-DK
	make fpga-build BOARD=AES-KU040-DB-G
	make doc-test DOC=pb
	make doc-test DOC=presentation

test-doc-clean:
	make doc-clean DOC=pb
	make doc-clean DOC=presentation

test: test-clean test-pc-emul test-sim test-fpga test-doc

test-clean: test-pc-emul-clean test-sim-clean test-fpga-clean test-doc-clean

python-cache-clean:
	find ../.. -name "*__pycache__" -exec rm -rf {} \; -prune

debug:
	@echo $(UART_DIR)
	@echo $(CACHE_DIR)

.PHONY: fw-build fw-clean \
	pc-emul-build pc-emul-run pc-emul-clean pc-emul-test \
	sim-build sim-run sim-clean sim-test \
	fpga-build fpga-run fpga-clean fpga-test fpga-post-run\
	doc-build doc-clean doc-test \
	clean \
	test-pc-emul test-pc-emul-clean \
	test-sim test-sim-clean \
	test-fpga test-fpga-clean \
	test-doc test-doc-clean \
	test test-clean \
	portmap\
	debug
