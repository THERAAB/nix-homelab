{...}: let
  uid = 7662;
  gid = 7663;
  port = 9090;
  network = 
in {
  services.podman-application.linkding = {
    displayName = "LinkDing";
    port = port;
    uid = uid;
    gid = gid;
    internalPort = port;
    dockerImage = "docker.io/sissbruecker/linkding";
    internalMountDir = "/etc/linkding/data";
  };
  users.groups.linkding.gid = gid;
}
