import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class KedahScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Kedah',
      description: 'Description for Kedah...',
      imagePath: 'images/padi.jpg',
      special: 'Kedah is known for its ancient archaeological sites, beautiful islands, and traditional culture.',
      mostVisitedPlaces: ['Langkawi', 'Alor Setar', 'Pulau Payar'],
      funFact: 'Did you know? Kedah is home to Langkawi, a stunning archipelago with 99 islands known for its beautiful beaches and clear waters!',
    );
  }
}
