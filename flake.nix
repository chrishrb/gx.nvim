{
  description = "gx.nvim";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      nixpkgs,
      self,
      ...
    }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        xdg-utils = pkgs.xdg-utils;

        gx-nvim = pkgs.vimUtils.buildVimPlugin {
          pname = "gx.nvim";
          version = "main";
          src = self;
          patches = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            (pkgs.replaceVars ./patches/gx-nvim/fix-paths.patch {
              inherit xdg-utils;
            })
          ];
        };
      in
      {
        packages = {
          default = gx-nvim;
        };
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              (pkgs.neovim.override {
                configure = {
                  customRC = ''
                    lua vim.g.netrw_nogx = 1
                    lua require('gx').setup()
                    lua vim.keymap.set({ "n", "x" }, "gx", "<cmd>Browse<cr>")
                  '';
                  packages.myVimPackage = {
                    start = [ gx-nvim ];
                  };
                };
              })
            ];
          };
        };
      }
    );
}
