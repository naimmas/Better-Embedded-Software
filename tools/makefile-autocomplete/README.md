# 🛠️ Makefile Target Autocompletion

A lightweight Bash script that enables **autocompletion for `make` targets**, including those defined in **included Makefiles**. This utility parses all relevant Makefiles in the current directory and offers tab completion in terminal.

## 🚀 Features

- Tab-complete targets from the `Makefile` or any `mk` file.
- Scans included `Makefiles` to support modular builds.
- Written in pure Bash — no dependencies.
- Works with both **bash** and **zsh**.

---

## 📦 Installation

1. Download the script and append it to your Bash/Zsh config:
    ```bash
    curl -s https://raw.githubusercontent.com/naimmas/Better-EmbeddedSoftware/refs/heads/main/tools/makefile_autocompleter.sh | tee -a ~/.bashrc
    ```
2. Reload your shell configuration:
    ```bash
    source ~/.bashrc
    ```
3. Enjoy it! 🎉

---

## 💡 Acknowledgments

This script was forked from Jon Smith's [Medium post](https://medium.com/@lavieenroux20/how-to-win-friends-influence-people-and-autocomplete-makefile-targets-e6cd228d856d)
I extended it to support **included `.mk` files**, making it suitable for more complex build systems.