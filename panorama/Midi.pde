import themidibus.*;
MidiBus mb;

import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;

// Define your mapping of videoPos range to note
HashMap<Range, MidiParameters> videoPosToMidi = new HashMap<>();
HashMap<String, Boolean> noteActive = new HashMap<>();
HashMap<String, Long> lastNoteTriggerTime = new HashMap<>();

class MidiParameters {
  int channel;
  int pitch;
  int velocity;
  boolean rewind;
  boolean abort;
  long lastNoteTriggerTime;

  MidiParameters(int channel, int pitch, int velocity, boolean rewind, boolean abort) {
    this.channel = channel;
    this.pitch = pitch;
    this.velocity = velocity;
    this.rewind = rewind;
    this.abort = abort;
    this.lastNoteTriggerTime = 0;
  }
}

class Range {
  int start;
  int end;

  Range(int start, int end) {
    this.start = start;
    this.end = end;
  }

  boolean contains(int value) {
    return value >= start && value <= end;
  }
}

int channel = 0;
int pitch = 0;
int velocity = 60;
int frameRange = 10;
int prevVideoPos = -1;
int noteTimeout = 50; // Timeout duration in milliseconds

void initMidi() {
  try {
    MidiBus.list();
    mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
    mb.sendTimestamps(false);


    // FORMAT Range (number - number) / channel / pitch / velocity / rewind / abort

    //Channel 1
    videoPosToMidi.put(new Range(536, 536+frameRange), new MidiParameters(0, 60, 60, false, false));
    videoPosToMidi.put(new Range(548, 548+frameRange), new MidiParameters(0, 61, 60, false, false));
    videoPosToMidi.put(new Range(562, 562+frameRange), new MidiParameters(0, 62, 60, false, false));
    videoPosToMidi.put(new Range(583, 583+frameRange), new MidiParameters(0, 63, 60, false, false));
    videoPosToMidi.put(new Range(615, 615+frameRange), new MidiParameters(0, 64, 60, false, false));
    videoPosToMidi.put(new Range(674, 674+frameRange), new MidiParameters(0, 65, 60, false, false));
    videoPosToMidi.put(new Range(774, 774+frameRange), new MidiParameters(0, 66, 60, false, false));
    videoPosToMidi.put(new Range(826, 826+frameRange), new MidiParameters(0, 67, 60, false, false));
    videoPosToMidi.put(new Range(898, 898+frameRange), new MidiParameters(0, 68, 60, false, false));

    //Channel 2
    videoPosToMidi.put(new Range(535, 535+frameRange), new MidiParameters(1, 60, 60, false, false));
    videoPosToMidi.put(new Range(585, 585+frameRange), new MidiParameters(1, 61, 60, false, false));
    videoPosToMidi.put(new Range(613, 613+frameRange), new MidiParameters(1, 62, 60, false, false));
    videoPosToMidi.put(new Range(676, 676+frameRange), new MidiParameters(1, 63, 60, false, false));
    videoPosToMidi.put(new Range(778, 778+frameRange), new MidiParameters(1, 64, 60, false, false));
    videoPosToMidi.put(new Range(911, 911+frameRange), new MidiParameters(1, 65, 60, false, false));
    videoPosToMidi.put(new Range(1167, 1167+frameRange), new MidiParameters(1, 66, 60, false, false));
    videoPosToMidi.put(new Range(1073, 1073+frameRange), new MidiParameters(1, 67, 60, false, false));

    //Channel 3
    videoPosToMidi.put(new Range(555, 555+frameRange), new MidiParameters(2, 60, 60, false, false));
    videoPosToMidi.put(new Range(711, 711+frameRange), new MidiParameters(2, 61, 60, false, false));
    videoPosToMidi.put(new Range(838, 838+frameRange), new MidiParameters(2, 62, 60, false, false));
    videoPosToMidi.put(new Range(967, 967+frameRange), new MidiParameters(2, 63, 60, false, false));
    videoPosToMidi.put(new Range(1090, 1090+frameRange), new MidiParameters(2, 64, 60, false, false));
    videoPosToMidi.put(new Range(1267, 1267+frameRange), new MidiParameters(2, 65, 60, false, false));

    //Channel 4
    videoPosToMidi.put(new Range(752, 752+frameRange), new MidiParameters(3, 60, 60, false, false));
    videoPosToMidi.put(new Range(1091, 1091+frameRange), new MidiParameters(3, 61, 60, false, false));

    //Channel 5
    videoPosToMidi.put(new Range(536, 536+frameRange), new MidiParameters(4, 60, 60, false, false));
    videoPosToMidi.put(new Range(708, 708+frameRange), new MidiParameters(4, 61, 60, false, false));
    videoPosToMidi.put(new Range(842, 842+frameRange), new MidiParameters(4, 62, 60, false, false));

    //Channel 6
    videoPosToMidi.put(new Range(964, 964+frameRange), new MidiParameters(5, 60, 60, false, false));

    //Channel 7
    videoPosToMidi.put(new Range(807, 807+frameRange), new MidiParameters(6, 60, 60, false, false));
    videoPosToMidi.put(new Range(884, 884+frameRange), new MidiParameters(6, 61, 60, false, false));
    videoPosToMidi.put(new Range(950, 950+frameRange), new MidiParameters(6, 62, 60, false, false));
    videoPosToMidi.put(new Range(1033, 1033+frameRange), new MidiParameters(6, 63, 60, false, false));
    videoPosToMidi.put(new Range(1107, 1107+frameRange), new MidiParameters(6, 64, 60, false, false));
    videoPosToMidi.put(new Range(1156, 1204), new MidiParameters(6, 65, 60, false, true));
    videoPosToMidi.put(new Range(1216, 1250), new MidiParameters(6, 66, 60, false, true));
    videoPosToMidi.put(new Range(1351, 1351+frameRange), new MidiParameters(6, 67, 60, false, false));
    videoPosToMidi.put(new Range(1215, 1244), new MidiParameters(6, 68, 60, false, true));
    videoPosToMidi.put(new Range(1229, 1229+frameRange), new MidiParameters(6, 69, 60, false, false));
    videoPosToMidi.put(new Range(1260, 1277), new MidiParameters(6, 70, 60, false, true));
    videoPosToMidi.put(new Range(1266, 1266+frameRange), new MidiParameters(6, 71, 60, false, false));
    videoPosToMidi.put(new Range(1279, 1279+frameRange), new MidiParameters(6, 72, 60, false, false));
    videoPosToMidi.put(new Range(1310, 1310+frameRange), new MidiParameters(6, 73, 60, false, false));

    //Channel 14
    videoPosToMidi.put(new Range(5, 5+frameRange), new MidiParameters(13, 60, 60, false, false));
    videoPosToMidi.put(new Range(120, 120+frameRange), new MidiParameters(13, 61, 60, false, false));
    videoPosToMidi.put(new Range(212, 212+frameRange), new MidiParameters(13, 62, 60, false, false));
    videoPosToMidi.put(new Range(305, 305+frameRange), new MidiParameters(13, 63, 60, false, false));
    videoPosToMidi.put(new Range(401, 401+frameRange), new MidiParameters(13, 64, 60, false, false));

    //Channel 15
    videoPosToMidi.put(new Range(5, 5+frameRange), new MidiParameters(14, 59, 69, false, false));
    videoPosToMidi.put(new Range(500, 500+frameRange), new MidiParameters(14, 60, 60, false, false));
    videoPosToMidi.put(new Range(600, 600+frameRange), new MidiParameters(14, 61, 60, false, false));
    videoPosToMidi.put(new Range(700, 700+frameRange), new MidiParameters(14, 62, 60, false, false));
    videoPosToMidi.put(new Range(800, 800+frameRange), new MidiParameters(14, 63, 60, false, false));
    videoPosToMidi.put(new Range(900, 900+frameRange), new MidiParameters(14, 64, 60, false, false));
    videoPosToMidi.put(new Range(1000, 1000+frameRange), new MidiParameters(14, 65, 60, false, false));
    videoPosToMidi.put(new Range(1100, 1100+frameRange), new MidiParameters(14, 66, 60, false, false));
    videoPosToMidi.put(new Range(1200, 1200+frameRange), new MidiParameters(14, 67, 60, false, false));
    videoPosToMidi.put(new Range(1300, 1300+frameRange), new MidiParameters(14, 68, 60, false, false));

    //Channel 16
    videoPosToMidi.put(new Range(10, 10+frameRange), new MidiParameters(15, 59, 69, false, false));
    videoPosToMidi.put(new Range(510, 510+frameRange), new MidiParameters(15, 60, 60, false, false));
    videoPosToMidi.put(new Range(610, 610+frameRange), new MidiParameters(15, 61, 60, false, false));
    videoPosToMidi.put(new Range(710, 710+frameRange), new MidiParameters(15, 62, 60, false, false));
    videoPosToMidi.put(new Range(810, 810+frameRange), new MidiParameters(15, 63, 60, false, false));
    videoPosToMidi.put(new Range(910, 910+frameRange), new MidiParameters(15, 64, 60, false, false));
    videoPosToMidi.put(new Range(1010, 1010+frameRange), new MidiParameters(15, 65, 60, false, false));
    videoPosToMidi.put(new Range(1110, 1110+frameRange), new MidiParameters(15, 66, 60, false, false));
    videoPosToMidi.put(new Range(1210, 1210+frameRange), new MidiParameters(15, 67, 60, false, false));
    videoPosToMidi.put(new Range(1310, 1310+frameRange), new MidiParameters(15, 68, 60, false, false));
  }
  catch (Exception e) {
    println("Error initializing MIDI: " + e.getMessage());
  }
}


