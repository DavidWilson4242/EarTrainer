// r/Guitar Ear Trainer **DEMO** by David Wilson AKA u/WilsonsDavid123

import processing.sound.*;

// user constants
final int STRING_X = 50;
final int STRING_Y = 50;
final int STRING_PADDING = 20; // vertical separation of strings
final int STRING_LENGTH = 565; // horizontal length of strings

// program constants
final int FRETBOARD_HEIGHT = 5*STRING_PADDING;

// this array describes the distance of each fret from the nut
// units are in pixels. 
// source: https://www.stewmac.com/FretCalculator.html
float[] fret_size = {
  0.000,
  42.094,
  81.826, 
  119.328, 
  154.725,
  188.135,
  219.670,
  249.435,
  277.530,
  304.047,
  329.077,
  352.701,
  375.000,
  396.047,
  415.913,
  434.664,
  452.362,
  469.067,
  484.835,
  499.718,
  513.765,
  527.024,
  539.538,
  551.351,
  562.500,
};

// settings vars
float tempo = 12000;
boolean hide_fretboard = false;
boolean is_running = false;
boolean show_octaves = false;
int bottom_range = 0;
int top_range = 48;

// width of each string in pixels, from high E to low E
float[] string_gauges = {2, 2, 3, 4, 5, 7};

// indicies of the open strings, from high E to low E
// (indicies identify each note with an integer, instead of
// a string. See the Notes.pde file. 0 is E2, 1 is F2, etc)
int[] open_string_indicies = {24, 19, 15, 10, 5, 0};

Note[][] GUITAR_NOTES;
Notes NOTES;
Note current_note = null;
boolean halt = true;
boolean has_played_note = false;
int last_note_change = -(int)tempo;
Random random = new Random(System.currentTimeMillis());

void stop_all_notes() {
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 25; j++) {
      if (GUITAR_NOTES[i][j].is_playing()) {
        GUITAR_NOTES[i][j].pause();
      }
    }
  }
}

boolean[] intro_stages = {false, false, false, false};
// plays a little blues turnaround to demonstrate coolness
void play_intro(int et) {
  // I should have developed a system to allow holding chords for a given amount
  // of time, but I'm only doing that here, so oh well...
  if (et < 2000) {
    if (!intro_stages[0]) {
      intro_stages[0] = true;
      stop_all_notes();
    }
    // play an E7
    GUITAR_NOTES[0][0].play(); // E  -  -  -  -  -  -  -  -  -  -  -  -
    GUITAR_NOTES[1][9].play(); // B  -  -  -  -  -  -  -  -  9  -  -  -
    GUITAR_NOTES[2][7].play(); // G  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[3][8].play(); // D  -  -  -  -  -  -  -  8  -  -  -  -
    GUITAR_NOTES[4][7].play(); // A  -  -  -  -  -  -  7  -  -  -  -  -
                               // E  X  X  X  X  X  X  X  X  X  X  X  X  
  } else if (et < 2500) {
    if (!intro_stages[1]) {
      intro_stages[1] = true;
      stop_all_notes();
    }
    // play an Eb7
                               // E  X  X  X  X  X  X  X  X  X  X  X  X 
    GUITAR_NOTES[1][8].play(); // B  -  -  -  -  -  -  -  8  -  -  -  -
    GUITAR_NOTES[2][6].play(); // G  -  -  -  -  -  6  -  -  -  -  -  -
    GUITAR_NOTES[3][7].play(); // D  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[4][6].play(); // A  -  -  -  -  -  6  -  -  -  -  -  -
                               // E  X  X  X  X  X  X  X  X  X  X  X  X  
  } else if (et < 3000) {
    if (!intro_stages[2]) {
      intro_stages[2] = true;
      stop_all_notes();
    }
    // play a D7
                               // E  X  X  X  X  X  X  X  X  X  X  X  X 
    GUITAR_NOTES[1][7].play(); // B  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[2][5].play(); // G  -  -  -  -  5  -  -  -  -  -  -  -
    GUITAR_NOTES[3][6].play(); // D  -  -  -  -  -  6  -  -  -  -  -  -
    GUITAR_NOTES[4][5].play(); // A  -  -  -  -  5  -  -  -  -  -  -  -
                               // E  X  X  X  X  X  X  X  X  X  X  X  X  
  } else if (et < 3500) {
    if (!intro_stages[3]) {
      intro_stages[3] = true;
      stop_all_notes();
    }
    // play an A7
    GUITAR_NOTES[0][5].play(); // E  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[1][5].play(); // B  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[2][6].play(); // G  -  -  -  -  -  -  -  8  -  -  -  -
    GUITAR_NOTES[3][5].play(); // D  -  -  -  -  -  -  7  -  -  -  -  -
    GUITAR_NOTES[4][7].play(); // A  -  -  -  -  -  -  -  -  9  -  -  -
    GUITAR_NOTES[5][5].play(); // E  -  -  -  -  -  -  7  -  -  -  -  - 
  } else if (et > 4500) {
    stop_all_notes();
  }
    
}

