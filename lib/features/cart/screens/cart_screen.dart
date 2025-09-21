import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/core/common_widgets/custom_app_bar.dart';
import 'package:products/core/theme/text_styles.dart';
import 'package:products/features/home/logic/cart_cubit.dart';
import 'package:products/features/home/logic/cart_state.dart';
import 'package:products/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/cart_model.dart';
import '../../../core/routes/routes.dart';
import '../../../gen/colors.gen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingWidget: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Assets.svgs.arrowBack.svg(),
          ),
        ),
        leadingWidth: 50,
        titleText: "Cart",
        actionWidget: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Row(
              children: [
                Assets.svgs.orders.svg(),
                Gap(10),
                Text("Orders", style: TextStyles.normalTextStyle),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (blocContext, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox(),
            loaded: (items)  {
              if (items.isEmpty) {
                Future.delayed(
                  Duration(milliseconds: 1500),
                      () => Navigator.pop(context),
                );
                return Center(child: Text("Cart is empty"));
              }

              // ✅ Calculate total once
              final itemsTotalPrice = items.fold<double>(
                0,
                    (sum, e) => sum + (e.product.price * e.totalItems),
              );
              final itemsCount = items.length;
              // ✅ Free delivery progress
              const freeDeliveryThreshold = 50.0;
              final remaining = (freeDeliveryThreshold - itemsTotalPrice)
                  .clamp(0.0, freeDeliveryThreshold);
              final progress = (itemsTotalPrice / freeDeliveryThreshold)
                  .clamp(0.0, 1.0);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Flexible list
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,

                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: ColorName.grayBackGroundColor,
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ),
                                    ),
                                    child: item.product.image.image(),
                                  ),
                                  const Gap(17),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.product.qtyOfProduct} Bunch of ${item.product.name}",
                                        style: TextStyles.normalTextStyle,
                                      ),
                                      Text(
                                        "\$${item.product.price}",
                                        style: TextStyles.normalTextStyle
                                            .copyWith(
                                          fontSize: 14,
                                          color:
                                          ColorName.grayTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              _cartItemQuantityWidget(blocContext, item),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Gap(12),
                  RichText(
                    text: TextSpan(
                      style: TextStyles.normalTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      // base style MUST have a color
                      children: [
                        if (remaining > 0) ...[
                          const TextSpan(text: "You are "),
                          TextSpan(
                            text: "\$${remaining.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // 🔥 only bold
                          ),
                          const TextSpan(text: " away from free delivery"),
                        ] else ...[
                          const TextSpan(
                            text: "🎉 You got free delivery!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Gap(8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: ColorName.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    minHeight: 8,
                  ),

                  const Gap(24),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.cart);
                    },
                    style: ButtonStyle(
                      shape: const WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        ColorName.primaryColor,
                      ),
                      foregroundColor: const WidgetStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Go to Cart (\$${itemsTotalPrice.toStringAsFixed(2)})",
                          style: TextStyles.normalTextStyle,
                        ),
                        const Gap(8),
                        Stack(
                          children: [
                            Assets.icons.basket.svg(
                              colorFilter: ColorFilter.mode(
                                ColorName.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            if (itemsCount > 0)
                              Positioned(
                                top: -5,
                                right: -1,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    itemsCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
  void _addItemInCart(BuildContext context, CartModel item) {
    BlocProvider.of<CartCubit>(context).addItem(item.product, 1);
  }

  void _removeItemFromCart(BuildContext context, CartModel item) {
    BlocProvider.of<CartCubit>(context).removeItem(item.product, 1);
  }

  Widget _cartItemQuantityWidget(BuildContext context, CartModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _removeItemFromCart(context, item),
            child: SizedBox(
              width: 18,
              height: 18,
              child: item.totalItems > 1
                  ? Assets.svgs.remove.svg()
                  : Assets.svgs.trash.svg(),
            ),
          ),
          const Gap(8),
          Text(item.totalItems.toString(), style: TextStyles.normalTextStyle),
          const Gap(8),
          InkWell(
            onTap: () => _addItemInCart(context, item),
            child: Assets.svgs.add.svg(),
          ),
        ],
      ),
    );
  }
}
