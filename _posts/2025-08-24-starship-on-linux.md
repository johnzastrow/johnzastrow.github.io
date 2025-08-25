---
title: 'Installing starship cli tool on Ubuntu'
subtitle: Who doesn't like a little pizazz?
date: '2025-08-24T15:02:15-05:00'
author: 'John C. Zastrow'
layout: post
gh-badge: [star, fork, follow]
tags: [linux, cli, tools, management]
comments: true
---

I've been enjoying using [starship rs](https://starship.rs/) to enhance my terminal experience on Ubuntu. It's a minimal, blazing-fast, and infinitely customizable prompt for any shell. Written in Rust of course.

## Process
1.  A Nerd Font installed and enabled in your terminal (love [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)).
from this [post](https://dev.to/thiagomg/installing-a-nerd-font-in-ubuntu-558l) , 

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
# Unzip the file downloaded
filename=FiraCode.zip
extension="${filename##*.}"
filename="${filename%.*}"
mkdir ${filename} && pushd ${filename}
unzip ../${filename}.${extension}
popd

# Moving to the correct location and update font cache
# Now, let's create a .fonts directory and move the new font there

mkdir -p ~/.fonts
mv ${filename} ~/.fonts/

# Last, but not least, we need to update Ubuntu's font cache

fc-cache -fv
```

Then check to see if they all landed well with `fc-list :family | sort | uniq ` 

2. Then install starship with `sudo curl -sS https://starship.rs/install.sh | sh` to install starship. or just `sudo apt install starship`
3. Add the following line to your shell's configuration file to initialize Starship:
4. `eval "$(starship init bash)"` for bash or `eval "$(starship init zsh)"` for zsh
5. Restart your terminal or run `source ~/.bashrc` or `source ~/.zshrc` to apply the changes.   

{: .box-note}
While I'm here, on Windows, stick the init thing for bash into a `.profile` file instead of .bashrc

6. Configure Starship to your liking by creating a `~/.config/starship.toml` file. You can find the configuration options in the [Starship documentation](https://starship.rs/config/).
   
   * `mkdir -p ~/.config && touch ~/.config/starship.toml`
   * then maybe apply some presets from [here](https://starship.rs/config/#preset-configuration)
   * Though on my most recent deployment, I opted for a more minimal setup because I like the CLI icon better
