{
  inputs,
  cell,
}: {
  default = inputs.nixpkgs.sway.override {
    inherit (inputs.nixpkgs-wayland.packages.x86_64-linux) sway-unwrapped;
  };
}
