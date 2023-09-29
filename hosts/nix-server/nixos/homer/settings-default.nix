{
  # See https://fontawesome.com/v5/search for icons options
  title = "Nix Homelab Server";
  logo = "logo.png";
  header = true;
  footer = false;
  theme = "default";
  colors = {
    dark = {
      highlight-primary = "transparent";
      highlight-secondary = "#414559";
      highlight-hover = "#414559";
      background = "#303446";
      card-background = "#414559";
      text = "#c6d0f5";
      text-header = "#c6d0f5";
      text-title = "#c6d0f5";
      text-subtitle = "#ca9ee6";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
    light = {
      highlight-primary = "transparent";
      highlight-secondary = "#e6e9ef";
      highlight-hover = "#e6e9ef";
      background = "#eff1f5";
      card-background = "#e6e9ef";
      text = "#4c4f69";
      text-header = "#4c4f69";
      text-title = "#4c4f69";
      text-subtitle = "#ea76cb";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
  };
  links = [
    {
      name = "GitHub";
      icon = "fab fa-github";
      url = "https://github.com/THERAAB/nix-homelab";
      target = "_blank";
    }
    {
      name = "YouTube";
      icon = "fab fa-youtube";
      url = "https://www.youtube.com/";
      target = "_blank";
    }
    {
      name = "Gmail";
      icon = "fas fa-envelope";
      url = "https://www.mail.google.com/mail/u/0/#inbox";
      target = "_blank";
    }
    {
      name = "Outlook";
      icon = "fas fa-at";
      url = "https://outlook.live.com/mail/0/";
      target = "_blank";
    }
  ];
}
