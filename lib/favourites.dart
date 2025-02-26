import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favourites;

  FavouritesPage({required this.favourites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Favourites"),
      ),
      body: favourites.isEmpty
          ? Center(
              child: Text(
                "No Favourites yet!",
                style: TextStyle(color: Colors.white),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final item = favourites[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        item["image"]!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item["title"]!,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
