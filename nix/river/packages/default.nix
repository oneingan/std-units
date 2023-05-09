{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  default = nixpkgs.callPackage ./river.nix {
    # river = inputs.nixpkgs.river.overrideAttrs (_: {
    # inherit (cell.sources.generated.river) pname version src;
    # });
  };
}
