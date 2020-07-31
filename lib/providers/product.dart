import 'dart:convert';

import 'package:SHOP_APP/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, userId) async {
    final oldStatus = isFavorite;
    isFavorite = !oldStatus;
    notifyListeners();
    final url =
        'https://flutter-shop-e51de.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Some error occured');
    }
  }
}
