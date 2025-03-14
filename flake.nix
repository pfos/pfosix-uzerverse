{
  description = "PFOSIX Uzerverse LifeWheelz.UIXengine - DevTeam-CORE Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.devshell.mkShell {
          name = "lifewheelz-uixengine";
          packages = with pkgs; [
            git 
            nodejs_20 
            yarn 
            docker 
            docker-compose
            nodePackages.typescript
            nodePackages.svelte-language-server
            cypress
            mdbook
          ];
          env = [
            {
              name = "NODE_ENV";
              value = "development";
            }
            {
              name = "DOCKER_BUILDKIT";
              value = "1";
            }
          ];
          commands = [
            {
              name = "dev-install";
              command = "yarn add vite @vitejs/plugin-react three d3 redux";
            }
          ];
        };
      }
    );
}