import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class TerengganuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Terengganu',
      description: 'Description for Terengganu...',
      imagePath: 'images/kristal.jpg',
      special: 'Terengganu is known for its beautiful beaches and islands, rich culture, and delicious local cuisine.',
      mostVisitedPlaces: ['Redang Island', 'Perhentian Islands', 'Kuala Terengganu'],
      funFact: 'Did you know? Terengganu is home to the beautiful Perhentian Islands, famous for their crystal-clear waters and stunning marine life!',
    );
  }
}
