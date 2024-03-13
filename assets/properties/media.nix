let
  users = import ./users.nix;
in {
  dir = {
    movies = "/media/movies/";
    tv = "/media/tv/";
    downloads = "/media/downloads";
    audiobooks = "/media/audiobooks";
    podcasts = "/media/podcasts";
  };
  group = {
    name = "media";
    id = users.media.gid;
  };
}
