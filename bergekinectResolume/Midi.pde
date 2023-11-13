import themidibus.*;
MidiBus mb;

import java.util.HashMap;

// Define your mapping of videoPos range to note
HashMap<Range, Integer> videoPosToNote = new HashMap<Range, Integer>();
HashMap<Range, Boolean> noteTriggered = new HashMap<Range, Boolean>();

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
int pitch = 50;
int velocity = 0;

void initMidi() {
  MidiBus.list();
  mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
  mb.sendTimestamps(false);
  videoPosToNote.put(new Range(1200, 1210), 1);
  videoPosToNote.put(new Range(1240, 1245), 2);
  videoPosToNote.put(new Range(1400, 1450), 3);

  // Initialize noteTriggered map with all ranges set to false
  for (Range range : videoPosToNote.keySet()) {
    noteTriggered.put(range, false);
  }
}

void triggerNote() {
  for (Range range : videoPosToNote.keySet()) {
    if (range.contains(videoPos) && !noteTriggered.get(range)) {
      int note = videoPosToNote.get(range);
      mb.sendNoteOn(channel, pitch, note);
      sound = note;
      println("SOUND " + note);
      // Set the flag to true to indicate that the note has been triggered for this range
      noteTriggered.put(range, true);
      break; // Exit the loop after triggering the first matching range
    } else if (!range.contains(videoPos)) {
      // Reset the flag if videoPos is outside the current range
      noteTriggered.put(range, false);
    }
  }
}
