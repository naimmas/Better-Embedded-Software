.PHONY: analyse analyse-all


CLANG_TIDY = clang-tidy-19
CLANG_TIDY_CFG := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/configs
CLANG_OPTIONS := --use-color\
				--header-filter=.* \
				--exclude-header-filter=${CLT_HEADER_FILTER} \
				-p $(BUILD_DIR)/compile_commands.json \
				$(CLT_FLAGS) \
				$(SOURCE_FILES) 2> /dev/null

TYPES = bug cert core misc perf read

# Dynamic analysis target
analyse:
# no user input
ifndef TYPE
	$(error Please run as 'make analyse TYPE=bug')
endif
ifneq ($(TYPE),$(filter $(TYPE),$(TYPES)))
	$(error Invalid type: $(TYPE). Valid types are: $(TYPES))
endif
# only one input
ifneq ($(words $(TYPE)),1)
	@for word in $(TYPE); do \
		echo "\033[1;33mRunning Analysis for $$word...\033[0m"; \
		$(CLANG_TIDY) --config-file=$(CLANG_TIDY_CFG)/$$word.clang-tidy $(CLANG_OPTIONS); \
	done
# multi input
else
	@echo "\033[1;36mRunning Analysis for $(TYPE)...\033[0m"
	@$(CLANG_TIDY) --config-file=$(CLANG_TIDY_CFG)/$(TYPE).clang-tidy $(CLANG_OPTIONS)
	@echo "\033[1;32mAnalysis for $(TYPE) completed.\033[0m"
endif

analyse-all:
	@for type in $(TYPES); do \
		echo "\033[1;33mRunning Analysis for $$type...\033[0m"; \
		$(CLANG_TIDY) --config-file=$(CLANG_TIDY_CFG)/$$type.clang-tidy $(CLANG_OPTIONS); \
	done
	@echo "\033[1;32mAnalysis for all types completed.\033[0m"