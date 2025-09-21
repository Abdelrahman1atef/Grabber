import 'package:flutter/material.dart';

import '../features/home/logic/cart_cubit.dart';
import '../features/home/widgets/cart_preview_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Utils {
  static void cartIconAction(BuildContext context) {
    final cartCubit = context
        .read<CartCubit>(); // 👈 get cubit from parent context

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (ctx) {
        return CartPreviewBottomSheet(cartCubit: cartCubit);
      },
    );
  }
}
