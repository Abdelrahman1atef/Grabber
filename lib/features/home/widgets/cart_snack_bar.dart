import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/features/home/logic/cart_cubit.dart';

import '../../../core/common_widgets/basket_with_badger.dart';
import '../../../core/model/cart_model.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import 'cart_animated_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_preview_bottom_sheet.dart';

class CartSnackBar extends StatefulWidget {
  const CartSnackBar({super.key, required this.items});

  final List<CartModel> items;

  @override
  State<CartSnackBar> createState() => _CartSnackBarState();
}

class _CartSnackBarState extends State<CartSnackBar> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.items.length;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: const Cubic(.24, 1.06, .44, 1.06),
      bottom: widget.items.isEmpty?-160:0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _toggle ? MediaQuery.of(context).size.height * 0.7 : 70,
        margin: _toggle
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 80),
        decoration: BoxDecoration(
          color: _toggle
              ? ColorName.whiteColor
              : ColorName.primaryColor.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(_toggle ? 16 : 7),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),

          child: _toggle
              ? CartPreviewBottomSheet(
                  key: const ValueKey("CartPreviewBottomSheet"),
                  cartCubit: context.read<CartCubit>(),
                  onClose: () => setState(() => _toggle = false),
                )
              : CustomSnackBar(
                  key: const ValueKey("snackbar"),
                  items: widget.items,
                  totalCount: totalCount,
            onClose: () => setState(() => _toggle = true),
                ),
        ),
      ));
    //       .animate().fadeIn().slideY(
    //     begin: 1.5,
    //     duration: const Duration(milliseconds: 700),
    //     // curve: ConstVal.customCurve,
    //     curve: const Cubic(.24, 1.06, .44, 1.06),
    //   ),
    // );
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.totalCount,
    required this.items, required this.onClose,
  });

  final List<CartModel> items;
  final int totalCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClose,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CartListView(items: items),
            const VerticalDivider(
              indent: 20,
              endIndent: 20,
              color: ColorName.whiteColor,
            ),
            Row(
              children: [
                Text(
                  "View Basket",
                  style: TextStyles.normalTextStyle.copyWith(
                    color: ColorName.whiteColor,
                  ),
                ),
                const Gap(5),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Assets.icons.basket.svg(
                      colorFilter: const ColorFilter.mode(
                        ColorName.whiteColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    BasketWithBadger(
                      key: ValueKey(totalCount),
                      totalCount: totalCount,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
