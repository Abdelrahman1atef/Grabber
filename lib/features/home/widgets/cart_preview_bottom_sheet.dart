import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:products/core/routes/routes.dart';
import '../../../core/model/cart_model.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartPreviewBottomSheet extends StatefulWidget {
  const CartPreviewBottomSheet({
    super.key,
    required this.cartCubit,
    required this.onClose,
  });

  final CartCubit cartCubit;
  final VoidCallback onClose;

  @override
  State<CartPreviewBottomSheet> createState() => _CartPreviewBottomSheetState();
}

class _CartPreviewBottomSheetState extends State<CartPreviewBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1),
      height: MediaQuery.of(context).size.height * 0.8,
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        // 80% of screen height
        minChildSize: 0.4,
        maxChildSize: 1,
        snap: true,
        snapSizes: const [0.4, 1],
        snapAnimationDuration: const Duration(milliseconds: 100),
        expand: false,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= 0.41) {
                widget.onClose();
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: BlocProvider.value(
                value: widget.cartCubit,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loaded: (items) {
                          if (items.isEmpty) {
                            Future.delayed(const Duration(milliseconds: 1500), () {
                              if (items.isEmpty) {
                                Navigator.pop(context);
                              }
                            });
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
                          final remaining =
                              (freeDeliveryThreshold - itemsTotalPrice).clamp(
                                0.0,
                                freeDeliveryThreshold,
                              );
                          final progress =
                              (itemsTotalPrice / freeDeliveryThreshold).clamp(
                                0.0,
                                1.0,
                              );

                          return Column(
                            children: [
                              // Drag Handle
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: 4,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              // // Fixed Height List Container
                              // SizedBox(
                              //   height: 500,
                              //   child: ListView.builder(
                              //     // controller: scrollController,
                              //     itemCount: items.length,
                              //     padding: EdgeInsets.zero,
                              //     itemBuilder: (context, index) {
                              //       final item = items[index];
                              //       return _buildItemList(item);
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height: 450,
                                child: Animate(
                                  effects: [
                                    FadeEffect(duration: 500.ms),
                                    SlideEffect(
                                      duration: 500.ms,
                                      begin: const Offset(0, 2),
                                    ),
                                  ],
                                  child: ListView.builder(
                                    // controller: scrollController,
                                    itemCount: items.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return _buildItemList(item);
                                    },
                                  ),
                                ),
                              ),
                              _buildLinearProgress(
                                remaining,
                                progress,
                                itemsTotalPrice,
                                itemsCount,
                              ),
                            ],
                          );
                        },
                        orElse: () => const SizedBox(),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addItemInCart(CartCubit cartCubit, CartModel item) {
    cartCubit.addItem(item.product, 1);
  }

  void _removeItemFromCart(CartCubit cartCubit, CartModel item) {
    cartCubit.removeItem(item.product, 1);
  }

  Widget _cartItemQuantityWidget(CartCubit cartCubit, CartModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _removeItemFromCart(cartCubit, item),
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
            onTap: () => _addItemInCart(cartCubit, item),
            child: Assets.svgs.add.svg(),
          ),
        ],
      ),
    );
  }

  _buildItemList(CartModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
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
          _cartItemQuantityWidget(widget.cartCubit, item),
        ],
      ),
    );
  }

  _buildLinearProgress(remaining, progress, itemsTotalPrice, itemsCount) {
    return Column(
      children: [
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
            Navigator.pushNamed(context, Routes.cart);
            widget.onClose();
          },
          style: const ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
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
              Text(
                "Go to Cart (\$${itemsTotalPrice.toStringAsFixed(2)})",
                style: TextStyles.normalTextStyle,
              ),
              const Gap(8),
              Stack(
                children: [
                  Assets.icons.basket.svg(
                    colorFilter: const ColorFilter.mode(
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
  }
}
