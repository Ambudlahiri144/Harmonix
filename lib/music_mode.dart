import 'package:flutter/material.dart';

class MusicModeScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) updateFavourites;

  MusicModeScreen({required this.updateFavourites});

  @override
  _MusicModeScreenState createState() => _MusicModeScreenState();
}

class _MusicModeScreenState extends State<MusicModeScreen> {
  final List<Map<String, dynamic>> _cards = [
    {
      "title": "Release Radar",
      "subtitle": " ",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
    },
    {
      "title": "Daily Mix 1",
      "subtitle": " ",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
    },
    {
      "title": "Daily Mix 2",
      "subtitle": "",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
    },
    {
      "title": "Daily Mix 3",
      "subtitle": "",
      "image": "https://via.placeholder.com/150",
      "isFavourite": false,
    },
  ];

  void _toggleFavourite(int index) {
    setState(() {
      _cards[index]['isFavourite'] = !_cards[index]['isFavourite'];
      widget.updateFavourites(
        _cards.where((card) => card['isFavourite']).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Music Library",
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
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Stack(
                      children: [
                        // Card Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey[800],
                                image: DecorationImage(
                                  image: NetworkImage(card['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              card['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              card['subtitle'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Love Icon
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: card['isFavourite'] ? Colors.red : Colors.white,
                              size: 24,
                            ),
                            onPressed: () => _toggleFavourite(index),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
