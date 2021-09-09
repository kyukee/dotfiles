# will write a list of all installed extensions (enabled or not)
code --list-extensions > vscode-extensions-list-install.sh

# code --list-extensions | xargs -L 1 echo code --install-extension > vscode-extensions-list-install.sh
