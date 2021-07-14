stty -ixon

# prompt
setopt prompt_subst
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
PROMPT='%3~ '\$vcs_info_msg_0_'# '
zstyle ':vcs_info:git:*' check-for-staged-changes true
zstyle ':vcs_info:git:*' stagedstr '!'
zstyle ':vcs_info:git:*' formats '[%b]%c '

# check git status
function _print_git_status() {
	if [ -d .git ]; then
		git status
	fi
}

# add hooks
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _print_git_status

alias bk='cd -'
alias bup='brew upgrade'
alias cl='clear'
alias cm='cmake'
alias l='clear; ls -AG'
alias ll='clear; ls -AGhl'
alias matlab='matlab -nosplash -nodesktop'
alias nj='ninja'
alias v='nvim'
alias ta='tmux a -t'
alias tl='tmux ls'
alias tree='clear; tree -C | less -r'

# third-party binaries
PATH="/usr/local/bin:$PATH"

# homebrew
export HOMEBREW_NO_EMOJI=1

# texlive
PATH="/Library/TeX/texbin:$PATH"

# MATLAB
PATH="/Applications/MATLAB_R2021a.app/bin:$PATH"

# python
PATH="/usr/local/opt/python@3.9/bin:$PATH"
PATH="/usr/local/opt/python@3.9/libexec/bin:$PATH"
PATH="/usr/local/lib/python3.9/site-packages:$PATH"

# ruby
PATH="/usr/local/opt/ruby/bin:$PATH"
PATH="/usr/local/lib/ruby/gems/3.0.0/bin:$PATH"

# HDF5
HDF5_ROOT="/usr/local/Cellar/hdf5-mpi/1.12.0_2"
export HDF5INCLUDE="$HDF5_ROOT/include"
export HDF5DIR="$HDF5_ROOT/lib"
export HDF5LIB=hdf5

# case-insensitive auto-complete
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export PATH

# vi:set ft=zsh:
