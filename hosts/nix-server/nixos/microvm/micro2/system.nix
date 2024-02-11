{...}: {
  microvm.interfaces = [
    {
      type = "macvtap";
      macvtap = {
        mode = "bridge";
        link = "enp3s0";
      };
      id = "micro2";
      mac = "02:00:00:00:00:02";
    }
  ];
  networking.hostName = "micro2";
}
