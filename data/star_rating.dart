class FeedbackData {
  final String placeName;
  final double rating;

  FeedbackData({required this.placeName, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'rating': rating,
    };
  }
}
