import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/gen/assets.gen.dart';
import 'package:products/gen/colors.gen.dart';

import '../../../../core/theme/text_styles.dart';
import '../../logic/custom_keyboard_cubit.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.haveSuffixIcon,
    required this.autofocus,
    required this.controller,
    required this.focusNode,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String title;
  final String hintText;
  final bool? haveSuffixIcon;
  final bool autofocus;
  final TextInputFormatter? inputFormatters;

  @override
  Widget build(BuildContext context) {
   final  cubit = context.read<CustomKeyboardCubit>();
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.normalTextStyle),
          const Gap(15),
          BlocBuilder<CustomKeyboardCubit, PaymentState>(
            builder: (context, state) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onTap: () {
                  if(cubit.state.isKeyboardVisible==true) {

                    return;
                  }
                    cubit.toggleKeyboardVisibility();
                },
                textAlign: TextAlign.start,
                readOnly: true,
                showCursor: true,
                style: TextStyles.normalTextStyle,
                autofocus: autofocus,
                keyboardType: TextInputType.number,
                cursorColor: ColorName.primaryColor,
                cursorHeight: 20,
                cursorWidth: 2,
                cursorRadius: const Radius.circular(5),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  if (inputFormatters != null) inputFormatters!,
                ],
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyles.normalTextStyle.copyWith(
                    color: ColorName.grayHintTextColor,
                  ),
                  suffixIcon: haveSuffixIcon ?? false
                      ? Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10,
                          ),
                          child: Assets.svgs.cardShieldCvc.svg(),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorName.grayBackGroundColor,
                      width: 1, // 👈 5 is too thick!
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorName.blackColor,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
