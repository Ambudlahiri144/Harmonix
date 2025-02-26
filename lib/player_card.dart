import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  PlaylistCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
