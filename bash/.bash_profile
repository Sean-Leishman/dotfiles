export XDG_CONFIG_HOME=$HOME/.config

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

. "$HOME/.cargo/env"


eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/emodipt-extend.omp.json)"

# >>> coursier install directory >>>
export PATH="$PATH:/home/seanleishman/.local/share/coursier/bin"
# <<< coursier install directory <<<
