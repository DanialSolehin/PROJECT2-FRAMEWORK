import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class PahangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Pahang',
      description: 'Description for Pahang...',
      imagePath: 'images/ting.jpg',
      special: 'Pahang is known for its lush rainforests, beautiful beaches, and the Taman Negara National Park.',
      mostVisitedPlaces: ['Cameron Highlands', 'Kuantan', 'Genting Highlands'],
      funFact: 'Did you know? Pahang is home to Taman Negara, one of the oldest rainforests in the world!',
    );
  }
}
