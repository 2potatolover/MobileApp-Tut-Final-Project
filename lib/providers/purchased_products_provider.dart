
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class PurchasedProductsProvider with ChangeNotifier {
  final Set<String> _purchasedProductIds = {};

  Set<String> get purchasedProductIds => _purchasedProductIds;

  void addPurchasedProducts(Map<String, CartItem> cartItems) {
    for (var item in cartItems.values) {
      _purchasedProductIds.add(item.product.id);
    }
    notifyListeners();
  }

  bool hasPurchased(String productId) {
    return _purchasedProductIds.contains(productId);
  }
}
