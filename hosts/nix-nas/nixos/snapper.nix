{...}: {
  services.snapper = {
    snapshotInterval = "*:0/20";
    cleanupInterval = "2h";
    configs = {
      "sync" = {
        SUBVOLUME = "/sync";
        ALLOW_USERS = ["raab"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 7200; # 2 hours
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 14;
        TIMELINE_LIMIT_WEEKLY = 12;
        TIMELINE_LIMIT_MONTHLY = 12;
        TIMELINE_LIMIT_YEARLY = 10;
      };
    };
  };
}