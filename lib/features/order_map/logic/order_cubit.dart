import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:products/features/order_map/model/order_model.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const Initial());
  void emitOrderDelivered(){
    _emitOrderState(
      ordersStates: OrdersStates.delivered,
      deliveryStates: DeliveryStates.arrived,
      delay: const Duration(seconds: 1),
    );
  }

  void trackOrderState() {

    _emitOrderState(
      ordersStates: OrdersStates.confirmed,
      deliveryStates: DeliveryStates.pickingOrders,
      delay: const Duration(seconds: 4),
    );

    _emitOrderState(
      ordersStates: OrdersStates.pickingItems,
      deliveryStates: DeliveryStates.stillInStore,
      delay: const Duration(seconds: 6),
    );

    _emitOrderState(
      ordersStates: OrdersStates.outForDelivery,
      deliveryStates: DeliveryStates.comingToYou,
      delay: const Duration(seconds: 8),
    );


  }

  void _emitOrderState({
    required OrdersStates ordersStates,
    required DeliveryStates deliveryStates,
    required Duration delay,
  }) {
    Future.delayed(delay, () {
      final orderModel = OrderModel(
        orderCode: Random().nextInt(9999).toString().padLeft(6, '0'),
        ordersState: ordersStates,
        deliveryStates: deliveryStates,
        deliveryTime: DateTime.now().add(const Duration(minutes: 30)),
      );
      emit(Loaded(orderModel));
    });
  }
}
