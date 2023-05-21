{...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_default";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
      };
    };
  };
}
