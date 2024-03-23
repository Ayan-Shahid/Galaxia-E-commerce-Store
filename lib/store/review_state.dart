import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewItem {
  final String? id;
  final String? text;
  final String? productId;
  final String? userId;
  final double? rating;
  final List<dynamic>? likes;
  final DateTime date;

  const ReviewItem(
      {required this.id,
      required this.date,
      required this.likes,
      required this.text,
      required this.productId,
      required this.userId,
      required this.rating});

  static ReviewItem fromJson(Map<String, dynamic> json) {
    Timestamp date = json["Date"];
    return ReviewItem(
        id: json["ID"],
        date: date.toDate(),
        likes: List.from(json["Likes"]),
        text: json["Review"],
        productId: json["Product ID"],
        userId: json["User ID"],
        rating: json["Rating"]);
  }
}

class ReviewState {
  final List<ReviewItem> list;

  const ReviewState({this.list = const []});
}

enum ReviewStateActions { remove, add }

class ReviewStateAction {
  final ReviewStateActions type;
  final dynamic payload;

  const ReviewStateAction({required this.type, required this.payload});
}
