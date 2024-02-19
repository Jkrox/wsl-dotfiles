# This is my configuration to use in my WSL Terminal with Ubuntu

First of all, you need to do this before to run the `dotfiles.sh`

So copy and paste this is on your terminal to proceed:

```sh
cd 
sudo apt update && sudo apt upgrade
sudo apt install wget git 
```

Now, go to `assets/` folder in order to install some dependencies, please follow the next steps: 

```sh
# I'm supposing that you have already cloned the project 
cd wsl-dotfiles/assets/
sudo dpkg -i bat-musl_0.23.0_amd64.deb
sudo dpkg -i lsd-musl_1.0.0_amd64.deb
```
With this two packages your output will look fancier and readable.

> 📝 However, with these packages you may have to use a enhanced font which supports as many icons as possible.
> Use fonts from [Nerd Font](https://www.nerdfonts.com/font-downloads), in my case, I have been using [this one](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip)
-------------------------
*Done that, you have to execute the `dotfile.sh` file.*
Follow the next  steps:
```sh
chmod +x dotfiles.sh
./dotfiles.sh
```

That's it, you got set up your dev enviroment 🐱‍💻.