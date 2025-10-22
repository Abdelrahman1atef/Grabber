import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';
import '../theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.actionWidget,
    this.titleText,
    this.leadingWidget,
    this.leadingWidth,
  });
  final List<Widget>? actionWidget;
  final String? titleText;
  final Widget? leadingWidget;
  final double? leadingWidth;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorName.whiteColor,
      surfaceTintColor: ColorName.whiteColor,
      elevation: 0,
      centerTitle: true,
      leadingWidth: leadingWidth,
      leading: leadingWidget,
      title: Text(titleText ?? "", style: TextStyles.normalTextStyle),
      actions: actionWidget,
    );
  }
}
