{
  description = "AstroNvim Fork with Integrated Dev Tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Your fork of the AstroNvim template
    astronvim-fork = {
      url = "github:youruser/astronvim-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, astronvim-fork }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Determine if we use the local folder or the fetched GitHub fork
        # Usage: nix build .#nvim --impure (if using local paths)
        useLocal = false;
        nvimSource = if useLocal then ./src else astronvim-fork;

      in
      {
        # 1. The Package: Your configured Neovim
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "astronvim-trafficone";
          version = "1.0.0";
          src = nvimSource;
          installPhase = ''
            mkdir -p $out
            cp -r ./* $out/
          '';
        };

        # 2. The DevShell: For editing your Lua/Nix files
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Nix LSP & Formatter
            nil
            alejandra

            # Lua LSP & Formatter
            lua-language-server
            stylua

            # General AstroNvim dependencies
            ripgrep
            fd
            nodejs # Some LSPs require node
          ];

          shellHook = ''
            echo "--- Neovim Config Dev Environment ---"
            echo "LSPs available: nil (Nix), lua-language-server (Lua)"
            # Optional: automatically open nvim if you want
            export NIX_PROVIDED_LSPS='nil,lua-language-server'
          '';
        };
      }
    );
}
