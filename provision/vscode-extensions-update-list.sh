# will write a list of all installed extensions (enabled or not)
code --list-extensions | xargs -L 1 echo code --install-extension > provision/vscode-extensions-install-all.sh
