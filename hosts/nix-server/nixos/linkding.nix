{...}: let
  uid = 7662;
  gid = 7663;
  port = 9090;
in {
  services.podman-application.linkding = {
    port = port;
    uid = uid;
    gid = gid;
    dockerImage = "docker.io/sissbruecker/linkding";
    internalMountDir = "/etc/linkding/data";
  };
  users.groups.linkding.gid = gid;
}
