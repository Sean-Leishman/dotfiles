export XDG_CONFIG_HOME=$HOME/.config

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

. "$HOME/.cargo/env"


eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/emodipt-extend.omp.json)"

# >>> coursier install directory >>>
export PATH="$PATH:/home/seanleishman/.local/share/coursier/bin"
# <<< coursier install directory <<<

# Launch Hyprland from a TTY without spawning a phantom nested output.
#
# When another Wayland compositor (e.g. GNOME on another VT) is running as the
# same user, aquamarine's startup probe connects to its default `wayland-0`
# socket and keeps a nested Wayland output ALONGSIDE the real DRM panel -- so
# half of Hyprland renders into a window inside the other session, hurting
# smoothness and "losing" windows offscreen. Pointing WAYLAND_DISPLAY at a
# socket that doesn't exist makes that probe fail (`wl_display_connect failed`),
# so Hyprland comes up DRM-only on the laptop panel. Hyprland then exports its
# own WAYLAND_DISPLAY for child apps, so this bogus value never reaches them.
Hyprland() {
    WAYLAND_DISPLAY=hypr-no-nest command /usr/bin/Hyprland "$@"
}
