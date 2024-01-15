import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class JohorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Johor',
      description: 'Description for Johor...',
      imagePath: 'images/deng1.jpg',
      special:
          'Johor is famous for its theme parks, diverse culinary scene, and historical landmarks.',
      mostVisitedPlaces: [
        'Legoland Malaysia Resort',
        'Desaru Coast Adventure Waterpark',
        'Sultan Abu Bakar State Mosque'
      ],
      funFact:
          'Did you know? Johor is home to Legoland Malaysia Resort, the first Legoland theme park in Asia!',
    );
  }
}
