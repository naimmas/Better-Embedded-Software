.PHONY: format

FORMATTER = clang-format-19
FORMATTER_CFG := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/configs
FORMATTER_OPTIONS := --fallback-style='Mozilla' \
				--style=file:${FORMATTER_CFG}/.clang-format \
				-i

format: $(addsuffix .format,$(SOURCE_FILES))

%.format: %
	@$(FORMATTER) $(FORMATTER_OPTIONS) $<