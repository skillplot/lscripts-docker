gh repo create my-project --private --source=. --remote=origin --push

sudo apt-get install wget gpg
wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
sudo install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
rm -f windsurf-stable.gpg

sudo apt install apt-transport-https
sudo apt update

sudo apt install windsurf


# windsurf --install-extension akamud.vscode-theme-onedark
# windsurf --install-extension jprestidge.theme-material-theme
# windsurf --install-extension jdinhlife.gruvbox

# "workbench.colorTheme": "Sublime Mariana"



# "workbench.colorTheme": "Default Dark+",