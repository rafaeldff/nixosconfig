{ config, pkgs, ... }:

let
  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
in
{
  home.packages =
  with pkgs; [
    google-cloud-sdk
    cfssl
    kubernetes
    minikube
  ];

}
