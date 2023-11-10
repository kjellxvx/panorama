  
Download & Install Processing 4.3
https://processing.org/download

Download & Install Resolume Avenue
https://www.resolume.com/download/

# Processing Libraries kopieren
## Mac
Ordner öffnen:  ./Documents/Processing/libraries



# OSC Input Einrichten
Resolume -> Einstellungen -> OSC
Input aktivieren und Port auf 7000

![[./assets/Screenshot 2023-11-10 at 12.58.47.png]]

# Midi Input Einstellen
## Mac
MIDI Studio öffnen
IAC Driver einrichten und aktivieren

![[./assets/Screenshot 2023-11-10 at 13.00.11.png]]

## Make java work on Mac

  

Applications -> Processing -> show packages

Contents -> Java

Copy jna-platform.jar and jna.jar to core -> library

  

## Make Midi work on Mac

Download CoreMidi4J

https://github.com/DerekCook/CoreMidi4J/releases

  

Paste file in:

Documents -> Processing -> libraries -> themidibus -> library