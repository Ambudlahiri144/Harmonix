import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'full_video_player.dart';

class MiniVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoController;
  final String videoTitle;
  final String thumbnailUrl;
  final VoidCallback onClose;
  final VoidCallback onPlayPause;
  final VoidCallback onForward;
  final VoidCallback onRewind;

  const MiniVideoPlayer({
    Key? key,
    required this.videoController,
    required this.videoTitle,
    required this.thumbnailUrl,
    required this.onClose,
    required this.onPlayPause,
    required this.onForward,
    required this.onRewind,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          // Navigate to FullScreenVideoPlayer on tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenVideoPlayer(
                videoController: videoController,
                speed: 1.0,
                volume: videoController.value.volume,
                toggleFullScreen: () => Navigator.pop(context),
                seekForward: onForward,
                seekBackward: onRewind,
                increaseSpeed: () {
                  double newSpeed =
                      (videoController.value.playbackSpeed + 0.25).clamp(0.25, 2.0);
                  videoController.setPlaybackSpeed(newSpeed);
                },
                decreaseSpeed: () {
                  double newSpeed =
                      (videoController.value.playbackSpeed - 0.25).clamp(0.25, 2.0);
                  videoController.setPlaybackSpeed(newSpeed);
                },
                togglePlayPause: onPlayPause,
              ),
            ),
          );
        },
        child: Container(
          height: 100, // Height of the mini-player
          width: double.infinity, // Full width at the bottom
          color: Colors.black,
          child: Row(
            children: [
              // Video Thumbnail
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl), // Dynamic thumbnail
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Title and Controls
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      videoTitle, // Dynamic title
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onRewind,
                          icon: const Icon(Icons.replay_10, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: onPlayPause,
                          icon: Icon(
                            videoController.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: onForward,
                          icon: const Icon(Icons.forward_10, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Close Button
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
