import 'package:flutter/material.dart';

import '../../../core/common_widgets/custom_card_widget.dart';
import '../../../core/model/product_model.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/colors.gen.dart';



class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.items, required this.title});

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
            itemBuilder: (context, index) {
              final ProductModel item = items[index];
              return CustomCardWidget(item: item);
            },
          ),
        ),
      ],
    );
  }
}
