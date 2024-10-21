#!/bin/bash

LANGUAGE=""

# Function to display a header for the setup script
show_header() {
    clear
    echo "         _              _             _____           _                                _   ";
    echo "     _  /\ \          /\ \           |  ___|         (_)                              | |  ";
    echo "    /\_\  \ \        /  \ \          | |__ _ ____   ___ _ __ ___  _ __ ___   ___ _ __ | |_ ";
    echo "   / / / \ \ \      / /\ \ \         |  __| '_ \ \ / / | '__/ _ \| '_ \` _ \ / _ \ '_ \| __|";
    echo "  / / /   \ \ \     \/_/\ \ \        | |__| | | \ V /| | | | (_) | | | | | |  __/ | | | |_ ";
    echo "  \ \ \____\ \ \        / / /        \____/_| |_|\_/ |_|_|  \___/|_| |_| |_|\___|_| |_|\__|";
    echo "   \ \________\ \      / / /                                    _____      _               ";
    echo "    \/________/\ \    / / /  _                                 /  ___|    | |              ";
    echo "              \ \ \  / / /_/\_\                                \ \`--.  ___| |_ _   _ _ __  ";
    echo "               \ \_\/ /_____/ /                                  \`--. \/ _ \ __| | | | '_ \ ";
    echo "                \/_/\________/                                  /\__/ /  __/ |_| |_| | |_) | ";
    echo "                                                                \____/ \___|\__|\__,_| .__/ ";
    echo "                                                                                     | |    ";
    echo "by cvalim-d                                                                          |_|    ";

    echo
}

# Function to choose the language for the script
choose_language() {
    echo "Choose your language / Escolha seu idioma:"
    echo "1) English"
    echo "2) Português"
    read -p "Enter the number corresponding to your language: " language_choice

    case $language_choice in
        1)
            LANGUAGE="EN"  # Set language to English
            ;;
        2)
            LANGUAGE="PT"  # Set language to Portuguese
            ;;
        *)
            echo "Invalid option. Defaulting to English."  # Handle invalid input
            LANGUAGE="EN"
            ;;
    esac
}

# Function to display messages in the chosen language
show_message() {
    if [ "$LANGUAGE" == "EN" ]; then
        echo "$1"  # Display English message
    else
        echo "$2"  # Display Portuguese message
    fi
}

# Function to configure Vim settings
configure_vim() {
    show_message "Configuring Vim..." "Configurando Vim..."
    cat <<EOF > ~/.vimrc
" Initialize Vim-Plug
call plug#begin()

" Add the c_formatter_42 plugin
Plug 'cacharle/c_formatter_42.vim'

" Initialize Vim-Plug
call plug#end()

" Set c_formatter_42 as the default formatter
let g:c_formatter_42_set_equalprg=1

" Disable format on save (set to 1 to enable it)
let g:c_formatter_42_format_on_save=0

" Setting line numbers on the left side of the editor
set number

" Enabling mouse support inside Vim
set mouse=a

" Mapping F2 to format the code using the c_formatter_42 plugin
nnoremap <F2> :CFormatter42<CR>

" Mapping F4 to run Norminette to check the code
nnoremap <F4> :w<CR>:!norminette -R CheckForbiddenSourceHeader %<CR>

" Mapping F5 to compile and run the code using all the flags
nnoremap <F5> :w<CR>:!cc -Wall -Wextra -Werror % -o a.out && ./a.out<CR>
EOF
}

# Function to configure Zsh settings
configure_zsh() {
    show_message "Configuring Zsh..." "Configurando Zsh..."
    cp path/to/your/.zshrc ~/.zshrc  # Copy Zsh configuration file

    # Configuration of PATH
    export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

    # Path for the Oh My Zsh installation
    export ZSH="$HOME/.oh-my-zsh"

    # Language and locale settings
    export LANG=pt_BR.UTF-8
    export LC_ALL=pt_BR.UTF-8
    export LC_MESSAGES=pt_BR.UTF-8

    # Define the theme for Oh My Zsh
    ZSH_THEME="suvash"

    # Enable automatic correction of commands
    ENABLE_CORRECTION="true"

    # Plugins to be loaded (located in $ZSH/plugins/)
    # Avoid loading too many plugins to prevent slowing down the shell
    plugins=(
    zsh-autosuggestions      # Suggests commands based on command history
    colored-man-pages        # Adds color to man pages for better readability
    colorize                 # Colors the output of commands
    )

    # Load Oh My Zsh
    source $ZSH/oh-my-zsh.sh

    # Configure less for colored terminal output
    less_termcap[md]="${fg_bold[blue]}"

    # Autocompletion settings (added by compinstall)
    zstyle ':completion:*' completer _complete _ignored
    zstyle :compinstall filename '/home/$USER/.zshrc'

    # Initialize the completion system
    autoload -Uz compinit
    compinit

    # Load zsh-syntax-highlighting if the file exists
    # Adjust the path according to the plugin installation
    if [ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi

    # Add custom bin directory to PATH
    PATH=~/.console-ninja/.bin:$PATH

    source ~/.zshrc  # Reload Zsh configuration
}

# Function to configure VS Code settings
configure_vscode() {
    show_message "Configuring VSCode..." "Configurando VSCode..."
    # Install commonly used extensions
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.cpptools-extension-pack
    code --install-extension DoKca.42-ft-count-line
    code --install-extension kube.42header
    # Add specific configurations for VS Code
    cat <<EOF > ~/Library/Application\ Support/Code/User/settings.json
{
    "editor.tabSize": 4,
    "editor.formatOnSave": true,
    "files.autoSave": "afterDelay",
    "[c]": {
        "editor.defaultFormatter": "keyhr.42-c-format"
    }
    {
        "42header.username": "$USER",
        "42header.email": "$user_email"
    }
}
EOF
}

# Function to configure the MAIL environment variable based on user input
configure_mail_variable() {
    if [ "$LANGUAGE" == "EN" ]; then
        read -p "Enter your 42 email (e.g., user@42lisboa.com): " user_email  # Prompt for email
    else
        read -p "Digite seu email da 42 (e.g., user@42lisboa.com): " user_email  # Prompt in Portuguese
    fi

    # Validate the email format
    if [[ "$user_email" =~ ^[a-zA-Z0-9._%+-]+@42[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        export MAIL="$user_email"  # Set the MAIL environment variable
        show_message "MAIL set to: $MAIL" "MAIL configurado como: $MAIL"
        echo "export MAIL=\"$user_email\"" >> ~/.zshrc  # Append to Zsh configuration
    else
        show_message "Invalid email. Please try again." "Email inválido. Por favor, tente novamente."
        configure_mail_variable  # Retry if invalid email
    fi
}

# Script execution starts here
show_header  # Display the header
choose_language  # Choose the language for the setup
show_message "Welcome! This script will set up your 42 development environment." "Bem-vindo! Este script irá configurar seu ambiente de desenvolvimento 42."

install_dependencies  # Function to install any required dependencies
configure_vim  # Function to configure Vim
configure_zsh  # Function to configure Zsh
configure_vscode  # Function to configure VS Code
configure_mail_variable  # Function to configure the MAIL variable

show_message "Setup complete!" "Configurações concluídas!"  # Completion message
