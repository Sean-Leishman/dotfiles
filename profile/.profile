export XDG_CONFIG_HOME=$HOME/.config

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

. "$HOME/.cargo/env"


# >>> coursier install directory >>>
export PATH="$PATH:/home/seanleishman/.local/share/coursier/bin"
# <<< coursier install directory <<<

export PATH=$PATH:~/Packages/zig-linux-x86_64-0.15.0-dev.345+ec2888858
