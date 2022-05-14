ROOT_DIR:=.
include ./config.mk

# Generate configuration file for port mapping between the Tester, SUT and external interface of the Top System
tester-portmap:
ifeq ($(TESTING_CORE),)
	$(SW_DIR)/python/tester_utils.py generate_portmap $(ROOT_DIR) "$(GET_DIRS)" "peripheral_portmap.conf" "$(PERIPHERALS)" "$(TESTER_PERIPHERALS)"
else
	$(SW_DIR)/python/tester_utils.py generate_portmap $(ROOT_DIR) "$(GET_DIRS)" "../../peripheral_portmap.conf" "" "$(PERIPHERALS)"
	@echo Portmap template generated in peripheral_portmap.conf
endif

#
# BUILD EMBEDDED SOFTWARE
#

fw-build:
	make -C $(FIRM_DIR) build-all

fw-clean:
	make -C $(FIRM_DIR) clean-all

#
# EMULATE ON PC
#

pc-emul-build:
	make fw-build BAUD=5000000
	make -C $(PC_DIR) build

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
	make fw-build BAUD=5000000
	make -C $(SIM_DIR) build

sim-run: sim-build
	make -C $(SIM_DIR) run

sim-clean: fw-clean
	make -C $(SIM_DIR) clean

sim-test:
	make -C $(SIM_DIR) test


#Simulate SUT with Tester system
tester-sim-build:
	make sim-build TESTER_ENABLED=1

tester-sim-run:
	make sim-run TESTER_ENABLED=1

#
# BUILD, LOAD AND RUN ON FPGA BOARD
#

fpga-build:
	make fw-build
	make -C $(BOARD_DIR) build

fpga-run: fpga-build
	make -C $(BOARD_DIR) run TEST_LOG="$(TEST_LOG)"

fpga-clean: fw-clean
	make -C $(BOARD_DIR) clean

fpga-test:
	make -C $(BOARD_DIR) test

#targets for SUT with Tester system
tester-fpga-build:
	make fpga-build TESTER_ENABLED=1

tester-fpga-run:
	make fpga-run TESTER_ENABLED=1

#
# SYNTHESIZE AND SIMULATE ASIC
#

asic-synth:
	make fw-build
	make -C $(ASIC_DIR) synth

asic-sim-post-synth:
	make -C $(ASIC_DIR) all TEST_LOG="$(TEST_LOG)"

asic-clean:
	make -C $(ASIC_DIR) clean-all

asic-test:
	make -C $(ASIC_DIR) test

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

test-asic:
	make asic-test ASIC_NODE=umc130
	make asic-test ASIC_NODE=skywater

test-asic-clean:
	make asic-clean ASIC_NODE=umc130
	make asic-clean ASIC_NODE=skywater

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
	find . -name "*__pycache__" -exec rm -rf {} \; -prune

debug:
	@echo $(UART_DIR)
	@echo $(CACHE_DIR)

.PHONY: fw-build fw-clean \
	pc-emul-build pc-emul-run pc-emul-clean pc-emul-test \
	sim-build sim-run sim-clean sim-test \
	tester-sim-build tester-sim-run\
	fpga-build fpga-run fpga-clean fpga-test \
	tester-fpga-build tester-fpga-run\
	asic-synth asic-sim-post-synth asic-test \
	doc-build doc-clean doc-test \
	clean \
	test-pc-emul test-pc-emul-clean \
	test-sim test-sim-clean \
	test-fpga test-fpga-clean \
	test-asic test-asic-clean \
	test-doc test-doc-clean \
	test test-clean \
	tester-portmap\
	debug
