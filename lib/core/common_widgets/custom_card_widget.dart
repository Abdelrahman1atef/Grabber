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

class CustomCardWidget extends StatefulWidget {
  const CustomCardWidget({super.key, required this.item});

  final ProductModel item;

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
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
                  child: widget.item.image.image(),
                ),
              ),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return Positioned(
                    bottom: 6,
                    right: 6,
                    child: state.maybeWhen(
                      loaded: (items) {
                        final cartItem = items.firstWhereOrNull(
                              (e) => e.product == widget.item,
                        );
                        bool isItemInCart = cartItem != null;

                        return AnimatedContainer(
                          width: isItemInCart ? 86 : 38,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: ColorName.whiteColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          duration: Duration(milliseconds: 400),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(), // Prevent manual scrolling
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Animated visibility for remove button
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  width: isItemInCart ? 20 : 0,
                                  child: isItemInCart
                                      ? InkWell(
                                    onTap: _removeItemFromCart,
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: cartItem.totalItems > 1
                                          ? Assets.svgs.remove.svg(width: 20, height: 20)
                                          : Assets.svgs.trash.svg(width: 20, height: 20),
                                    ),
                                  )
                                      : SizedBox.shrink(),
                                ),

                                Gap(8),
                                Text(
                                  cartItem?.totalItems.toString()??"1",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Gap(8),

                                // Add button (always visible)
                                InkWell(
                                  onTap: _addItemInCart,
                                  child: Assets.svgs.add.svg(width: 20, height: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      orElse: () => _getCartItemsWidget(),
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
                Text(widget.item.name, style: TextStyles.normalTextStyle),
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Assets.icons.star.image(),
                    ),
                    Gap(8),
                    Text(
                      widget.item.rateWithResidentNum,
                      style: TextStyles.normalTextStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  "\$${widget.item.price}",
                  style: TextStyles.normalTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _isItemInCartWidget(CartModel cartItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => _removeItemFromCart(),
          child: SizedBox(
            width: 18,
            height: 18,
            child: cartItem.totalItems > 1
                ? Assets.svgs.remove.svg(width: 24, height: 24)
                : Assets.svgs.trash.svg(width: 24, height: 24),
          ),
        ),
        const Gap(8),
        Text(cartItem.totalItems.toString()), // ✅ use cartItem count
        const Gap(8),
        InkWell(
          onTap: () => _addItemInCart(),
          child: Assets.svgs.add.svg(width: 24, height: 24), // ✅ add, not remove
        ),
      ],
    );
  }

  Widget _getCartItemsWidget() {
    return InkWell(
      onTap: () => _addItemInCart(),
      child: Assets.svgs.add.svg(width: 24, height: 24),
    );
  }

  void _addItemInCart() {
    context.read<CartCubit>().addItem(widget.item, 1);
  }

  void _removeItemFromCart() {
    context.read<CartCubit>().removeItem(widget.item, 1);
  }
}
