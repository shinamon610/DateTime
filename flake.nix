{
  description = "Elan environment with direnv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      stdLibPath = "${pkgs.stdenv.cc.cc.lib}/lib";
    in {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [ pkgs.elan pkgs.stdenv.cc.cc.lib ];

        # NIX_SSL_CERT_FILE を無効にする
        shellHook = ''
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${stdLibPath}
          mkdir -p $PWD/.nix-shell/lib
          ln -sf ${stdLibPath}/libstdc++.so.6 $PWD/.nix-shell/lib/
          export PATH=$PATH:$PWD/.nix-shell/lib
          unset NIX_SSL_CERT_FILE
        '';
      };
    };
}
