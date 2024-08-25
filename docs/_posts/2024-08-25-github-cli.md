---
layout: post
title:  "Github configuration and CLI setup for Multiple user"
date:   2024-08-25 15:45:00 +0530
categories: github-setup
---


## Overview

github provide github cli (gh) client to automate certain process that generally require to login to GUI or to use the Github API explicitly. There are more then one ways to interact and it is the individuals preference.

I found `GH_TOKEN` is convenient way to enable working across different github accounts, as currently there is lack of option to select different profiles related to like work, opensource etc and expects a single username to work across all user accounts. Additionally, other challenges include working across different machine, access token management for different accounts in secured way



## Installations

### Using `lscripts-docker` modules

```bash
## Using lsd-install module
lsd-install.githubcli-apt

## Or, using lsd-github module
lsd-github-cli.install
```


### Using direct installation script

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```


**TIP**: This uses new and secured mechanism to store the gpg keys. You may have deprecated warning when you run `sudo apt update`, may be from other package keys example:

```bash
W: https://download.sublimetext.com/apt/stable/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.
```



## Configure and Login from CLI

1. Create directory to store tokens
    ```bash
    mkdir -p $HOME/.cred
    ```
2. Generate the `access-token` from github `Developer Settings`. You can see and manage your tokens directly on GitHub under `Settings > Developer settings > Personal access tokens`. Copy the token and paste it in the file `$HOME/.cred/github.username`, where replace `username` with actual name of the user on the github
    ```bash
    vi $HOME/.cred/github.username
    ```
3. Close all the existing terminal and open the new terminal
4. To login to the given username. You would need to login whenever you open a new terminal for security purpose as it uses `GH_TOKEN` environment variable login mechanism with github client (gh) to login to a specific user account.
    ```bash
    lsd-github-cli.login username
    ```
5. You check for login status anytime
    ```bash
    gh auth status
    ```

## Maintaining Github Tokens


**Security Considerations**

* **Target Directory Permissions**: Set to `700` to restrict access to the directory containing the credentials.
* **Token File Permissions**: Set to `600` to restrict access to the specific token file.
* **Parent Directory Permissions (Optional)**: Consider setting permissions on the parent directory of the symlink (`$HOME`) to `700` to prevent unauthorized access to the symlink.


```bash
sudo chmod 700 $HOME
sudo chmod 700 $HOME/.cred
sudo chmod 600 $HOME/.cred/*
```

## Avoid `credential store` to persist github tokens

This mechanism can be used along side github client (gh) or independently to work across different github user accounts.

Put the following snippet in the `~/.bashrc` to create the required alias to push, pull and clone the github repositories; Replace `username` with actual name of the user on the github and adjust the alias as per your requirement.

```bash
alias gpush-username="git push https://username:$(cat ~/.cred/github.username)@github.com/username/$(basename $PWD).git"
alias gpull-username="git pull https://username:$(cat ~/.cred/github.username)@github.com/username/$(basename $PWD).git"
alias gclone-username="git clone https://username:$(cat ~/.cred/github.username)@github.com/$@"
```


## Additional Considerations

* Do not expose your email ID from the git commit logs and enable this in `settings -> email` to hide the primary email  id on commit, and use the alternative email ID 
* Each repo should be configured to individual user and email rather the global, that is avoid `--global` flag when setting the repository username and email id. This is needed to commit the code and mandatory to work across different git users on the same machine (not only github, but gitlab and other clients using git version management system).
    ```bash
    git config user.email "somename@users.noreply.github.com"
    git config user.name "username"
    ```
* Confirm the repository configurations. Adjust the configuration as needed.
    ```bash
    git config -l
    ```


## Basic Commands for Github cli (gh)

The commands are self explanatory or use the official [github cli documentation](https://docs.github.com/en/github-cli/github-cli/quickstart).

```bash
gh --version
gh auth login
gh auth status
gh repo clone <username>/<repository>
gh repo create <repository-name> --public --description "A new repository"
gh issue list
gh pr create --title "Pull Request Title" --body "Description of the PR"
gh notification list
gh repo create <username> --public --confirm
gh auth logout
```


## References

* [github-cli/quickstart](https://docs.github.com/en/github-cli/github-cli/quickstart)
