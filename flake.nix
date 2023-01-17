{
  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
  };

  outputs = { self, nixpkgs, mach-nix }@inp:
    let
      l = nixpkgs.lib // builtins;
      supportedSystems = [ "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs { inherit system; }));
    in
    {
      # enter this python environment by executing `nix shell .`
      devShell = forAllSystems (system: pkgs: mach-nix.lib."${system}".mkPythonShell {
        requirements = builtins.readFile ./requirements.txt;
      });
    };
}

