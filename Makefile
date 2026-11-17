.PHONY: help install unit deep format lint warnings names

.DEFAULT_GOAL := help

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

GODOT ?= godot
GDUNIT4_VERSION ?= 6.2.3
GDUNIT4_URL := https://github.com/godot-gdunit-labs/gdUnit4/archive/refs/tags/v$(GDUNIT4_VERSION).tar.gz
# The same call as gdUnit4's runtest.sh, plus --headless for machines without a display.
# --remote-debug to port 0 stops a parse error from opening Godot's interactive debugger.
RUNNER := $(GODOT) --headless --path . -s -d --remote-debug tcp://127.0.0.1:0 \
	res://addons/gdUnit4/bin/GdUnitCmdTool.gd --ignoreHeadlessMode -c
UNIT := -a res://test/core -a res://test/matchers -a res://test/gdunit4 -a res://examples
REPORTS := tmp/reports
FIXTURE := $(REPORTS)/deep/report_1/results.xml
# gdformat can't keep Assertion.new(...).affirm() on its own lines, so files that use it
# (test/gdunit4, test/deep and the example suites) are linted but not format-checked.
FORMATTED := addons/gdcrest test/core test/matchers test/fakes \
	$(shell find examples -name '*.gd' ! -name '*_test.gd')

help:
	@echo "gdcrest development commands"
	@echo ""
	@echo "  make install   Download gdUnit4 $(GDUNIT4_VERSION) into addons/gdUnit4/"
	@echo "  make unit      Run the unit suites and examples, headless"
	@echo "  make deep      Run the end-to-end gdUnit4 fixture and check its JUnit XML"
	@echo "  make format    Check formatting with gdformat"
	@echo "  make lint      Lint with gdlint"
	@echo "  make warnings  Parse addons/gdcrest with every warning treated as an error"
	@echo "  make names     Fail if a gdcrest global class clashes with Godot or gdUnit4"
	@echo ""
	@echo "Set GODOT=/path/to/godot when Godot isn't on your PATH."

install:
	rm -rf addons/gdUnit4 $(REPORTS)/gdunit4
	mkdir -p $(REPORTS)/gdunit4
	curl -sSfL "$(GDUNIT4_URL)" | tar -xz -C $(REPORTS)/gdunit4 --strip-components=1
	mv $(REPORTS)/gdunit4/addons/gdUnit4 addons/gdUnit4
	chmod +x addons/gdUnit4/runtest.sh
	$(GODOT) --headless --path . --import

unit:
	$(RUNNER) $(UNIT) -rd res://$(REPORTS)/unit -rc 1

deep:
	rm -rf $(REPORTS)/deep
	$(RUNNER) -a res://test/deep -rd res://$(REPORTS)/deep -rc 1 || [ $$? -eq 100 ]
	grep -q 'tests="2" failures="1"' $(FIXTURE)
	grep -q 'FAILED: res://test/deep/fixture_test.gd:13"' $(FIXTURE)
	grep -q '^split() must keep the parts in the order they appear$$' $(FIXTURE)
	grep -q '^Expected: exactly \["idle", "run", "jump"\], in this order$$' $(FIXTURE)
	grep -q '^     but: item 1 was "jump"$$' $(FIXTURE)
	@echo "The fixture failed at line 13 with the expected message"

format:
	gdformat --check $(FORMATTED)

lint:
	gdlint addons/gdcrest examples/support
	# Test suites use test/gdlintrc, which allows more than five public methods.
	cd test && gdlint . ../examples/*_test.gd

warnings:
	$(GODOT) --headless --path . --import > /dev/null 2>&1
	@status=0; for script in $$(find addons/gdcrest -name '*.gd' | sort); do \
		problems=$$($(GODOT) --headless --path . --check-only -s "res://$$script" 2>&1 \
			| grep -E 'ERROR|WARNING' || true); \
		if [ -n "$$problems" ]; then echo "$$script"; echo "$$problems"; status=1; fi; \
	done; exit $$status

names:
	$(GODOT) --headless --path . -s res://test/global_names.gd
	@clashes=$$(comm -12 \
		<(grep -rhoE '^(@abstract )?class_name [A-Za-z0-9_]+' addons/gdcrest | awk '{print $$NF}' | sort) \
		<(grep -rhoE '^(@abstract )?class_name [A-Za-z0-9_]+' addons/gdUnit4 | awk '{print $$NF}' | sort)); \
	if [ -n "$$clashes" ]; then echo "Clashes with gdUnit4: $$clashes"; exit 1; fi
