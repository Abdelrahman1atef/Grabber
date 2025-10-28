import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:products/core/theme/text_styles.dart';
import 'package:products/features/order_map/logic/order_state.dart';
import 'package:products/gen/assets.gen.dart';
import 'package:products/gen/colors.gen.dart';
import '../../logic/order_cubit.dart';
import '../../model/order_model.dart';
import 'package:shimmer/shimmer.dart';

import 'delivery_info_widget.dart';
import 'order_state_progress_widget.dart';

class OrderStateWidget extends StatelessWidget {
  const OrderStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return state.when(
          error: (message) {
            return const SizedBox.shrink();
          },
          initial: () {
            return _buildShimmerLoading();
          },
          loaded: (order) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.getOrdersStatesMassage(),
                            style: TextStyles.normalTextStyle.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            order.ordersState == OrdersStates.delivered
                                ? "Kingsley is waiting outside"
                                : "Arriving at ${order.formattedDeliveryTime.toString()}",
                            style: TextStyles.categoryTextStyle,
                          ),
                        ],
                      ),
                      (order.ordersState == OrdersStates.outForDelivery ||
                              order.ordersState == OrdersStates.delivered)
                          ? Column(
                              children: [
                                Text(
                                  order.orderCode ?? "",
                                  style: TextStyles.normalTextStyle.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Your code",
                                  style: TextStyles.categoryTextStyle,
                                ),
                              ],
                            )
                          : Image.asset(
                              Assets.orderState.icon1.path,
                              width: 60,
                            ),
                    ],
                  ),
                ),
                Card(
                  color: ColorName.whiteColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    child: Column(
                      children: [
                        OrderStateProgressWidget(order: order),
                        const Gap(25),
                        DeliveryInfoWidget(order: order),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

  }
}

Widget _buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: [
        // Order Header Shimmer
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Progress Shimmer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: List.generate(7, (index) {
              if (index.isOdd) {
                // Connector shimmer
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              } else {
                // State circle shimmer
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 70,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ],
    ),
  );
}