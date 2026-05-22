/* =====================================
   FULL MUSIC APP FINAL PROJECT
   Includes:
   - Central Cee BAND button
   - Play / Pause / Next / Back
   - Visualizer
   ===================================== */

import ddf.minim.*;
import ddf.minim.analysis.*;

// ===== AUDIO =====
Minim minim;
AudioPlayer[] songs;
FFT fft;

int currentSong = -1;

// ===== SONG DATA =====
String[] labels = {
  "Central Cee",   // BAND 1
  "Band 2",
  "Band 3"
};

String[] files = {
  "centralcee.mp3",
  "track2.mp3",
  "track3.mp3"
};

// ===== BUTTONS =====
int playX = 90;
int pauseX = 220;
int backX = 350;
int nextX = 480;
int barY = 420;
int bw = 110;
int bh = 40;

// ===== CENTRAL CEE BAND BUTTON =====
int ccX = 50;
int ccY = 70;
int ccW = 200;
int ccH = 60;

// =================================================

void setup() {
  size(800, 500);

  minim = new Minim(this);

  songs = new AudioPlayer[files.length];

  for (int i = 0; i < files.length; i++) {
    songs[i] = minim.loadFile(files[i]);
  }

  textAlign(CENTER, CENTER);
  textSize(16);
}

// =================================================

void draw() {
  background(15);

  drawTitle();
  drawBandButton();      // ⭐ CENTRAL CEE BAND
  drawVisualizer();
  drawNowPlaying();
  drawControls();
}

// =================================================
// TITLE
void drawTitle() {
  fill(255);
  textSize(22);
  text("🎧 MUSIC PLAYER APP", width/2, 25);
  textSize(16);
}

// =================================================
// ⭐ CENTRAL CEE BAND BUTTON
void drawBandButton() {

  boolean hover = mouseX > ccX && mouseX < ccX + ccW &&
                  mouseY > ccY && mouseY < ccY + ccH;

  if (currentSong == 0) {
    fill(0, 200, 120); // active green
  } else if (hover) {
    fill(80, 140, 255); // hover blue
  } else {
    fill(40, 60, 120); // idle
  }

  rect(ccX, ccY, ccW, ccH, 12);

  fill(255);
  text("🎤 Central Cee BAND", ccX + ccW/2, ccY + ccH/2);
}

// =================================================
// CONTROLS
void drawControls() {

  drawButton(playX, barY, bw, bh, "PLAY");
  drawButton(pauseX, barY, bw, bh, "PAUSE");
  drawButton(backX, barY, bw, bh, "BACK");
  drawButton(nextX, barY, bw, bh, "NEXT");
}

// =================================================
// BUTTON DRAW
void drawButton(int x, int y, int w, int h, String label) {

  boolean hover = mouseX > x && mouseX < x + w &&
                  mouseY > y && mouseY < y + h;

  if (hover) fill(80, 140, 255);
  else fill(50);

  rect(x, y, w, h, 8);

  fill(255);
  text(label, x + w/2, y + h/2);
}

// =================================================
// VISUALIZER
void drawVisualizer() {

  if (currentSong == -1) return;

  AudioPlayer s = songs[currentSong];

  fft = new FFT(s.bufferSize(), s.sampleRate());
  fft.forward(s.mix);

  int bars = 80;
  float w = width / (float)bars;

  for (int i = 0; i < bars; i++) {

    int index = (int)map(i, 0, bars, 0, fft.specSize()-1);
    float h = fft.getBand(index) * 5;

    fill(100, 200, 255);

    rect(i * w, height - 120 - h, w - 2, h);
  }
}

// =================================================
// NOW PLAYING
void drawNowPlaying() {

  fill(255);

  if (currentSong == -1) {
    text("No song selected", width/2, height - 140);
  } else {
    text("Now Playing: " + labels[currentSong], width/2, height - 140);
  }
}

// =================================================
// CLICK SYSTEM
void mousePressed() {

  // ⭐ CENTRAL CEE BAND CLICK
  if (mouseX > ccX && mouseX < ccX + ccW &&
      mouseY > ccY && mouseY < ccY + ccH) {

    playSong(0); // Central Cee = index 0
  }

  // PLAY
  if (hit(playX)) {
    if (currentSong != -1) songs[currentSong].play();
  }

  // PAUSE
  if (hit(pauseX)) {
    if (currentSong != -1) songs[currentSong].pause();
  }

  // BACK
  if (hit(backX)) {
    previousSong();
  }

  // NEXT
  if (hit(nextX)) {
    nextSong();
  }
}

// =================================================
// HIT DETECTION
boolean hit(int x) {
  return mouseX > x && mouseX < x + bw &&
         mouseY > barY && mouseY < barY + bh;
}

// =================================================
// PLAY SONG
void playSong(int index) {

  stopAll();

  currentSong = index;
  songs[currentSong].rewind();
  songs[currentSong].play();
}

// =================================================
// STOP ALL
void stopAll() {
  for (int i = 0; i < songs.length; i++) {
    songs[i].pause();
    songs[i].rewind();
  }
}

// =================================================
// NEXT
void nextSong() {
  if (currentSong == -1) {
    playSong(0);
  } else {
    playSong((currentSong + 1) % songs.length);
  }
}

// =================================================
// BACK
void previousSong() {
  if (currentSong == -1) {
    playSong(0);
  } else {
    playSong((currentSong - 1 + songs.length) % songs.length);
  }
}
