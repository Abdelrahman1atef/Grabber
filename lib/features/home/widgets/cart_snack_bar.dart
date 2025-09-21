import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/model/cart_model.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../utils/utils.dart';
import 'cart_animated_list.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartSnackBar extends StatelessWidget {
  const CartSnackBar({super.key, required this.items});

  final List<CartModel> items;

  @override
  Widget build(BuildContext context) {
    final totalCount = items.length;
    return Animate(
      effects: [SlideEffect()],
      child:
          InkWell(
            onTap: () => Utils.cartIconAction(context),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: ColorName.primaryColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 🔹 show product thumbnails horizontally
                    CartListView(items: items),
                    VerticalDivider(
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
                        Gap(5),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Assets.icons.basket.svg(
                              colorFilter: ColorFilter.mode(
                                ColorName.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            if (totalCount > 0)
                              Positioned(
                                top: -5,
                                right: -1,
                                child: TweenAnimationBuilder<double>(
                                  key: ValueKey(totalCount),
                                  tween: Tween<double>(begin: 0.7, end: 1.0),
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutBack,
                                  builder: (context, scale, child) {
                                    return Transform.scale(scale: scale, child: child);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,

                                    ),
                                    child: Text(
                                      totalCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onEnd: () {}, // optional
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).animate()
              .slideY(
            begin: 1.5,
            duration: Duration(milliseconds:700),
            curve: Cubic(.33,.62,.48,1.64)
          ), // inherits duration from fadeIn
    );
  }
}
