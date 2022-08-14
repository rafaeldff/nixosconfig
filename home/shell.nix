{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    historyControl = ["ignorespace" "ignoredups"];
    historyFileSize = 1000000;
    historySize = 1000000;
    sessionVariables = {
      EDITOR = "vim";
      HISTTIMEFORMAT = "%F %T ";
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      # note: shopt histappend is on by default.
    };
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };
    initExtra = ''
      export GIT_PS1_SHOWDIRTYSTATE=1
  
      source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh
      __prompt_color="1;33m"
      # Alternate color for hostname if the generated color clashes with prompt color
      __alternate_color="1;35m"
      __hostnamecolor="$__prompt_color"
      # If logged in with ssh, pick a color derived from hostname
      if [ -n "$SSH_CLIENT" ]; then
        __hostnamecolor="1;$(${pkgs.nettools}/bin/hostname | od | tr ' ' '\n' | ${pkgs.gawk}/bin/awk '{total = total + $1}END{print 30 + (total % 6)}')m"
        # Fixup color clash
        if [ "$__hostnamecolor" = "$__prompt_color" ]; then
          __hostnamecolor="$__alternate_color"
        fi
      fi
      __red="1;31m"
      PS1='\n$(ret=$?; test $ret -ne 0 && printf "\[\e[$__red\]$ret\[\e[0m\] ")\[\e[$__prompt_color\]\u@\[\e[$__hostnamecolor\]\h \[\e[$__prompt_color\]\w$(__git_ps1 " [git:%s]")\[\e[0m\]\n$ '

      test -r ~/.dircolors && eval $(${pkgs.coreutils}/bin/dircolors -b ~/.dircolors)

      if [ $HOME/bin/marks.sh ]; then
        source $HOME/bin/marks.sh;
      fi

      # enable bash completion in interactive shells
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
      fi
    '';
  };
}
