import 'package:flutter/material.dart';

import '../../models/user/rating_model.dart';

class RatingController {
  static const int maxRating = 5;
  static const int maxReviewLength = 300;

  final TextEditingController reviewController = TextEditingController();
  RatingReview value = const RatingReview(rating: 4, review: '');

  int get rating => value.rating;
  String get review => value.review;
  int get reviewLength => review.length;

  void updateRating(int rating) {
    value = value.copyWith(rating: rating.clamp(1, maxRating).toInt());
  }

  void updateReview(String review) {
    final trimmedReview = review.length > maxReviewLength
        ? review.substring(0, maxReviewLength)
        : review;
    value = value.copyWith(review: trimmedReview);
  }

  String get ratingLabel {
    switch (rating) {
      case 1:
        return 'Kurang';
      case 2:
        return 'Cukup';
      case 3:
        return 'Lumayan';
      case 4:
        return 'Bagus';
      case 5:
        return 'Sangat Bagus';
      default:
        return 'Pilih rating';
    }
  }

  bool get canSubmit => rating > 0 && review.trim().isNotEmpty;

  RatingReview submitReview() {
    return value;
  }

  void dispose() {
    reviewController.dispose();
  }
}
