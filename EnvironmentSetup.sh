#!/bin/bash

LANGUAGE="EN"
VSCODE_DIR="~/.var/app/com.visualstudio.code/config/Code/User"

# Function to display a header for the setup script
show_header() {
	clear
	echo "         _              _      _____           _                                      _   "
	echo "     _  /\ \          /\ \    |  ___|         (_)                                    | |  "
	echo "    /\_\  \ \        /  \ \   | |__ _ ____   ___ _ __ ___  _ __  _ __ ___   ___ _ __ | |_ "
	echo "   / / / \ \ \      / /\ \ \  |  __| '_ \ \ / / | '__/ _ \| '_ \| '_ \` _ \ / _ \ '_ \| __|"
	echo "  / / /   \ \ \     \/_/\ \ \ | |__| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_ "
	echo "  \ \ \____\ \ \        / / / \____/_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|"
	echo "   \ \________\ \      / / /                                  _____      _               "
	echo "    \/________/\ \    / / /  _                               /  ___|    | |              "
	echo "              \ \ \  / / /_/\_\                              \ \`--.  ___| |_ _   _ _ __  "
	echo "               \ \_\/ /_____/ /                                \`--. \/ _ \ __| | | | '_ \ "
	echo "                \/_/\________/                                /\__/ /  __/ |_| |_| | |_) | "
	echo "                                                              \____/ \___|\__|\__,_| .__/ "
	echo "                                                                                   | |    "
	echo "by cvalim-d                                                                        |_|    "
	echo
}

# Function to choose the language for the script
choose_language() {
	local language_choice
	echo "Choose your language / Escolha seu idioma:"
	echo "1) English"
	echo "2) Português"

	read -p "Type the corresponding number and press Enter / Digite o numero correspondente e aperte Enter: " language_choice

	case $language_choice in
	1) LANGUAGE="EN" ;; # Set language to English
	2) LANGUAGE="PT" ;; # Set language to Portuguese
	*)
		echo "Invalid option. Defaulting to English." # Handle invalid input
		LANGUAGE="EN"
		;;
	esac

	clear
}

# Function to display messages in the chosen language
show_message() {
	if [ "$LANGUAGE" == "EN" ]; then
		echo "$1" # Display English message
	else
		echo "$2" # Display Portuguese message
	fi
}

# Function to display configuration options
choose_configurations() {
	while true; do
		show_header # Show header at the beginning of this loop
		show_message "Choose the configurations to apply or to reset the configurations:" "Escolha as configurações a serem aplicadas ou resetar os arquivos de configurações:"
		show_message "1) All configs (Vim, VSCode and Terminal (Zsh))" "1) Todas as configurações (Vim, VSCode e Terminal (Zsh))"
		show_message "2) Vim configs" "2) Configurações do Vim"
		show_message "3) Terminal (Zsh) configs" "3) Configurações do Terminal (Zsh)"
		show_message "4) VSCode configs" "4) Configurações do VSCode"
		show_message "5) Reset all configurations" "5) Resetar todas as configurações"
		show_message "6) Exit" "6) Sair"

		read -p "$(show_message "Enter the number corresponding to your choice: " "Digite o número correspondente à sua escolha: ")" config_choice

		case $config_choice in
		1)
			configure_mail_variable
			clear # Clear after configuring MAIL variable
			configure_zsh
			clear # Clear after configuring Zsh
			configure_vim
			clear # Clear after configuring Vim
			configure_vscode
			clear # Clear after configuring VSCode
			;;
		2)
			configure_vim
			clear # Clear after configuring Vim
			;;
		3)
			configure_zsh
			clear # Clear after configuring Zsh
			;;
		4)
			configure_vscode
			clear # Clear after configuring VSCode
			;;
		5)
			reset_configurations
			clear # Clear after resetting configurations
			;;
		6)
			show_message "Exiting the setup." "Saindo da configuração."
			exit 0
			;;
		*)
			show_message "Invalid option. Please choose a valid configuration." "Opção inválida. Por favor, escolha uma configuração válida."
			;;
		esac
	done
}

# Function to configure the MAIL environment variable based on user input
configure_mail_variable() {
	local user_email

	if [ "$LANGUAGE" == "EN" ]; then
		read -p "Enter your 42 email (e.g., user@42student.lisboa.com): " user_email
	else
		read -p "Digite seu email da 42 (e.g., user@42student.lisboa.com): " user_email
	fi

	if ! grep -q "export MAIL=" ~/.zshrc; then
		echo "export MAIL=\"$user_email\"" >>~/.zshrc
	fi

	show_message "MAIL set to: $MAIL" "MAIL configurado como: $MAIL"
	echo "export MAIL=\"$user_email\"" >>~/.zshrc
}

