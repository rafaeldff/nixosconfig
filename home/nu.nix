{ config, pkgs, ... }:


{
  home.packages =
  with pkgs; [
    #yubikey
    yubioath-flutter
    yubikey-manager
    #gnupg # this is gpg >= 2
    pinentry-curses
    nss.tools


    #zoom-us

    # vpn
    # sshuttle #
    # openfortivpn

    #mobile
    git-lfs

    #nucli
    gettext
  ];

  #services.pcscd.enable = true; #XXX
  services.gpg-agent = { #XXX
   enable = true;
   pinentryFlavor = "curses";
  };
  
  #hardware.u2f.enable = true; #XXX

  # programs = { #XXX
  #   chromium = {
  #     enable = true;
  #     extraOpts = {
  #       AutoSelectCertificateForUrls = ["{\"pattern\":\"[*.]nubank.com.br\",\"filter\":{\"ISSUER\":{\"CN\":\"nubanker\"}}}"];
  #     };
  #   };
  # };


  programs.bash = {
    sessionVariables = {
      # note: shopt histappend is on by default.
    };
    shellAliases = {
    };
    bashrcExtra = ''
      function docker-compose() {
        docker compose "$@";
      }
      export -f docker-compose
    '';
    initExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

      
      source $HOME/.nurc
      # BEGIN ANSIBLE MANAGED BLOCK - NU_HOME ENV
      export NU_HOME="$HOME/dev/nu"
      export NUCLI_HOME=$NU_HOME/nucli
      export PATH="$NUCLI_HOME:$PATH"
      # END ANSIBLE MANAGED BLOCK - NU_HOME ENV
      # BEGIN ANSIBLE MANAGED BLOCK - GO
      export GOPATH="$HOME/go"
      export PATH="$GOPATH/bin:$PATH"
      # END ANSIBLE MANAGED BLOCK - GO
      # BEGIN ANSIBLE MANAGED BLOCK - NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      # END ANSIBLE MANAGED BLOCK - NVM
      # BEGIN ANSIBLE MANAGED BLOCK - ANDROID SDK
      export ANDROID_HOME="/home/rafael/Android/Sdk"
      export ANDROID_SDK="$ANDROID_HOME"
      export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
      # END ANSIBLE MANAGED BLOCK - ANDROID SDK
      # BEGIN ANSIBLE MANAGED BLOCK - MOBILE MONOREPO
      export MONOREPO_ROOT="''${NU_HOME}/mini-meta-repo"
      export PATH="$PATH:$MONOREPO_ROOT/monocli/bin"
      # END ANSIBLE MANAGED BLOCK - MOBILE MONOREPO
      # BEGIN ANSIBLE MANAGED BLOCK - Flutter SDK
      export FLUTTER_SDK_HOME="$HOME/sdk-flutter"
      export FLUTTER_ROOT="$FLUTTER_SDK_HOME"
      export PATH="$PATH:$FLUTTER_SDK_HOME/bin:$HOME/.pub-cache/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin"
      # END ANSIBLE MANAGED BLOCK - Flutter SDK
    '';
  };
}

