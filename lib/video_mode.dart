import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'mini_video_player.dart';

class VideoLibraryScreen extends StatefulWidget {
  @override
  _VideoLibraryScreenState createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  final List<Map<String, dynamic>> _cards = [
    {
      "title": "Video1",
      "subtitle": " ",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
      "url": "https://samplelib.com/lib/preview/mp4/sample-20s.mp4",
    },
    {
      "title": "Video2",
      "subtitle": " ",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
      "url": "https://samplelib.com/lib/preview/mp4/sample-10s.mp4",
    },
    {
      "title": "Video3",
      "subtitle": "",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
      "url": "https://samplelib.com/lib/preview/mp4/sample-15s.mp4",
    },
    {
      "title": "Video4",
      "subtitle": " ",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
      "url": "https://samplelib.com/lib/preview/mp4/sample-20s.mp4",
    },
  ];

  late VideoPlayerController _videoController;
  bool isMiniPlayerVisible = false;
  String currentVideoTitle = "Video1";
  String currentThumbnailUrl = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
      _cards[0]['url'],
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _showMiniPlayer(String title, String thumbnailUrl, String videoUrl) {
    setState(() {
      currentVideoTitle = title;
      currentThumbnailUrl = thumbnailUrl;

      _videoController.dispose(); // Dispose the old controller
      _videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {
            isMiniPlayerVisible = true;
            _videoController.play(); // Automatically play video in mini-player
          });
        }).catchError((error) {
          print("VideoPlayerController initialization failed: $error");
          // Optionally show a Snackbar or dialog to notify the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load video: $error')),
          );
        });
    });
  }

  void _hideMiniPlayer() {
    setState(() {
      isMiniPlayerVisible = false;
      _videoController.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Your Video Library",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return GestureDetector(
                        onTap: () {
                          _showMiniPlayer(
                            card['title'],
                            card['image'],
                            card['url'],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(card['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                card['title'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isMiniPlayerVisible)
            MiniVideoPlayer(
              videoController: _videoController,
              videoTitle: currentVideoTitle,
              thumbnailUrl: currentThumbnailUrl,
              onClose: _hideMiniPlayer,
              onPlayPause: () {
                if (_videoController.value.isPlaying) {
                  _videoController.pause();
                } else {
                  _videoController.play();
                }
                setState(() {});
              },
              onForward: () {
                _videoController.seekTo(
                  _videoController.value.position + Duration(seconds: 10),
                );
              },
              onRewind: () {
                _videoController.seekTo(
                  _videoController.value.position - Duration(seconds: 10),
                );
              },
            ),
        ],
      ),
    );
  }
}
