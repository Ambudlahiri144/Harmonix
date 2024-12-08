import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'miniplayer.dart';
import 'bottom_navigation.dart';
import 'account_section.dart';
import 'music_mode.dart';
import 'video_mode.dart';
import 'favourites.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isMusicMode = true;
  late AnimationController _lottieController;
  List<Map<String, dynamic>> _favourites = [];

  // Sample data for the MiniPlayer
  String currentPlayingImage = "assets/cd.png";
  String currentPlayingTitle = "Sample Song";
  String currentPlayingSubtitle = "Sample Artist";

  void _updateFavourites(List<Map<String, dynamic>> favourites) {
    setState(() {
      _favourites = favourites;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning ';
    } else if (hour < 17) {
      return 'Good afternoon ';
    } else {
      return 'Good evening ';
    }
  }

  String? getLottieAnimationPath() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'assets/day.json'; // Use day.json for morning
    } else if (hour >= 17) {
      return 'assets/night.json'; // Use night.json for evening
    }
    return null;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _lottieController.stop();
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lottiePath = getLottieAnimationPath();

    // Define _musicScreens dynamically so it reflects changes in _favourites
    final List<Widget> _musicScreens = [
      MusicModeScreen(updateFavourites: _updateFavourites),
      FavouritesPage(favourites: _favourites),
      AccountScreen(),
    ];

    // Video screens remain unchanged
    final List<Widget> _videoScreens = [
      VideoLibraryScreen(),
      Center(child: Text('Trending', style: TextStyle(color: Colors.white))),
      AccountScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          if (lottiePath != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Lottie.asset(
                lottiePath, // Load the correct Lottie animation based on time
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward();
                },
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 100,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getGreeting(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: isMusicMode
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isMusicMode = true;
                                      _selectedIndex = 0;
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.music_note,
                                      color: isMusicMode
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isMusicMode = false;
                                      _selectedIndex = 0;
                                    });
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.videocam,
                                      color: isMusicMode
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isMusicMode
                    ? _musicScreens[_selectedIndex]
                    : _videoScreens[_selectedIndex],
              ),
            ],
          ),
          if (isMusicMode)
            Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(
                imageUrl: currentPlayingImage,
                title: currentPlayingTitle,
                subtitle: currentPlayingSubtitle,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
