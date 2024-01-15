import 'package:flutter/material.dart';
import 'package:exploresphere/models/place_screen.dart';

class KelantanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceScreen(
      placeName: 'Kelantan',
      description: 'Description for Kelantan...',
      imagePath: 'images/deng2.JPG',
      special: 'Kelantan is famous for its rich cultural heritage, traditional handicrafts, and unique local cuisine.',
      mostVisitedPlaces: ['Kota Bharu', 'Tumpat', 'Pantai Cahaya Bulan'],
      funFact: 'Did you know? Kelantan is known for its vibrant traditional performing arts like Mak Yong, Wayang Kulit, and Dikir Barat!',
    );
  }
}
