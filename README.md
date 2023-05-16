# emacs
My main emacs file

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
