# Emacs setup
Shell script to setup emacs on Oracle linux with:
- Golang tools and lsp integration
- Tools for more fancy navigation and file handling
- vterm as terminal emulator with multi-vterm for multiple terminals in emacs
- Solarized theme adapted to the terminal
- etc

# WSL Installation
## Enable WSL prerequisites
In Windows terminal run:
- dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
- dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Sometimes this does not work right away and you need to restart your machine or rerun the above commands twice

## Install WSL with Oracle Linux 9.1
-  wsl --install -d OracleLinux_9_1

# Emacs installation on WSL Oracle Linux
Create a user account
Copy the shell file to the home catalogue
- run chmod +x *.sh
- run ./setup_emacs.sh
