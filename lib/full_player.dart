import 'package:flutter/material.dart';
import 'dart:async';

import 'curved_bar.dart';

class FullScreenPlayer extends StatefulWidget {
  final String imageUrl;
  final String songTitle;
  final String artistName;

  FullScreenPlayer({
    required this.imageUrl,
    required this.songTitle,
    required this.artistName,
  });

  @override
  _FullScreenPlayerState createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> with TickerProviderStateMixin {
  double _progress = 0.0; // Slider progress (0.0 to 1.0)
  bool _isPlaying = false; // Play/pause state
  Duration _elapsedTime = Duration.zero; // Current elapsed time
  final Duration _songDuration = Duration(minutes: 4, seconds: 21); // Total song duration
  late AnimationController _rotationController; // Controller for rotating the image
  late AnimationController _progressController; // Controller for progress slider
  int _repeatMode = 0; // 0: No Repeat, 1: Repeat Once, 2: Repeat Twice
  int _repeatCount = 0; // Tracks repeat iterations for Repeat Twice mode

  @override
  void initState() {
    super.initState();

    // Initialize rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Full rotation every 8 seconds
    );

    // Initialize progress controller
    _progressController = AnimationController(
      vsync: this,
      duration: _songDuration,
    );

    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value; // Update progress
        _elapsedTime = _songDuration * _progress; // Update elapsed time
      });
    });

    // Listen for the end of the animation
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_repeatMode == 1) {
          // Repeat Once: Restart the song
          _progressController.forward(from: 0.0);
        } else if (_repeatMode == 2) {
          // Repeat Twice: Play the song twice
          if (_repeatCount < 1) {
            _repeatCount++;
            _progressController.forward(from: 0.0);
          } else {
            _repeatCount = 0; // Reset the repeat count
            _isPlaying = false;
            _rotationController.stop();
          }
        } else {
          // No Repeat: Stop the song
          setState(() {
            _isPlaying = false;
          });
          _rotationController.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // Toggle play/pause functionality
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;

      if (_isPlaying) {
        _rotationController.repeat(); // Start continuous rotation
        _progressController.forward(from: _progress); // Resume slider animation
      } else {
        _rotationController.stop(); // Pause rotation
        _progressController.stop(); // Pause slider animation
      }
    });
  }

  // Reset the song to 0:00 when Skip Previous is pressed
  void _resetSong() {
    setState(() {
      _progressController.reset();
      _progress = 0.0;
      _elapsedTime = Duration.zero;
      _isPlaying = false;
      _rotationController.stop();
    });
  }

  // Format Duration as MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1F26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.expand_more, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: RotationTransition(
                turns: _rotationController, // Attach rotation animation
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Circular image
                    image: DecorationImage(
                      image: AssetImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.songTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.artistName,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _progress = (details.localPosition.dx / MediaQuery.of(context).size.width)
                    .clamp(0.0, 1.0); // Update progress based on drag
                _elapsedTime = Duration(seconds: (_progress * _songDuration.inSeconds).round());
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  WavySlider(progress: _progress), // Pass the progress value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_elapsedTime), // Display elapsed time
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        _formatDuration(_songDuration), // Display total duration
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white, size: 32),
                onPressed: _resetSong,
              ),
              GestureDetector(
                onTap: _togglePlayPause,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white, size: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: _repeatMode == 0
                      ? Colors.white // No Repeat
                      : _repeatMode == 1
                      ? Colors.blue // Repeat Once
                      : Colors.green, // Repeat Twice
                ),
                onPressed: () {
                  setState(() {
                    // Cycle through repeat modes: 0 -> 1 -> 2 -> 0
                    _repeatMode = (_repeatMode + 1) % 3;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
