{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 {
  pname = "world-monitor";
  version = "2.5.23";

  src = fetchurl {
    url = "https://github.com/koala73/worldmonitor/releases/download/v2.5.23/World.Monitor_2.5.23_amd64.AppImage";
    sha256 = "139mra0j8lrx8l17gb77fa6zjarc1n7ffkzayas4j3zmwn08yjs0";
  };

  meta = with lib; {
    description = "A simple app to monitor world events";
    homepage = "https://github.com/koala73/worldmonitor";
    platforms = platforms.linux;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}