import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/order_model.dart';
part 'order_state.freezed.dart';


@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = Initial;
  const factory OrderState.loaded(OrderModel order) = Loaded;
  const factory OrderState.error(String message) = Error;
}
