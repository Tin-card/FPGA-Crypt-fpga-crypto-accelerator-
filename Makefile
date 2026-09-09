.PHONY: help test clean

help:
	@echo "FPGA Crypto Accelerator"
	@echo ""
	@echo "Available commands:"
	@echo "  make help   Show this help"
	@echo "  make test   Run Python tests"
	@echo "  make clean  Remove generated files"

test:
	python -m pytest

clean:
	rm -rf obj_dir
	rm -f *.vcd *.fst *.log