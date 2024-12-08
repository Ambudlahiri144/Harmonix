import 'package:flutter/material.dart';
import 'package:player/full_player.dart';

class MiniPlayer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  MiniPlayer({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenPlayer(
            imageUrl: imageUrl,
            songTitle: title,
            artistName: subtitle,
          ),
        ),
      );
    },
      child: Container(

      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFF172123),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamically sized album cover
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12), // Reduced spacing
          // Title and Subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRect(
                  child: AnimatedText(
                    text: "$title | $subtitle",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Adjusted font size for better readability
                    ),
                  ),
                ),

              ],
            ),
          ),
          // Playback Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_arrow, color: Colors.white, size: 18), // Reduced icon size
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),

            ],
          ),
        ],
      ),
    ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  AnimatedText({required this.text, required this.style});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.35, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat(reverse: true); // Loop animation back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _offsetAnimation,
        builder: (context, child) {
          return FractionalTranslation(
            translation: _offsetAnimation.value,
            child: Text(
              widget.text,
              style: widget.style,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          );
        },
      ),
    );
  }
}