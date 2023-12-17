add `export NIXPKGS_ALLOW_INSECURE=1` somewhere for python2.7 (used by the node-gyp version provided by Garden)



`nix-shell -p nodePackages.node-gyp git nodejs_20 rsync cargo-cross rustc cargo rustup`


`cd pkgs/applications/networking/cluster/garden`

`nix-build .`