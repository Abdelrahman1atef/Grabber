import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/model/product_model.dart';
import '../../../gen/colors.gen.dart';
import '../../../utils/utils.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';
import '../widgets/banner_widget.dart';
import '../widgets/cart_snack_bar.dart';
import '../widgets/category_widget.dart';
import '../widgets/item_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List itemList1 = ProductModel.products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (items) => items.isEmpty?SizedBox():CartSnackBar(items: items),
            orElse: () => SizedBox(),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(),
            Gap(20),
            CategoryWidget(),
            ItemList(title: "Fruits", items: itemList1),
            ItemList(title: "Fruits", items: itemList1),
            ItemList(title: "Fruits", items: itemList1),

            // CartWidget()
          ],
        ),
      ),
    );
  }
}