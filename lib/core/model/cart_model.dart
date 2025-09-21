import 'package:products/core/model/product_model.dart';

class CartModel {
  final ProductModel product;
   int totalItems;

  CartModel(
      {required this.product,required this.totalItems});

  get getTotalPrice =>
      product.price * totalItems;

}