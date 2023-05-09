{
  inputs,
  cell,
}: let
  urbit-drv = import inputs.urbit {system = "x86_64-linux";};
in
  urbit-drv