void setup() {
  size(800, 600);
  
  // NOTES stores SinOsc of each note. It's laid out linearly
  NOTES = new Notes(this);
  
  // GUITAR_NOTES lays notes out like they appear on the fretboard.
  // size is (6 strings) x (25 frets... index0 = open string, index1 = fret1 ...)
  GUITAR_NOTES = new Note[6][25];
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 25; j++) {
      GUITAR_NOTES[i][j] = NOTES.get_by_index(open_string_indicies[i] + j).clone();
    }
  }

}

void draw() {
  
  // here are some examples of playing a note, chord, etc.
  // remember:
  //  string0 -> high E
  //  string1 -> B
  //  string2 -> G
  //  string3 -> D
  //  string4 -> A
  //  string5 -> low E
  
  // PLAY AN D NOTE -> A STRING, 5TH FRET
  //GUITAR_NOTES[4][5].play();
  
  // PLAY A D MAJOR CHORD, BARRED AT THE 5TH FRET
  //GUITAR_NOTES[0][5].play(); // E  -  -  -  -  5  -  -  -  -  -  -  -
  //GUITAR_NOTES[1][7].play(); // B  -  -  -  -  -  -  7  -  -  -  -  - 
  //GUITAR_NOTES[2][7].play(); // G  -  -  -  -  -  -  7  -  -  -  -  -
  //GUITAR_NOTES[3][7].play(); // D  -  -  -  -  -  -  7  -  -  -  -  -
  //GUITAR_NOTES[4][5].play(); // A  -  -  -  -  5  -  -  -  -  -  -  -
  //                           // E  X  X  X  X  X  X  X  X  X  X  X  X
  
  // PLAY A B7 CHORD, BARRED AT 7TH FRET
  //GUITAR_NOTES[0][7].play(); // E  -  -  -  -  -  -  7  -  -  -  -  -
  //GUITAR_NOTES[1][7].play(); // B  -  -  -  -  -  -  7  -  -  -  -  -
  //GUITAR_NOTES[2][8].play(); // G  -  -  -  -  -  -  -  8  -  -  -  -
  //GUITAR_NOTES[3][7].play(); // D  -  -  -  -  -  -  7  -  -  -  -  -
  //GUITAR_NOTES[4][9].play(); // A  -  -  -  -  -  -  -  -  9  -  -  -
  //GUITAR_NOTES[5][7].play(); // E  -  -  -  -  -  -  7  -  -  -  -  - 
  
  background(230);
  
  // draw fretboard
  fill(255, 209, 193);
  noStroke();
  rect(STRING_X - 10, STRING_Y - 10, STRING_LENGTH + 20, FRETBOARD_HEIGHT + 20);
  
  // draw the frets
  strokeWeight(1);
  for (int i = 0; i < fret_size.length; i++) {
    stroke(0);
    line(STRING_X + fret_size[i], STRING_Y,
         STRING_X + fret_size[i], STRING_Y + STRING_PADDING*5);
    noStroke();
    fill(0);
    if (i == 3 || i == 5 || i == 7 || i == 9 || i == 15 || i == 17 || i == 19 || i == 21) {
      float df = fret_size[i] - fret_size[i - 1];
      ellipse(STRING_X + fret_size[i] - df/2, STRING_Y + FRETBOARD_HEIGHT/2, 7, 7);
    } else if (i == 12 || i == 24) {
      float df = fret_size[i] - fret_size[i - 1];
      ellipse(STRING_X + fret_size[i] - df/2, STRING_Y + 1.5*FRETBOARD_HEIGHT/5, 7, 7);  
      ellipse(STRING_X + fret_size[i] - df/2, STRING_Y + 3.5*FRETBOARD_HEIGHT/5, 7, 7);
    }
  }
 
  // draw the strings
  stroke(0);
  for (int i = 0; i < 6; i++) {
    strokeWeight(string_gauges[i]);
    if (GUITAR_NOTES[i][0].is_playing()) {
      stroke(GUITAR_NOTES[i][0].get_color());
    } else {
      stroke(0);
    }
    line(STRING_X, STRING_Y + i*STRING_PADDING,
         STRING_X + STRING_LENGTH, STRING_Y + i*STRING_PADDING);
  }
  
  // play intro if necessary
  int et = millis();
  if (et < 1500) {
    return;
  } else if (et < 4700) {
    play_intro(et);
  }
  
  // draw the notes being played. Ignore open strings, they are colored red
  // if being played (as opposed to a circle)
  ArrayList<Note> being_played = new ArrayList();
  
  for (int i = 0; i < 6; i++) {
    for (int j = 24; j >= 0; j--) {
      if (j > 0 && GUITAR_NOTES[i][j].is_playing()) {
        float df = fret_size[j] - fret_size[j - 1];
        fill(GUITAR_NOTES[i][j].get_color()); 
        noStroke();
        ellipse(STRING_X + fret_size[j] - df/2, STRING_Y + STRING_PADDING*i, 9, 9);
      }
      if (GUITAR_NOTES[i][j].is_playing()) {
        being_played.add(GUITAR_NOTES[i][j]);
        break;
      }
    }
  }
  
  // sort from lowest to highest note then print notes to screen
  Collections.sort(being_played);
  int list_x = STRING_X;
  fill(100, 100, 100);
  stroke(0);
  strokeWeight(2);
  rect(STRING_X - 10, STRING_Y + FRETBOARD_HEIGHT + 20, STRING_LENGTH + 20, 40);
  textSize(30);
  strokeWeight(10);
  stroke(0);
  boolean has_written[] = new boolean[49];
  for (Note n: being_played) {
    if (has_written[n.index]) {
      continue;
    }
    has_written[n.index] = true;
    fill(n.get_color());
    text(n.name, list_x, STRING_Y + FRETBOARD_HEIGHT + 50);
    list_x += 60;
  }
  
  if (hide_fretboard) {
    fill(255, 209, 193);
    noStroke();
    rect(STRING_X - 10, STRING_Y - 10, STRING_LENGTH + 20, FRETBOARD_HEIGHT + 20);
    textSize(36);
    fill(0);
    text("HIDDEN", STRING_X, STRING_Y + FRETBOARD_HEIGHT/2);
  }
  
  // list settings
  textSize(14);
  fill(0);
  text("CONTROLS: ", 50, 300);
  text("[Space] Start/Stop random note playing", 50, 325);
  text("[W] Increase note tempo", 50, 350);
  text("[S] Decrease note tempo", 50, 375);
  text("[F] Increase lowest note", 50, 400);
  text("[V] Decrease lowest note", 50, 425);
  text("[G] Increase highest note", 50, 450);
  text("[B] Decrease highest note", 50, 475);
  text("[H] Hide/Show fretboard", 50, 500);
  text("[N] Go to next random note", 50, 525);
  //text("[O] Toggle show octaves", 50, 450);
  
  textSize(12);
  int label_x = STRING_X + STRING_LENGTH + 20;
  text("Tempo: " + tempo + "ms/note", label_x, STRING_Y);
  text("Running: " + (is_running ? "Yes" : "No"), label_x, STRING_Y + 20);
  text("Lowest note: " + NOTES.get_by_index(bottom_range).name, label_x, STRING_Y + 40); 
  text("Highest note: " + NOTES.get_by_index(top_range).name, label_x, STRING_Y + 60); 
  
  textSize(12);
  text("r/Guitar Ear Trainer **Demo** by u/WilsonsDavid123", 20, 580);
  
  // time for the logic of the program
  
  if ((et - last_note_change > tempo || !has_played_note) && is_running) {
    has_played_note = true;
    last_note_change = et;
    stop_all_notes();
    int note_index = random.nextInt(top_range - bottom_range + 1) + bottom_range;
    current_note = NOTES.get_by_index(note_index);
    for (int i = 0; i < 6; i++) {
      for (int j = 24; j >= 0; j--) {
        if (GUITAR_NOTES[i][j].index == note_index) {
          GUITAR_NOTES[i][j].play();
        }
      }
    }
  }

}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    tempo /= 1.1;
  } else if (key == 's' || key == 'S') {
    tempo *= 1.1;
  } else if (key == 'h' || key == 'H') {
    hide_fretboard = !hide_fretboard;
  } else if (key == 'n' || key == 'N') {
    has_played_note = false;
  } else if (key == 'f' || key == 'F') {
    bottom_range++;
    if (bottom_range > top_range) {
      bottom_range = top_range;
    }
    if (bottom_range > 48) {
      bottom_range = 48;
    }
  } else if (key == 'v' || key == 'V') {
    bottom_range--;
    if (bottom_range < 0) {
      bottom_range = 0;
    }
  } else if (key == 'g' || key == 'G') {
    top_range++;
    if (top_range > 48) {
      top_range = 48;
    }
  } else if (key == 'b' || key == 'B') {
    top_range--;
    if (top_range < 0) {
      top_range = 0;
    } else if (top_range < bottom_range) {
      top_range = bottom_range;
    }
  } else if (key == 'o' || key == 'O') {
    show_octaves = !show_octaves;
  } else if (key == 32) {
    is_running = !is_running;
    if (is_running) {
      last_note_change = 0; // allow a note change right away
    } else {
      stop_all_notes();
    }
  }
}
