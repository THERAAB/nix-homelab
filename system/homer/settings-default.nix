{
  # See https://fontawesome.com/v5/search for icons options
  title = "Nix Homelab Server";
  logo = "logo.png";
  header = true;
  footer = false;
  theme = "default";
  colors = {
    light = {
      highlight-primary = "#eceff4";
      highlight-secondary = "#e5e9f0";
      highlight-hover = "#d8dee9";
      background = "#e5e9f0";
      card-background = "#eceff4";
      text = "#30576d";
      text-header = "#30576d";
      text-title = "#434c5e";
      text-subtitle = "#4c566a";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
    dark = {
      highlight-primary = "#323946";
      highlight-secondary = "#323946";
      highlight-hover = "#323946";
      background = "#2E3440";
      card-background = "#3b4252";
      text = "#81A1C1";
      text-header = "#81A1C1";
      text-title = "#D8DEE9";
      text-subtitle = "#ECEFF4";
      card-shadow = "rgba(0, 0, 0, 0.4)";
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
      name = "Wiki";
      icon = "fas fa-book";
      url = "https://www.wikipedia.org/";
      target = "_blank";
    }
  ];
}