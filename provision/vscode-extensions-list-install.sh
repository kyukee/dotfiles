#!/bin/bash
awk '{print $1}' vscode-extensions-list.txt | xargs code --install-extension
