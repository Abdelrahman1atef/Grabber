import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/model/category_model.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/colors.gen.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget({super.key});

  final List<CategoryModel> category = CategoryModel.category;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: category.length,
      itemBuilder: (context, index, realIndex) {
       final CategoryModel categoryItem = category[realIndex % category.length];
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: ColorName.grayBackGroundColor,
                radius: 35,
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: categoryItem.image.image(),
                ),
              ),
              Gap(10),
              Text(categoryItem.name,style: TextStyles.categoryTextStyle,)
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 120,
        aspectRatio: 1,
        viewportFraction: 0.23,
        autoPlayCurve: Curves.linear,
      ),
    );
  }
}
