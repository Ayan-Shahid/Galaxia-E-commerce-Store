import 'package:cloud_firestore/cloud_firestore.dart';

class GalaxiaProduct {
  String? id;
  String? name;
  double? price;
  String? description;
  String? category;
  List<String>? colors;
  List<String>? images;
  int? reviewCount;
  int? soldCount;
  List<String>? sizes;
  double? averageRating;
  DateTime? dateCreated;

  GalaxiaProduct(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.category,
      this.colors,
      this.images,
      this.reviewCount,
      this.soldCount,
      this.sizes,
      this.averageRating,
      this.dateCreated});

  static GalaxiaProduct fromJson(Map<String, dynamic> json) {
    dynamic price = json["Price"];

    dynamic rating = json["Rating"];

    Timestamp dateCreated = json["Date Created"];

    return GalaxiaProduct(
        id: json["objectID"],
        name: json["Name"],
        price: price is int ? price.toDouble() : price,
        category: json["Category"],
        soldCount: json["Sold Count"],
        description: json["Description"],
        reviewCount: json["Review Count"],
        sizes: List.from(json["Sizes"]),
        colors: List.from(json["Colors"]),
        averageRating: rating is int ? rating.toDouble() : rating,
        dateCreated: dateCreated.toDate(),
        images: List.from(json["Images"]));
  }

  static GalaxiaProduct fromAlgoliaJson(Map<String, dynamic> json) {
    dynamic price = json["Price"];

    dynamic rating = json["Rating"];

    String dateCreated = json["Date Created"];

    return GalaxiaProduct(
        id: json["objectID"],
        name: json["Name"],
        price: price is int ? price.toDouble() : price,
        category: json["Category"],
        soldCount: json["Sold Count"],
        description: json["Description"],
        reviewCount: json["Review Count"],
        sizes: List.from(json["Sizes"]),
        colors: List.from(json["Colors"]),
        averageRating: rating is int ? rating.toDouble() : rating,
        dateCreated: DateTime.tryParse(dateCreated),
        images: List.from(json["Images"]));
  }
}

class GalaxiaCartProduct {
  String? id;

  String? uid;
  String? image;
  String? name;
  double? price;
  String? size;
  String? color;
  int? quantity;
  GalaxiaCartProduct(
      {required this.id,
      required this.uid,
      required this.image,
      required this.name,
      required this.price,
      required this.size,
      required this.color,
      required this.quantity});

  @override
  bool operator ==(Object other) {
    if (other is GalaxiaCartProduct &&
        other.id == id &&
        other.color == color &&
        other.size == size &&
        other.image == image &&
        other.price == price &&
        other.name == name) {
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        uid.hashCode ^
        price.hashCode ^
        color.hashCode ^
        image.hashCode ^
        size.hashCode;
  }

  static GalaxiaCartProduct fromJson(Map<String, dynamic> json) {
    dynamic price = json["Price"];

    return GalaxiaCartProduct(
        id: json["Product ID"],
        uid: json["ID"],
        quantity: json["Quantity"],
        name: json["Name"],
        price: price is int ? price.toDouble() : price,
        size: json["Size"],
        color: json["Color"],
        image: json["Image"]);
  }
}
