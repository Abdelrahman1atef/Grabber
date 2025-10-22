import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:collection/collection.dart';

import '../../features/home/logic/cart_cubit.dart';
import '../../features/home/logic/cart_state.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../model/cart_model.dart';
import '../model/product_model.dart';
import '../theme/text_styles.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key, required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorName.grayBackGroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: 180,
                  height: 170,
                  child: item.image.image(),
                ),
              ),
              // ❌ OLD: Rebuilds ALL 60 items on any cart change
              // BlocBuilder<CartCubit, CartState>(
              //   buildWhen: (previous, current) {
              //     // Only rebuild if this specific item changed
              //     return previous != current;
              //   },
              //   builder: (context, state) {
              //     return Positioned(
              //       bottom: 6,
              //       right: 6,
              //       child: state.maybeWhen(
              //         loaded: (items) {
              //           final CartModel? cartItem = items.firstWhereOrNull(
              //             (e) => e.product == item,
              //           );
              //           bool isItemInCart = cartItem != null;
              //
              //           return ItemQuantityWidget(
              //             item: item,
              //             cartItem: cartItem,
              //             isItemInCart: isItemInCart,
              //           );
              //         },
              //         orElse: () => const SizedBox.shrink(),
              //       ),
              //     );
              //   },
              // ),

              // ✅ NEW: Only rebuilds if THIS specific item's cart data changes
              BlocSelector<CartCubit, CartState, CartModel?>(
                selector: (state) {
                  return state.maybeWhen(
                    loaded: (items) => items.firstWhereOrNull(
                      (e) => e.product.id == item.id, // Only track THIS item
                    ),
                    orElse: () => null,
                  );
                },
                builder: (context, cartItem) {
                  bool isItemInCart = cartItem != null;

                  return Positioned(
                    bottom: 6,
                    right: 6,
                    child: ItemQuantityWidget(
                      item: item,
                      cartItem: cartItem,
                      isItemInCart: isItemInCart,
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyles.normalTextStyle),
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Assets.icons.star.image(),
                    ),
                    const Gap(8),
                    Text(
                      item.rateWithResidentNum,
                      style: TextStyles.normalTextStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                Text("\$${item.price}", style: TextStyles.normalTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemQuantityWidget extends StatelessWidget {
  const ItemQuantityWidget({
    super.key,
    required this.cartItem,
    required this.isItemInCart,
    required this.item,
  });

  final ProductModel item;
  final CartModel? cartItem;

  final bool isItemInCart;

  double get _borderRadius => 25;

  double? get _iconSize => 22;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      width: isItemInCart ? 90 : 40,
      decoration: BoxDecoration(
        color: ColorName.whiteColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        // Prevent manual scrolling
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isItemInCart) ...<Widget>[
              // Animated visibility for remove button
              InkWell(
                borderRadius: BorderRadius.circular(_borderRadius),
                onTap: () => context.read<CartCubit>().removeItem(item, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: (cartItem?.totalItems ?? 0) > 1
                      ? Assets.svgs.remove.svg(
                          width: _iconSize,
                          height: _iconSize,
                        )
                      : Assets.svgs.trash.svg(
                          width: _iconSize,
                          height: _iconSize,
                        ),
                ),
              ),
              const Gap(3),
              Text(
                cartItem?.totalItems.toString() ?? "1",
                style: const TextStyle(fontSize: 14),
              ),
              const Gap(3),
            ],
            // Add button (always visible)
            InkWell(
              borderRadius: BorderRadius.circular(_borderRadius),
              onTap: () => context.read<CartCubit>().addItem(item, 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Assets.svgs.add.svg(width: _iconSize, height: _iconSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
