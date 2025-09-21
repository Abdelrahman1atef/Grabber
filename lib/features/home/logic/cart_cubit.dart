import '../../../core/model/cart_model.dart';
import '../../../core/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final List<CartModel> _items = [];

  CartCubit() : super(Initial());

  // Expose read-only cart
  List<CartModel> get items => List.unmodifiable(_items);

  // safe nullable find
  CartModel? findItemInCart(ProductModel item) {
    final idx = _items.indexWhere((e) => e.product == item);
    return idx == -1 ? null : _items[idx];
  }

  /// ✅ Check if item exists
  bool isInCart(ProductModel item) => findItemInCart(item) != null;

  void addItem(ProductModel product, [int qty = 1]) {
    final existingIndex = _items.indexWhere((e) => e.product == product);

    if (existingIndex != -1) {
      // replace with a new CartModel (immutability)
      final updatedItem = CartModel(
        product: _items[existingIndex].product,
        totalItems: _items[existingIndex].totalItems + qty,
      );
      _items[existingIndex] = updatedItem;
    } else {
      _items.add(CartModel(product: product, totalItems: qty));
    }

    emit(CartState.loaded(List.from(_items))); // emit new list copy
  }

  void removeItem(ProductModel product, [int qty = 1]) {
    final existingIndex = _items.indexWhere((e) => e.product == product);
    if (existingIndex == -1) return;

    final existing = _items[existingIndex];
    if (existing.totalItems > qty) {
      // replace with new CartModel instead of mutating
      final updatedItem = CartModel(
        product: existing.product,
        totalItems: existing.totalItems - qty,
      );
      _items[existingIndex] = updatedItem;
    } else {
      _items.removeAt(existingIndex);
    }

    emit(CartState.loaded(List.from(_items)));
  }


  /// ✅ Completely delete item
  void deleteItem(ProductModel product) {
    _items.removeWhere((e) => e.product == product);
    emit(CartState.loaded(List.from(_items)));
  }
}
