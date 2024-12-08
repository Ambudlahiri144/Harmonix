import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final double speed;
  final double volume;
  final VoidCallback toggleFullScreen;
  final VoidCallback seekForward;
  final VoidCallback seekBackward;
  final VoidCallback increaseSpeed;
  final VoidCallback decreaseSpeed;
  final VoidCallback togglePlayPause;

  const FullScreenVideoPlayer({
    Key? key,
    required this.videoController,
    required this.speed,
    required this.volume,
    required this.toggleFullScreen,
    required this.seekForward,
    required this.seekBackward,
    required this.increaseSpeed,
    required this.decreaseSpeed,
    required this.togglePlayPause,
  }) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  double _volume = 0.0;
  bool _isMenuVisible = false;

  @override
  void initState() {
    super.initState();
    _volume = widget.volume;
    widget.videoController.addListener(() {
      setState(() {}); // Update the UI when the video state changes
    });
  }

  @override
  void dispose() {
    widget.videoController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isMenuVisible = !_isMenuVisible;
          });
        },
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: VideoPlayer(widget.videoController),
              ),
            ),

            // Fullscreen and Menu Button (Top-Right)
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isMenuVisible = !_isMenuVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Icon(
                      _isMenuVisible ? Icons.close : Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: widget.toggleFullScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Menu for Video Controls
            if (_isMenuVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Playback Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: widget.seekBackward,
                            icon: const Icon(Icons.replay_10, color: Colors.white),
                            iconSize: 36,
                          ),
                          IconButton(
                            onPressed: widget.togglePlayPause,
                            icon: Icon(
                              widget.videoController.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                              size: 64,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.seekForward,
                            icon: const Icon(Icons.forward_10, color: Colors.white),
                            iconSize: 36,
                          ),
                        ],
                      ),

                      // Video Progress Slider
                      Slider(
                        value: widget.videoController.value.position.inMilliseconds
                            .toDouble()
                            .clamp(
                              0.0,
                              widget.videoController.value.duration.inMilliseconds.toDouble(),
                            ),
                        min: 0.0,
                        max: widget.videoController.value.duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          widget.videoController.seekTo(
                              Duration(milliseconds: value.toInt()));
                        },
                        thumbColor: Colors.green,
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.white30,
                      ),
                      Text(
                        '${widget.videoController.value.position.toString().split('.').first} / ${widget.videoController.value.duration.toString().split('.').first}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      // Speed Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: widget.decreaseSpeed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.speed, color: Colors.white),
                          ),
                          Text(
                            'Speed: ${widget.speed.toStringAsFixed(1)}x',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: widget.increaseSpeed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.speed, color: Colors.white),
                          ),
                        ],
                      ),

                      // Volume Slider
                      Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          widget.videoController.setVolume(value);
                        },
                        thumbColor: Colors.green,
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.white30,
                      ),
                      Text(
                        'Volume: ${(_volume * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
