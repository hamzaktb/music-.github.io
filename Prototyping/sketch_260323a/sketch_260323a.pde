<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Simple Music Player</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #121212;
      color: white;
      text-align: center;
      margin-top: 100px;
    }
    .player {
      background: #1e1e1e;
      padding: 20px;
      border-radius: 15px;
      display: inline-block;
    }
    button {
      background: #1db954;
      border: none;
      padding: 10px 15px;
      margin: 5px;
      color: white;
      border-radius: 8px;
      cursor: pointer;
      font-size: 16px;
    }
    button:hover {
      background: #17a74a;
    }
    input[type="range"] {
      width: 100%;
    }
  </style>
</head>
<body>

  <div class="player">
    <h2>🎶 My Music Player</h2>
    
    <audio id="audio" src="your-song.mp3"></audio>

    <div>
      <button onclick="playMusic()">▶ Play</button>
      <button onclick="pauseMusic()">⏸ Pause</button>
    </div>

    <br>

    <input type="range" id="seekBar" value="0">

  </div>

  <script>
    const audio = document.getElementById("audio");
    const seekBar = document.getElementById("seekBar");

    function playMusic() {
      audio.play();
    }

    function pauseMusic() {
      audio.pause();
    }

    // Update seek bar
    audio.addEventListener("timeupdate", () => {
      seekBar.value = (audio.currentTime / audio.duration) * 100;
    });

    // Seek functionality
    seekBar.addEventListener("input", () => {
      audio.currentTime = (seekBar.value / 100) * audio.duration;
    });
  </script>

</body>
</html>
