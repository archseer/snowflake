final: prev: {
  kakoune = prev.kakoune.override {
    configure.plugins = with final.kakounePlugins; [
      (kak-fzf.override { fzf = final.skim; })
      kak-auto-pairs
      kak-buffers
      kak-powerline
    ];
  };
}
