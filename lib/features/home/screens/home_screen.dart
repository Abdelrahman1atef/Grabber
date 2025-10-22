import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/model/product_model.dart';
import '../../../gen/colors.gen.dart';
import '../logic/cart_cubit.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_widget.dart';
import '../../../core/common_widgets/custom_item_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List itemList1 = ProductModel.products;

  @override
  Widget build(BuildContext context) {
    context.read<CartCubit>().getCartItems();
    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const BannerWidget(),
                const Gap(20),
                CategoryWidget(),
                CustomItemList(title: "Fruits", items: itemList1),

                // CartWidget()
              ],
            ),
          ),


        ],
      ),
    );
  }
}
