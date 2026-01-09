{
  python3,
  writeShellApplication,
}:

writeShellApplication {
  name = "daily-hours";
  runtimeInputs = [ python3 ];
  text = ''
    exec python3 ${./uptime.py} "$@"
  '';
}
