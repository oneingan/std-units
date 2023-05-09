{
  inputs,
  cell,
}: {
  # Necesito convertir
  mkNvfetcher = sw: let
    l = inputs.nixpkgs.lib // builtins;
    name = l.head (l.attrNames sw);
    src = sw.${name}.src;
    srcLines = l.forEach (l.attrNames src) (x: "src." + x + " = \"" + src.${x} + "\"");
    fetch = sw.${name}.fetch;
    fetchLines = l.forEach (l.attrNames fetch) (x: "fetch." + x + " = \"" + fetch.${x} + "\"");
  in ''
    [${name}]
    ${l.foldl' (x: y: x + y + "\n") "" (srcLines ++ fetchLines)}
  '';
}
