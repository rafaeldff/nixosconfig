{ config, pkgs, ... }:


{
  home.packages =
    let
    in
    with pkgs; [
    
    # dev
    #python2
    # gitFull conflicts with git #XXX 
    openjdk11
    maven
    visualvm
    jetbrains.idea-ultimate
    awscli
    github-cli

    (clojure.override {jdk = pkgs.jdk11;})
    leiningen

    #clj-kondo

    linuxPackages.perf

    # virtualization
    vagrant

    # infosec
    nssTools

    vscode
    glibc
    gnumake

    # web ui
    ncurses.dev
    confluent-platform
    ];

    #virtualisation.virtualbox.host.enable = true; #XXX

    programs.git = {
      enable = true;
      userName = "Rafael de F. Ferreira";
      userEmail = "rafael.ferreira@nubank.com.br";
      lfs = {
	enable = true;
	skipSmudge = true;
      };
      difftastic.enable = true;
      extraConfig = {
        push = { default = "upstream"; };
        "url \"git@github.com:\"" = { insteadOf = "https://github.com/"; };
        "color" = { ui = true; };
        "merge" = { conflictstyle = "diff3" ; };
        "diff \"class\"" = {
          textconv = "javap";
          binary = true;
        };
        "diff \"clojure\"" = {
          xfuncname = "(^\\(.*|\\s*\\(defn.*)";
        };
        "init" = {
          defaultBranch = "main";
        };
      };
      ignores = import ./git-ignore.nix;
      attributes = import ./git-attributes.nix;
      aliases = {
        l = "log --pretty=format:\"%h %ad | %s%C(yellow)%d%Creset [%an %ar]\" --graph --date=short";
        report = "!git fetch origin && git --no-pager log  --pretty=format:\"%<(22)%an %<(11)%ar | %s%C(yellow)%d%Creset\"  --date=short  --since \"2 weeks ago\" --all --color=always | grep -v 'lint fix'";
        syncmain = "!git checkout main && git pull --ff-only origin main && git checkout - && git merge main";
        p = "pull --ff-only  --prune";
        recent = "branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(align:width=32)%(refname:short)%(end) %(authorname)\"";
      };
      includes = [
        {
          path = "~/.nugitconfig";
          condition = "gitdir:~/dev/nu/";
        }
      ];
    };

  }