configure_zsh() {
	show_message "Configuring Zsh..." "Configurando Zsh..."

	# Configuration of PATH
	export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

	# Enable automatic correction of commands
	ENABLE_CORRECTION="true"

	# Plugins to be loaded (located in $ZSH/plugins/)
	plugins=(
		zsh-autosuggestions # Suggests commands based on command history
	)

	# Define aliases
	alias norm='norminette -R CheckForbiddenSourceHeaderflag'
	alias comp='cc -Wall -Wextra -Werror'
	alias glf='git ls-files'
	alias gpush='git add . && git commit -m "$(basename "$PWD")" && git push'

	# Reload Zsh configuration
	if [ -f "$HOME/.zshrc" ]; then
		source "$HOME/.zshrc"
	else
		show_message ".zshrc not found. Please create one or check the installation." ".zshrc não encontrado. Por favor, crie um ou verifique a instalação."
	fi
}

configure_vim() {
	# Check if Vim is installed
	if ! command -v vim &>/dev/null; then
		show_message "Vim is not installed. Install it and try again" "Vim não está instalado. Instale e tente novamente"
		return 1 # Exit the function if critical dependency is missing
	fi

	show_message "Configuring Vim..." "Configurando o Vim..."

	# Vim configuration logic here
	cat <<EOF >~/.vimrc
" Initialize Vim-Plug
call plug#begin()

" Add the c_formatter_42 plugin
Plug 'cacharle/c_formatter_42.vim'

" Initialize Vim-Plug
call plug#end()

" General settings
syntax on
set number
set tabstop=4
set shiftwidth=4
set expandtab

" Macros
"
nnoremap <F2> :Stdheader<CR>
nnoremap <F3> :Format<CR>
nnoremap <F4> :!norminette %<.c<CR>
nnoremap <F5> :!cc -Wall -Wextra -Werror % -o %<.out && ./%<.out<CR>

EOF
}

configure_vscode() {
	show_message "Configuring VSCode..." "Configurando o VSCode..."

	cat <<EOF >"$VSCODE_DIR/settings.json"
{
	"breadcrumbs.enabled": false,
	"editor.tabSize": 4,
	"editor.insertSpaces": false,
	"editor.renderWhitespace": "all",
	"files.trimTrailingWhitespace": true,
	"files.autoSave": "afterDelay",
	"terminal.integrated.env.linux": {
	  "PATH": "$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"
  },
	"terminal.integrated.env.osx": {
	  "PATH": "/usr/bin:$PATH"  },
	"editor.formatOnSave": true,
	"[c]": {
	  "editor.defaultFormatter": "keyhr.42-c-format"
	  },
	"terminal.integrated.defaultProfile.linux": "zsh",
	"42header.username": "$USER",
	"42header.email": "$MAIL",
  "terminal.integrated.profiles.linux": {
	  "bash": {
		  "path": "bash",
		  "icon": "terminal-bash"
	  },
	  "zsh": {
		  "path": "/home/$USER/zsh/bin/zsh"
	  },
	  "fish": {
		  "path": "fish"
	  },
	  "tmux": {
		  "path": "tmux",
		  "icon": "terminal-tmux"
	  },
	  "pwsh": {
		  "path": "pwsh",
		  "icon": "terminal-powershell"
	  },
	  "sh": {
		  "path": "/bin/sh"
	  }
  },
  "code-runner.executorMap": {
		  "cpp": "/usr/bin/g++ -o $fileNameWithoutExt $fileName && ./$fileNameWithoutExt",
		  "c": "/usr/bin/cc -o $fileNameWithoutExt $fileName && ./$fileNameWithoutExt"
	  },
	  "code-runner.runInTerminal": true,
	  "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools",
	  "C_Cpp.default.intelliSenseMode": "gcc-x64",
	  "C_Cpp.default.compilerPath": "/usr/bin/g++",
	  "C_Cpp.default.compileCommands": "cc",
	  "C_Cpp.default.compilerArgs": [
		  "-Wall -Wextra -Werror"
	  ],
	  "cmake.showOptionsMovedNotification": false,
	  "[cpp]": {
		  "editor.defaultFormatter": "keyhr.42-c-format"
	  }
  }

EOF
}

reset_configurations() {
	show_message "Resetting all configurations..." "Resetando todas as configurações..."

	[ -f ~/.zshrc ] && rm ~/.zshrc
	[ -f ~/.vimrc ] && rm ~/.vimrc
	[ -d "$VSCODE_DIR" ] && rm -f "$VSCODE_DIR/settings.json"
	show_message "All configurations have been reset." "Todas as configurações foram resetadas."
}

# Main script execution
show_header
choose_language
choose_configurations
