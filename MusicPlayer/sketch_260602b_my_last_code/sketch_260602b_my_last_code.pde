import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer[] songs;
FFT fft;

int currentSong = -1;
float volume = 0;

// SONGS
String[] labels = {
  "Central Cee - Band4Band",
  "Track 2",
  "Track 3"
};

String[] files = {
  "band4band.mp3",
  "track2.mp3",
  "track3.mp3"
};

// BUTTONS
int playX = 60;
int pauseX = 190;
int backX = 320;
int nextX = 450;

int bw = 110;
int bh = 45;
int barY = 430;

// SONG BUTTON
int ccX = 40;
int ccY = 70;
int ccW = 280;
int ccH = 60;

void setup() {

  size(900, 550);

  minim = new Minim(this);

  songs = new AudioPlayer[files.length];

  for (int i = 0; i < files.length; i++) {

    songs[i] = minim.loadFile(files[i]);

    if (songs[i] == null) {
      println("FAILED: " + files[i]);
    } else {
      println("LOADED: " + files[i]);
    }
  }

  textAlign(CENTER, CENTER);
  rectMode(CORNER);
}

void draw() {

  drawGradientBackground();

  drawTitle();

  drawAlbumArt();

  drawBandButton();

  drawVisualizer();

  drawProgressBar();

  drawNowPlaying();

  drawControls();

  checkAutoNext();
}

void drawGradientBackground() {

  for (int y = 0; y < height; y++) {

    stroke(
      map(y, 0, height, 10, 0),
      map(y, 0, height, 40, 0),
      map(y, 0, height, 120, 20)
    );

    line(0, y, width, y);
  }

  noStroke();
}

void drawTitle() {

  fill(255);
  textSize(28);
  text("MUSIC PLAYER APP", width/2, 30);
}

void drawAlbumArt() {

  fill(30);
  rect(620, 70, 220, 220, 20);

  fill(255);
  textSize(22);

  if (currentSong == 0) {
    text("BAND4BAND", 730, 150);
    textSize(16);
    text("CENTRAL CEE", 730, 190);
  } else {
    text("ALBUM ART", 730, 180);
  }
}

void drawBandButton() {

  boolean hover =
    mouseX > ccX &&
    mouseX < ccX + ccW &&
    mouseY > ccY &&
    mouseY < ccY + ccH;

  if (currentSong == 0)
    fill(0, 200, 120);
  else if (hover)
    fill(70, 130, 255);
  else
    fill(50, 60, 120);

  rect(ccX, ccY, ccW, ccH, 12);

  fill(255);
  textSize(16);

  text(
    "CENTRAL CEE - BAND4BAND",
    ccX + ccW/2,
    ccY + ccH/2
  );
}

void drawControls() {

  drawButton(playX, barY, bw, bh, "PLAY");
  drawButton(pauseX, barY, bw, bh, "PAUSE");
  drawButton(backX, barY, bw, bh, "BACK");
  drawButton(nextX, barY, bw, bh, "NEXT");
}

void drawButton(
  int x,
  int y,
  int w,
  int h,
  String label
) {

  boolean hover =
    mouseX > x &&
    mouseX < x + w &&
    mouseY > y &&
    mouseY < y + h;

  if (hover)
    fill(80, 140, 255);
  else
    fill(50);

  rect(x, y, w, h, 10);

  fill(255);

  text(
    label,
    x + w/2,
    y + h/2
  );
}

void drawVisualizer() {

  if (currentSong == -1)
    return;

  if (songs[currentSong] == null)
    return;

  AudioPlayer s = songs[currentSong];

  fft = new FFT(
    s.bufferSize(),
    s.sampleRate()
  );

  fft.forward(s.mix);

  int bars = 90;

  float w = width/(float)bars;

  for (int i = 0; i < bars; i++) {

    int index =
      (int)map(
      i,
      0,
      bars,
      0,
      fft.specSize()-1
      );

    float h =
      fft.getBand(index) * 8;

    fill(
      map(i, 0, bars, 0, 255),
      255-map(i, 0, bars, 0, 255),
      255
    );

    rect(
      i*w,
      350-h,
      w-2,
      h
    );
  }
}

void drawProgressBar() {

  if (currentSong == -1)
    return;

  AudioPlayer s =
    songs[currentSong];

  float progress =
    map(
    s.position(),
    0,
    s.length(),
    0,
    600
    );

  fill(60);
  rect(150, 390, 600, 12);

  fill(0, 200, 255);
  rect(
    150,
    390,
    progress,
    12
  );

  fill(255);

  int currentSec =
    s.position()/1000;

  int totalSec =
    s.length()/1000;

  text(
    currentSec +
    "s / " +
    totalSec +
    "s",
    width/2,
    375
  );
}

void drawNowPlaying() {

  fill(255);

  if (currentSong == -1) {

    textSize(18);

    text(
      "No song selected",
      width/2,
      330
    );
  } else {

    textSize(18);

    text(
      "Now Playing: " +
      labels[currentSong],
      width/2,
      330
    );
  }
}

void mousePressed() {

  if (
    mouseX > ccX &&
    mouseX < ccX + ccW &&
    mouseY > ccY &&
    mouseY < ccY + ccH
    ) {

    playSong(0);
  }

  if (hit(playX)) {

    if (currentSong == -1) {
      playSong(0);
    } else {

      if (!songs[currentSong].isPlaying()) {
        songs[currentSong].play();
      }
    }
  }

  if (
    hit(pauseX) &&
    currentSong != -1
    ) {

    songs[currentSong].pause();
  }

  if (hit(backX)) {
    previousSong();
  }

  if (hit(nextX)) {
    nextSong();
  }
}

boolean hit(int x) {

  return
    mouseX > x &&
    mouseX < x+bw &&
    mouseY > barY &&
    mouseY < barY+bh;
}

void keyPressed() {

  if (key == ' ') {

    if (currentSong != -1) {

      if (songs[currentSong].isPlaying())
        songs[currentSong].pause();
      else
        songs[currentSong].play();
    }
  }

  if (keyCode == RIGHT)
    nextSong();

  if (keyCode == LEFT)
    previousSong();

  if (key == '+') {

    volume += 2;

    for (AudioPlayer s : songs) {

      if (s != null)
        s.setGain(volume);
    }
  }

  if (key == '-') {

    volume -= 2;

    for (AudioPlayer s : songs) {

      if (s != null)
        s.setGain(volume);
    }
  }
}

void playSong(int index) {

  if (
    index < 0 ||
    index >= songs.length
    )
    return;

  if (songs[index] == null)
    return;

  stopAll();

  currentSong = index;

  songs[currentSong].rewind();
  songs[currentSong].play();
}

void stopAll() {

  for (int i = 0; i < songs.length; i++) {

    if (songs[i] != null) {

      songs[i].pause();
      songs[i].rewind();
    }
  }
}

void nextSong() {

  if (currentSong == -1)
    playSong(0);
  else
    playSong(
      (currentSong + 1)
      % songs.length
      );
}

void previousSong() {

  if (currentSong == -1)
    playSong(0);
  else
    playSong(
      (currentSong - 1 + songs.length)
      % songs.length
      );
}

void checkAutoNext() {

  if (currentSong == -1)
    return;

  if (
    !songs[currentSong].isPlaying() &&
    songs[currentSong].position() >
    songs[currentSong].length()-100
    ) {

    nextSong();
  }
}

void stop() {

  for (int i = 0; i < songs.length; i++) {

    if (songs[i] != null) {
      songs[i].close();
    }
  }

  minim.stop();

  super.stop();
}
