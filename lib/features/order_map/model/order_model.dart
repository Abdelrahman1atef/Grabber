import 'package:intl/intl.dart';

import '../../../gen/assets.gen.dart';

enum OrdersStates { confirmed, pickingItems, outForDelivery, delivered }

enum DeliveryStates { pickingOrders, stillInStore, comingToYou, arrived }

class OrderModel {
  final String? orderCode;
  final String ordersStatesMassage;
  final OrdersStates ordersState;
  final DeliveryStates deliveryStates;

  final DateTime deliveryTime;

  OrderModel({
    this.orderCode="",
    this.ordersStatesMassage ="",
    required this.ordersState,
    required this.deliveryStates,
    required this.deliveryTime,
  });

  String get formattedDeliveryTime => DateFormat('HH:mm').format(deliveryTime);

  String getOrderState() {
    switch (ordersState) {
      case OrdersStates.confirmed:
        return "Confirmed";
      case OrdersStates.pickingItems:
        return "Picking items";
      case OrdersStates.outForDelivery:
        return "Out for delivery";
      case OrdersStates.delivered:
        return "Delivered";
      }
  }

  String getSubOrderState() {
    switch (ordersState) {
      case OrdersStates.confirmed:
        return Assets.orderState.icon1.path;
      case OrdersStates.pickingItems:
        return Assets.orderState.icon1.path;
      case OrdersStates.outForDelivery:
        return "";
      case OrdersStates.delivered:
        return "";
      }
  }


  String getOrdersStatesMassage() {
    switch (ordersState) {
      case OrdersStates.confirmed:
        return "Picking up your order...";
      case OrdersStates.pickingItems:
        return "Packing your orders...";
      case OrdersStates.outForDelivery:
        return "Out for delivery";
      case OrdersStates.delivered:
        return "Your order has arrived";
      }
  }
  String getDeliveryState(){
    switch (deliveryStates) {
      case DeliveryStates.pickingOrders:
        return "Picking orders";
      case DeliveryStates.stillInStore:
        return "Still in store";
      case DeliveryStates.comingToYou:
        return "Coming to you";
      case DeliveryStates.arrived:
        return "Arrived";
      }
  }
}
