{ neovim-unwrapped, fetchFromGitHub, tree-sitter }:

let
  rev = "97ffa158aa9ae6c80a48b3ceea91270f0a179743";
  sha256 = "10qplh8a7pndr5wv5irkill569af2hka7cwrlrm2cbn0ix6bz65z";
in
  neovim-unwrapped.overrideAttrs(old: {
    version = "0.5.0-${rev}";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      inherit rev sha256;
    };
    buildInputs = old.buildInputs ++ [ tree-sitter ];
  })
