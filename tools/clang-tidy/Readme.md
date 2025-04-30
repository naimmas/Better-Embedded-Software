# Table of Contents
1. [Purpose](#purpose)
2. [Configuration Philosophy](#configuration-philosophy)
3. [Example Directory Layout](#example-directory-layout)
4. [Variables](#variables)
5. [Targets](#targets)
6. [Notes](#important-notes)
7. [Improvements](#future-improvements)

# Purpose

This system integrates **clang-tidy** static analysis into the C based embedded project workflow with **Makefile** automation.
It provides:
- Easy execution using `make analyse TYPE=...`
- Easy integration to `make` system
- Per-category `.clang-tidy` configuration
- Dynamic addition of extra clang-tidy flags (e.g., `--fix`)
- Scalability

---
# Configuration Philosophy

The checks and options included in this system have been selected after going through the full list in clang-tidy documentation to align with the needs of **C-based embedded firmware projects**. The focus is on safety and code readability.

For **C++ projects**, many additional checks are available in Clang-Tidy that may be more appropriate. You can explore the full list [here](https://clang.llvm.org/extra/clang-tidy/checks/list.html).

In [rules document](Clang-Tidy%20Rules%20for%20Embedded%20Firmware.md), you’ll find a categorized breakdown of the checks and their options used in this project. Some checks and options have been commented out in the configuration files.  
Please review the config files and adjust them according to your own standards, as almost all options are set to their default values.

---
# Example Directory Layout

```text
project-root/
├── Makefile    (main build Makefile)
├── tools/
│	├── clang-tidy/
│	│   ├── make_analyse.mk
|	│   └── configs/
|	│       ├── bug.clang-tidy
│	│       ├── cert.clang-tidy
│	│       ├── core.clang-tidy
│	│       ├── misc.clang-tidy
│	│       ├── perf.clang-tidy
│	│       ├── read.clang-tidy
```

---
# Variables

| Variable            | Purpose                                                                                           |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| `CLANG_TIDY`        | Clang-Tidy binary name (default: `clang-tidy-19`)                                                 |
| `CLANG_TIDY_CFG`    | Absolute path to the `configs/` folder (auto-detected based on the Makefile location)             |
| `CLANG_OPTIONS`     | Common options passed to all clang-tidy runs (color, header filter, project path, etc.)           |
| `TYPES`             | List of available analysis categories (`bug`, `cert`, `core`, `misc`, `perf`, `read`)             |
| `SOURCE_FILES`      | List of `.c` and `.h` files to be analysed (should be defined in main Makefile or env)            |
| `BUILD_DIR`         | Build folder where `compile_commands.json` is located (should be defined in main Makefile or env) |
| `CLT_HEADER_FILTER` | (optional) External header exclude regex filter.                                                  |
| `CLT_FLAGS`         | (optional) Extra user clang-tidy flags (e.g., `--fix`, `--fix-errors`)                            |

---

# Targets

## `analyse`

Run clang-tidy analysis for a **single or multi category**.

```bash
make analyse TYPE=bug
# or
make analyse TYPE="bug cert read"
```

| Argument | Meaning                                                           |
| -------- | ----------------------------------------------------------------- |
| `TYPE`   | Which config to use (must match a `.clang-tidy` under `configs/`) |

Internally runs:

```bash
clang-tidy-19 --config-file=configs/bug.clang-tidy [options][source files]
```

---

## `analyse-all`

Run clang-tidy analysis for **all predefined categories** sequentially.

```bash
make analyse-all
```

- Loops over all `TYPES`

---

# Optional Usage

You can dynamically **pass extra flags** at make invocation time:

```bash
make analyse TYPE=bug CLT_FLAGS=--fix
```

---

# Important Notes

- To invoke the script from the terminal, first define the required variables, then run:
```bash
make -f make_analysis.mk analyse
```

- To integrate it to a main Makefile, define the required variables, then include `make_analyse.mk`
```Makefile
include path/to/make_analyse.mk
```

- This script uses Unix-style syntax.
- The `build` step must be completed first to ensure `compile_commands.json` exists.
- Make sure each `TYPE` has a corresponding `.clang-tidy` config file.

---

# Future Improvements

- Parallelize process for faster execution. (I think run-clang-tidy py script supports it, but I didn't dive into it)
- Export an analyze report.
