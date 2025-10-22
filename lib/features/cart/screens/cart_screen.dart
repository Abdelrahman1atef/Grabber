import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/core/common_widgets/custom_app_bar.dart';
import 'package:products/core/theme/text_styles.dart';
import 'package:products/features/home/logic/cart_cubit.dart';
import 'package:products/features/home/logic/cart_state.dart';
import 'package:products/gen/assets.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/common_widgets/custom_item_list.dart';
import '../../../core/model/cart_model.dart';
import '../../../core/model/product_model.dart';
import '../../../core/routes/routes.dart';
import '../../../gen/colors.gen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List itemList1 = ProductModel.products;
  static const double _deliverybill = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.whiteColor,
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
                const Gap(10),
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
            loaded: (items) {
              if (items.isEmpty) {
                Future.delayed(
                  const Duration(milliseconds: 1500),
                  () => Navigator.pop(context),
                );
                return const Center(child: Text("Cart is empty"));
              }

              // ✅ Calculate total once
              final itemsTotalPrice = items.fold<double>(
                0,
                (sum, e) => sum + (e.product.price * e.totalItems),
              );
              final itemsCount = items.length;
              // ✅ Free delivery progress
              const freeDeliveryThreshold = 50.0;
              final remaining = (freeDeliveryThreshold - itemsTotalPrice).clamp(
                0.0,
                freeDeliveryThreshold,
              );
              final progress = (itemsTotalPrice / freeDeliveryThreshold).clamp(
                0.0,
                1.0,
              );

              return Column(
                children: [
                  const Divider(),
                  // ✅ Flexible list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: AnimateList(
                          delay: 400.ms,
                          interval: 150.ms,
                          effects: [
                            const FadeEffect(),
                            const SlideEffect(
                              begin: Offset(0, 1),
                              curve:  Cubic(.49, .13, .65, 1.19),
                            ),
                          ],
                          children: [
                            ...items.map(
                              (item) => _buildCartItem(blocContext, item),
                            ),
                            const Gap(25),
                            _buildProgressLine(remaining, progress),
                            const Gap(25),
                            CustomItemList(
                              title: "Recommended for you",
                              items: itemList1,
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: ColorName.grayBackGroundColor,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildActionWidget(
                                    Icons.note_add,
                                    "Add notes for delivery",
                                    Assets.svgs.arrowRight.svg(),
                                  ),
                                  const Divider(
                                    color: ColorName.grayBackGroundColor,
                                    height: 10,
                                    thickness: 2,
                                  ),
                                  _buildActionWidget(
                                    Icons.card_giftcard,
                                    "Send as gift",
                                    Assets.svgs.arrowRight.svg(),
                                  ),
                                  const Divider(
                                    color: ColorName.grayBackGroundColor,
                                    height: 10,
                                    thickness: 2,
                                  ),
                                  _buildActionWidget(
                                    Icons.delivery_dining,
                                    "Delivery",
                                    Text(
                                      remaining == 0
                                          ? "Free Delivery"
                                          : "\$$_deliverybill",
                                      style: TextStyles.normalTextStyle,
                                    ),
                                  ),
                                  const Divider(
                                    color: ColorName.grayBackGroundColor,
                                    height: 10,
                                    thickness: 2,
                                  ),
                                  _buildActionWidget(
                                    Icons.monetization_on_rounded,
                                    "Total",
                                    Text(
                                      "\$${itemsTotalPrice.floorToDouble()}",
                                      style: TextStyles.normalTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(50),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _buildButton(context, itemsTotalPrice, itemsCount),
                ],
              );
            },
          );
        },
      ),
    );
  }

  _buildActionWidget(icon, data, widget) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              const Gap(10),
              Text(data, style: TextStyles.normalTextStyle),
            ],
          ),
          widget,
        ],
      ),
    );
  }

  Widget _buildCartItem(blocContext, item) {
    return Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 15,
            start: 20,
            end: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorName.grayBackGroundColor,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: ColorName.grayBackGroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: item.product.image.image(),
                    ),
                    const Gap(17),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.product.qtyOfProduct} Bunch of ${item.product.name}",
                          style: TextStyles.normalTextStyle,
                        ),
                        Text(
                          "\$${item.product.price}",
                          style: TextStyles.normalTextStyle.copyWith(
                            fontSize: 14,
                            color: ColorName.grayTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _cartItemQuantityWidget(blocContext, item),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(
          duration: const Duration(milliseconds: 500),
          begin: -1,
          curve: const Cubic(.33, .62, .48, 1.64),
        );
  }

  Widget _buildButton(context, itemsTotalPrice, itemsCount) {
    return Container(
      decoration: const BoxDecoration(color: ColorName.whiteColor),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 50.0,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.checkout);
          },
          style: const ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 18),
            ),
            backgroundColor: WidgetStatePropertyAll(
              ColorName.primaryColor,
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Go to checkout", style: TextStyles.normalTextStyle),
            ],
          ),
        ),
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

  _buildProgressLine(double remaining, double progress) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
      child: Column(
        children: [
          remaining > 0
              ? RichText(
                  text: TextSpan(
                    style: TextStyles.normalTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    // base style MUST have a color
                    children: [
                      const TextSpan(text: "You are "),
                      TextSpan(
                        text: "\$${remaining.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ), // 🔥 only bold
                      ),
                      const TextSpan(text: " away from free delivery"),
                    ],
                  ),
                )
              : Text(
                  "🎉 You got free delivery!",
                  style: TextStyles.normalTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(),
          const Gap(8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: ColorName.primaryColor,
            borderRadius: BorderRadius.circular(16),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
