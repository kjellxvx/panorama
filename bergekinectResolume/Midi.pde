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
int pitch = 0;
int velocity = 127;

// Define a variable to store the timestamp of the last note trigger
long lastNoteTriggerTime = 0;
// Define a variable for the note duration in milliseconds
int noteDuration = 100; // Adjust the duration as needed

void initMidi() {
  MidiBus.list();
  mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
  mb.sendTimestamps(false);
  videoPosToNote.put(new Range(558, 607), 1); // 0558 – 0607 - Blätterrascheln
  videoPosToNote.put(new Range(686, 1320), 2); // 0686 – 1320 - Berge Wachsen
  videoPosToNote.put(new Range(807, 812), 3); // 0807 - Berge drücken gegen die Daumen
  videoPosToNote.put(new Range(884, 889), 4); // 0884 - Ringfinger treffen aufeinander
  videoPosToNote.put(new Range(950, 955), 5); // 0950 - Mittelfinger rutsch vom Berg ab
  videoPosToNote.put(new Range(1033, 1038), 6); // 1033 - Berg in der Mitte kommt in den Vordergrund
  videoPosToNote.put(new Range(1107, 1112), 7); // 1107 - Übergang Berg Mitte Rechts von Zeigefinger auf Mittelfinger
  videoPosToNote.put(new Range(1156, 1161), 8); // 1156  - Berg Links Riss fängt an
  videoPosToNote.put(new Range(1215, 1216), 9); // 1215 - Berg Rechts oben Riss fängt an
  videoPosToNote.put(new Range(1216, 1221), 10); // 1216 - Berg Links Riss spaltet sich ab
  videoPosToNote.put(new Range(1229, 1234), 11); // 1229 - Daumen Links drückt auf den kleinen Berg
  videoPosToNote.put(new Range(1260, 1265), 12); // 1260 - Berg Rechts oben Riss spaltet sich ab
  videoPosToNote.put(new Range(1266, 1271), 13); // 1266 - Mittelfinger Rechts rutsch auf Berg ab
  videoPosToNote.put(new Range(1279, 1284), 14); // 1279 - kleiner Berg flutscht wieder zurück
  videoPosToNote.put(new Range(1310, 135), 15); // 1310 - Öffnung der Hände geht los
  videoPosToNote.put(new Range(1351, 1356), 16); // 1351 - Berg Links klappt wieder zu

  // Initialize noteTriggered map with all ranges set to false
  for (Range range : videoPosToNote.keySet()) {
    noteTriggered.put(range, false);
  }
}

void triggerNote() {
  long currentTime = millis();

  for (Range range : videoPosToNote.keySet()) {
    if (range.contains(videoPos) && !noteTriggered.get(range)) {
      pitch = videoPosToNote.get(range);

      // Check if enough time has passed since the last note trigger
      if (currentTime - lastNoteTriggerTime >= noteDuration) {
        mb.sendNoteOn(channel, pitch, velocity);

        // Update the timestamp of the last note trigger
        lastNoteTriggerTime = currentTime;

        // Set the flag to true to indicate that the note has been triggered for this range
        noteTriggered.put(range, true);
      }
      break; // Exit the loop after triggering the first matching range
    } else if (!range.contains(videoPos)) {
      // Reset the flag if videoPos is outside the current range
      noteTriggered.put(range, false);
    }
  }
}
