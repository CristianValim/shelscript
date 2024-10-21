#!/bin/bash

LANGUAGE=""
VSCODE_DIR="$HOME/Documents/.vscode"

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
		show_message "1) All configs (Vim, VSCode and Terminal (Zsh))" "1) Todas as configurações (Recomendado)"
		show_message "2) Vim configs" "2) Configurações do Vim"
		show_message "3) Terminal (Zsh) configs" "3) Configurações do Terminal (Zsh)"
		show_message "4) VSCode configs" "4) Configurações do VSCode"
		show_message "5) Reset all configurations" "5) Resetar todas as configurações"
		show_message "6) Exit" "6) Sair"

		read -p "$(show_message "Enter the number corresponding to your choice: " "Digite o número correspondente à sua escolha: ")" config_choice

		case $config_choice in
		1)
			configure_vim
			clear # Clear after configuring Vim
			configure_zsh
			clear # Clear after configuring Zsh
			configure_mail_variable
			clear # Clear after configuring MAIL variable
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

	# Set the MAIL environment variable directly without validation
	export MAIL="$user_email"
	show_message "MAIL set to: $MAIL" "MAIL configurado como: $MAIL"
	echo "export MAIL=\"$user_email\"" >>~/.zshrc
}

configure_zsh() {
	# Check if Zsh is installed
	if ! command -v zsh &>/dev/null; then
		show_message "Zsh is not installed. Please install Zsh on your system." "Zsh não está instalado. Por favor, instale o Zsh no seu sistema."
		return 1
	fi

	show_message "Configuring Zsh..." "Configurando Zsh..."

	# Configuration of PATH
	export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

	# Enable automatic correction of commands
	ENABLE_CORRECTION="true"

	# Plugins to be loaded (located in $ZSH/plugins/)
	plugins=(
		zsh-autosuggestions # Suggests commands based on command history
		colored-man-pages   # Adds color to man pages for better readability
		colorize            # Colors the output of commands
	)

	# Load zsh-syntax-highlighting if the file exists
	if [ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
		source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	fi

	# Define aliases
	alias norm='norminette -R CheckForbiddenSourceHeaderflag'
	alias comp='cc -Wall -Wextra -Werror'

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
EOF
}

configure_vscode() {
	# Check if the VSCode directory exists
	if [ ! -d "$VSCODE_DIR" ]; then
		mkdir -p "$VSCODE_DIR"
		show_message "Created VSCode directory at $VSCODE_DIR" "Diretório do VSCode criado em $VSCODE_DIR"
	fi

	show_message "Configuring VSCode..." "Configurando o VSCode..."

	cat <<EOF >"$VSCODE_DIR/settings.json"
{
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "files.autoSave": "onWindowChange"
}
EOF
}

reset_configurations() {
	show_message "Resetting all configurations..." "Resetando todas as configurações..."

	rm -f ~/.zshrc ~/.vimrc "$VSCODE_DIR/settings.json"
	show_message "All configurations have been reset." "Todas as configurações foram resetadas."
}

# Main script execution
show_header
choose_language
choose_configurations
