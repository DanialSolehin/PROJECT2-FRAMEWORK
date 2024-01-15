import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class SabahScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Sabah',
      description: 'Description for Sabah...',
      imagePath: 'images/satu.jpg',
      special: 'Sabah is renowned for its biodiversity, stunning natural landscapes, and Mount Kinabalu.',
      mostVisitedPlaces: ['Kota Kinabalu', 'Sandakan', 'Tunku Abdul Rahman Marine Park'],
      funFact: 'Did you know? Sabah is home to Mount Kinabalu, the highest peak in Southeast Asia and a UNESCO World Heritage Site!',
    );
  }
}
