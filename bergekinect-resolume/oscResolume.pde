import oscP5.*;

OscP5 oscP5;
String resolumeIP = "127.0.0.1"; // Resolume's IP address
int oscPort = 7000; // OSC port (make sure it matches your Resolume configuration)
void initOsc() {
  oscP5 = new OscP5(this, resolumeIP, oscPort);
}


void sendOsc(int videoPos) {
  OscMessage message = new OscMessage("/composition/layers/1/clips/1/transport/position");
  message.add(map(videoPos, 0, frames, 0.0, 1.0)); // Map frame to OSC position (0.0 to 1.0)
  oscP5.send(message);
}
