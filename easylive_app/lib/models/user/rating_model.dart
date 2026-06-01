class RatingReview {
  final int rating;
  final String review;

  const RatingReview({
    required this.rating,
    required this.review,
  });

  RatingReview copyWith({
    int? rating,
    String? review,
  }) {
    return RatingReview(
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}
