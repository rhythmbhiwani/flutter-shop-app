import 'dart:convert';

import './cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String token;
  final String userId;
  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get items {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://flutter-shop-e51de.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-shop-e51de.firebaseio.com/orders/$userId.json?auth=$token';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    final newOrder = OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: timestamp,
      products: cartProducts,
    );
    try {} catch (error) {}
    _orders.insert(0, newOrder);
    notifyListeners();
  }
}
