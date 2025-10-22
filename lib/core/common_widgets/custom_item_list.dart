import 'package:flutter/material.dart';

import 'custom_card_widget.dart';
import '../model/product_model.dart';
import '../theme/text_styles.dart';
import '../../gen/colors.gen.dart';

class CustomItemList extends StatelessWidget {
  const CustomItemList({super.key, required this.items, required this.title});

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyles.normalTextStyle.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See all",
                  style: TextStyles.normalTextStyle.copyWith(
                    color: ColorName.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            cacheExtent: 999,
            itemBuilder: (context, index) {
              final ProductModel item = items[index];
              return CustomCardWidget(key: ValueKey(item.id),item: item);
            },
          ),
        ),
      ],
    );
  }
}
