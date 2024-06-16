# Get all MP4 file names in the current directory
$mp4Files = Get-ChildItem -Path . -Filter *.mp4 | Select-Object -ExpandProperty Name

# Create the HTML content
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Video Player</title>
    <style>
        video {
            max-width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
    <div id="videoContainer"></div>
    <script>
        const videoContainer = document.getElementById('videoContainer');
        const videoFiles = [
            $(foreach ($file in $mp4Files) { "`"$file`"," })
        ];

        let currentVideoIndex = 0;

        function playNextVideo() {
            if (currentVideoIndex >= videoFiles.length) {
                return; // No more videos to play
            }

            const videoElement = document.createElement('video');
            videoElement.src = videoFiles[currentVideoIndex];
            videoElement.controls = true;
	    videoElement.type = "video/mp4";

            const playPromise = videoElement.play();

            if (playPromise !== undefined) {
                playPromise
                    .then(() => {
                        // Automatic playback started successfully
                        videoContainer.innerHTML = '';
                        videoContainer.appendChild(videoElement);
                    })
                    .catch((error) => {
                        // Automatic playback failed
                        console.error('Automatic playback failed:', error);
                        handlePlaybackFailure();
                    });
            } else {
                // Browser doesn't support Promise-based play()
                videoContainer.innerHTML = '';
                videoContainer.appendChild(videoElement);
                videoElement.play();
            }

            videoElement.addEventListener('error', handlePlaybackFailure);
            videoElement.addEventListener('ended', () => {
                currentVideoIndex++;
                playNextVideo();
            });
        }

        function handlePlaybackFailure() {
            currentVideoIndex++;
            playNextVideo();
        }

        playNextVideo();

    </script>
</body>
</html>
"@

# Save the HTML content to a file
$htmlContent | Out-File "video-player.html"

Write-Host "HTML file created: video-player.html"