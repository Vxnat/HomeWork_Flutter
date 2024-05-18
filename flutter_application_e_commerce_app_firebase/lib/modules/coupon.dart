// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  late String coupon;
  late double price;
  late List<dynamic> isUse;
  Coupon({
    required this.coupon,
    required this.price,
    required this.isUse,
  });

  factory Coupon.fromDocument(QueryDocumentSnapshot doc) {
    return Coupon(
      coupon: doc['coupon'] ?? '',
      price: (doc['price'] ?? 0.0).toDouble(),
      isUse: doc['is_use'] ?? [],
    );
  }

  Coupon.fromJson(Map<String, dynamic> json) {
    coupon = json['coupon'];
    isUse = json['is_use'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coupon'] = coupon;
    data['is_use'] = isUse;
    data['price'] = price;
    return data;
  }
}
