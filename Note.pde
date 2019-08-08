// r/Guitar Ear Trainer **DEMO** by David Wilson AKA u/WilsonsDavid123

class Note implements Comparable {
  
  public int index;
  public float freq;
  public String name;
  private color col;
  private boolean playing = false;
  private SinOsc osc;
  private PApplet parent;
  
  Note(PApplet parent, String name, int index, float freq) {
    this.name = name;
    this.index = index;
    this.freq = freq;
    this.parent = parent;
  
    // setup color.  ignore gross if statement :)
    // colors can be found here:
    // https://i.pinimg.com/originals/44/7b/e0/447be0f0be0bb0ba9f5753b9c5b7aa22.jpg
    // A is 12 oclock, A# is 1 oclock, B is 2 oclock, etc.
    if (name.contains("A#")) {
      col = color(255, 125, 0);
    } else if (name.contains("A")) {
      col = color(255, 0, 0);
    } else if (name.contains("B")) {
      col = color(255, 255, 0);
    } else if (name.contains("C#")) {
      col = color(0, 255, 0);
    } else if (name.contains("C")) {
      col = color(125, 255, 0);
    } else if (name.contains("D#")) {
      col = color(0, 255, 255);
    } else if (name.contains("D")) {
      col = color(0, 255, 125);
    } else if (name.contains("E")) {
      col = color(0, 125, 255);
    } else if (name.contains("F#")) {
      col = color(0, 125, 255);
    } else if (name.contains("F")) {
      col = color(0, 0, 255);
    } else if (name.contains("G#")) {
      col = color(255, 0, 125);
    } else if (name.contains("G")) {
      col = color(255, 0, 255);
    } else {
      col = color(0, 0, 0);
    }
  
    osc = new SinOsc(parent);
    osc.amp(0.4);
    osc.freq(freq);
  }
  
  public void play() {
     osc.play();
     playing = true;
  }
  
  public void pause() {
    osc.stop();
    playing = false;
  }
  
  public boolean is_playing() {
    return playing;
  }
  
  public color get_color() {
    return col;
  }
  
  public Note clone() {
    return new Note(parent, name, index, freq);
  }
  
  public int compareTo(Object other) {
    return index - ((Note)other).index;
  }
}
