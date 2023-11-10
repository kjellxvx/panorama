  
Download & Install Processing 4.3
https://processing.org/download

Download & Install Resolume Avenue
https://www.resolume.com/download/

# Processing Libraries kopieren
## Mac
Download libraries.zip
https://github.com/kjellxvx/berge-animation/blob/main/libraries.zip

Unpack libraries.zip
Paste content of libarbies in folder:

./Documents/Processing/libraries

# Create new Resolume project

## activate OSC Input 
Resolume -> Einstellungen -> OSC
Input aktivieren und Port auf 7000

![OSC Settings](./assets/OSC-setup.png)

## Add video to Resolume Timeline
![OSC Settings](./assets/resolume-timeline.png)


# set up Midi Input
## Mac
~~Download CoreMidi4J~~
~~https://github.com/DerekCook/CoreMidi4J/releases~~
~~copy .jar file in Processing/libaries/themidibus/library~~

MIDI Studio öffnen
IAC Driver einrichten und aktivieren
![MIDI Settings](./assets/midi-studio.png)



# Make java work on Mac
Applications -> Processing -> show packages
Contents -> Java
Copy jna-platform.jar and jna.jar from Java to /core/library




  

Paste file in:

Documents -> Processing -> libraries -> themidibus -> library
