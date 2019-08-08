// r/Guitar Ear Trainer **DEMO** by David Wilson AKA u/WilsonsDavid123

import java.util.*;

class Notes {
  private Map<String, Note> notes;
  
  Notes(PApplet applet) {
    
    // probably could just algorithmically filled this hashmap, but, oh well. I'm lazy
    // A = 440Hz
    notes = new HashMap();      

    notes.put("E2",  new Note(applet, "E2", 0, 82.41));
    notes.put("F2",  new Note(applet, "F2", 1, 87.31));
    notes.put("F#2", new Note(applet, "F#2", 2, 92.50));
    notes.put("G2",  new Note(applet, "G2", 3, 98.00));
    notes.put("G#2", new Note(applet, "G#2", 4, 103.83));
    notes.put("A2",  new Note(applet, "A2", 5, 110.00));
    notes.put("A#2", new Note(applet, "A#2", 6, 116.54));
    notes.put("B2",  new Note(applet, "B2", 7, 123.47));
    notes.put("C3",  new Note(applet, "C3", 8, 130.81));
    notes.put("C#3", new Note(applet, "C#3", 9, 138.59));
    notes.put("D3",  new Note(applet, "D3", 10, 146.83));
    notes.put("D#3", new Note(applet, "D#3", 11, 155.56));    
      
    notes.put("E3",  new Note(applet, "E3", 12, 164.81));
    notes.put("F3",  new Note(applet, "F3", 13, 174.61));
    notes.put("F#3", new Note(applet, "F#3", 14, 185.00));
    notes.put("G3",  new Note(applet, "G3", 15, 196.00));
    notes.put("G#3", new Note(applet, "G#3", 16, 207.65));
    notes.put("A3",  new Note(applet, "A3", 17, 220.00));
    notes.put("A#3", new Note(applet, "A#3", 18, 233.08));
    notes.put("B3",  new Note(applet, "B3", 19, 246.94));
    notes.put("C4",  new Note(applet, "C4", 20, 261.63));
    notes.put("C#4", new Note(applet, "C#4", 21, 277.18));
    notes.put("D4",  new Note(applet, "D4", 22, 293.66));
    notes.put("D#4", new Note(applet, "D#4", 23, 311.13));    
    
    notes.put("E4",  new Note(applet, "E4", 24, 329.63));
    notes.put("F4",  new Note(applet, "F4", 25, 349.23));
    notes.put("F#4", new Note(applet, "F#4", 26, 369.99));
    notes.put("G4",  new Note(applet, "G4", 27, 392.00));
    notes.put("G#4", new Note(applet, "G#4", 28, 415.30));
    notes.put("A4",  new Note(applet, "A4", 29, 440.00));
    notes.put("A#4", new Note(applet, "A#4", 30, 466.16));
    notes.put("B4",  new Note(applet, "B4", 31, 493.88));
    notes.put("C5",  new Note(applet, "C5", 32, 523.25));
    notes.put("C#5", new Note(applet, "C#5", 33, 554.37));
    notes.put("D5",  new Note(applet, "D5", 34, 587.33));
    notes.put("D#5", new Note(applet, "D#5", 35, 622.25));
    
    notes.put("E5",  new Note(applet, "E5", 36, 659.25));
    notes.put("F5",  new Note(applet, "F5", 37, 698.46));
    notes.put("F#5", new Note(applet, "F#5", 38, 739.99));
    notes.put("G5",  new Note(applet, "G5", 39, 783.99));
    notes.put("G#5", new Note(applet, "G#5", 40, 830.61));
    notes.put("A5",  new Note(applet, "A5", 41, 880.00));
    notes.put("A#5", new Note(applet, "A#5", 42, 932.33));
    notes.put("B5",  new Note(applet, "B5", 43, 987.77));
    notes.put("C6",  new Note(applet, "C6", 44, 1046.50));
    notes.put("C#6", new Note(applet, "C#6", 45, 1108.73));
    notes.put("D6",  new Note(applet, "D6", 46, 1174.66));
    notes.put("D#6", new Note(applet, "D#6", 47, 1244.51));
    
    notes.put("E6",  new Note(applet, "E6", 48, 1318.51));
    
  }
  
  Note get_by_index(int index) {
    for (Note n : notes.values()) {
      if (n.index == index) {
        return n;
      }
    }
    return null;
  }
  
  Note get_by_name(String name) {
   return notes.get(name);
  }
  
  void play_note(String name) {
    notes.get(name).play();
  }
  
  void stop_note(String name) {
    notes.get(name).pause();
  }
};
