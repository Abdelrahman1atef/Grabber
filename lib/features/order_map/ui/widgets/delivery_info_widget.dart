
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../model/order_model.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Assets.logo.gOnly.svg(width: 50),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name fo Delivery", style: TextStyles.normalTextStyle),
                Text(
                  order.getDeliveryState(),
                  style: TextStyles.categoryTextStyle,
                ),
              ],
            ),
          ],
        ),

        Row(
          children: [
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: ColorName.grayBackGroundColor,
                borderRadius: BorderRadiusGeometry.circular(25),
              ),
              padding: const EdgeInsetsGeometry.all(10),
              child: const Icon(Icons.chat_outlined, size: 24),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorName.grayBackGroundColor,
                borderRadius: BorderRadiusGeometry.circular(25),
              ),
              padding: const EdgeInsetsGeometry.all(10),
              child: const Icon(Icons.phone_outlined, size: 24),
            ),
          ],
        ),
      ],
    );
  }
}