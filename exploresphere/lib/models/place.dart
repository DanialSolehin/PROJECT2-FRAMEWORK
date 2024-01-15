

class Place {
  final String placeId;
  final String placeName;
  final String description;
  final String imagePath; // Change String to File
  // final String imagePath;
  final String special;
  final List<String> mostVisitedPlaces;
  final String funFact;

  Place({
    required this.placeId,
    required this.placeName,
    required this.description,
    required this.imagePath,
    required this.special,
    required this.mostVisitedPlaces,
    required this.funFact,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'description': description,
      'imagePath': imagePath, // Use the path property of File
      // 'imagePath': imagePath,
      'special': special,
      'mostVisitedPlaces': mostVisitedPlaces,
      'funFact': funFact,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      placeId: map['placeId'],
      placeName: map['placeName'],
      description: map['description'],
      imagePath: map['imagePath'],
      // imagePath: map['imagePath'],
      special: map['special'],
      mostVisitedPlaces: List<String>.from(map['mostVisitedPlaces']),
      funFact: map['funFact'],
    );
  }
}

String firebaseUrl =
    'travelmate-c4bd1-default-rtdb.asia-southeast1.firebasedatabase.app';
