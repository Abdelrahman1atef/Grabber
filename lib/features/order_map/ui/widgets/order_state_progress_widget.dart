import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../model/order_model.dart';

class OrderStateProgressWidget extends StatelessWidget {
  const OrderStateProgressWidget({super.key, required this.order});

  final OrderModel order;

  Map<OrdersStates, String> get orderStateMap => {
    OrdersStates.confirmed: "Confirmed",
    OrdersStates.pickingItems: "Picking items",
    OrdersStates.outForDelivery: "Out for delivery",
    OrdersStates.delivered: "Delivered",
  };

  Map<OrdersStates, List<SvgGenImage>> get orderStateIcons => {
    OrdersStates.confirmed: [
      Assets.orderState.notCompleteConfirmed,
      Assets.orderState.completeConfirmed,
    ],
    OrdersStates.pickingItems: [
      Assets.orderState.notCompletePickingItems,
      Assets.orderState.completePickingItems,
    ],
    OrdersStates.outForDelivery: [
      Assets.orderState.notCompleteOutForDeliver,
      Assets.orderState.completeOutForDeliver,
    ],
    OrdersStates.delivered: [
      Assets.orderState.notCompleteDelivered,
      Assets.orderState.notCompleteDelivered,
    ],
  };

  Color getStateColor(OrdersStates state, OrdersStates currentState) {
    final currentIndex = OrdersStates.values.indexOf(currentState);
    final stateIndex = OrdersStates.values.indexOf(state);

    if (stateIndex <= currentIndex) {
      return Colors.green;
    }
    return Colors.grey.shade300;
  }

  bool isStateCompleted(OrdersStates state, OrdersStates currentState) {
    final currentIndex = OrdersStates.values.indexOf(currentState);
    final stateIndex = OrdersStates.values.indexOf(state);
    return stateIndex <= currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    const states = OrdersStates.values;
    return Row(
      children: List.generate(states.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stateIndex = index ~/ 2;
          final isCompleted = isStateCompleted(
            states[stateIndex],
            order.ordersState,
          );

          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        } else {
          final stateIndex = index ~/ 2;
          final state = states[stateIndex];
          final isCompleted = isStateCompleted(state, order.ordersState);
          final isActive = state == order.ordersState;
          return SizedBox(
            width: 50,
            child: Column(
              children: [
                ?orderStateIcons[state]?[isActive || isCompleted ? 1 : 0].svg(
                  width: 25,
                  colorFilter:isCompleted? const ColorFilter.mode(
                    ColorName.primaryColor,
                    BlendMode.srcIn,
                  ):null,
                ),
                // Text(orderStateMap[state]!)
              ],
            ),
          );
        }
      }),
    );
  }
}