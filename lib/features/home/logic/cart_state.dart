import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/model/cart_model.dart';

part 'cart_state.freezed.dart';
@freezed
class CartState with _$CartState {
  const factory CartState.initial() = Initial;
  const factory CartState.loaded(List<CartModel> items) = Loaded;
  const factory CartState.error(String message) = Error;

}