void triggerNote() {
  long currentTime = millis();

  // Loop through each range
  for (Range range : videoPosToMidi.keySet()) {
    MidiParameters params = videoPosToMidi.get(range);
    String noteKey = params.channel + "-" + params.pitch;
    boolean isActive = noteActive.getOrDefault(noteKey, false);
    Long lastTrigger = lastNoteTriggerTime.getOrDefault(noteKey, 0L);

    if (range.contains(videoPos)) {
      if (!isActive && currentTime - lastTrigger >= noteTimeout && !isMoving) {
        // Entering the range for this note and timeout has elapsed
        sendNoteOn(params);
        noteActive.put(noteKey, true);
        lastNoteTriggerTime.put(noteKey, currentTime); // Update last trigger time on note on
      }
    } else if (isActive) {
      // Exiting the range for this note
      sendNoteOff(params);
      noteActive.put(noteKey, false);
      lastNoteTriggerTime.put(noteKey, currentTime); // Update last trigger time on note off
    }
  }
  prevVideoPos = videoPos;
}


void abortNote() {
  long currentTime = millis();
  // Loop through each range
  for (Range range : videoPosToMidi.keySet()) {
    MidiParameters params = videoPosToMidi.get(range);
    String noteKey = params.channel + "-" + params.pitch;
    boolean isActive = noteActive.getOrDefault(noteKey, false);
    boolean shouldAbort = params.abort; // Check the abort parameter
    if (isActive && shouldAbort) {
      // Active note with abort parameter set to true
      sendNoteOff(params);
      noteActive.put(noteKey, false);
      lastNoteTriggerTime.put(noteKey, currentTime); // Update last trigger time on note off
      // Print details
          println("ABORT NOTE: " + videoPos+ " Note OFF: Channel " + (params.channel +1) + ", Pitch " + params.pitch + ", Velocity " + params.velocity);
    }
  }
}



void sendNoteOn(MidiParameters params) {
  try {
    if (direction.equals("backwards")) {
      mb.sendNoteOn(params.channel, (params.pitch + 20), params.velocity);
      channel =params.channel;
      pitch =params.pitch + 20;
      velocity = params.velocity;
    } else {
      mb.sendNoteOn(params.channel, params.pitch, params.velocity);
      channel =params.channel;
      pitch =params.pitch;
      velocity = params.velocity;
    }
    println("FRAME: " + videoPos+ " Note ON: Channel " + (params.channel +1) + ", Pitch " + params.pitch + ", Velocity " + params.velocity);
  }
  catch (Exception e) {
    println("Error sending Note On: " + e.getMessage());
  }
}

void sendNoteOff(MidiParameters params) {
  try {

    if (direction.equals("backwards")) {
      mb.sendNoteOff(params.channel, (params.pitch + 20), 0);
    } else {
      mb.sendNoteOff(params.channel, params.pitch, 0);
    }
    //println("Note OFF: Channel " + params.channel + ", Pitch " + params.pitch);
  }
  catch (Exception e) {
    println("Error sending Note Off: " + e.getMessage());
  }
}
