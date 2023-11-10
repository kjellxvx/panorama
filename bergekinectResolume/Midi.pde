import themidibus.*;
MidiBus mb;

int channel = 1;
int pitch = 50;
int velocity = 0;

void initMidi() {
  MidiBus.list();
  mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
  mb.sendTimestamps(false);
}
