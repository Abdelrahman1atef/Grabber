import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/core/theme/text_styles.dart';
import 'package:products/features/payment/logic/custom_keyboard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../gen/colors.gen.dart';

class CustomKeyboardTextField extends StatefulWidget {
  const CustomKeyboardTextField({super.key});

  @override
  State<CustomKeyboardTextField> createState() =>
      _CustomKeyboardTextFieldState();
}

class _CustomKeyboardTextFieldState extends State<CustomKeyboardTextField> {
  List<String> keys = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "+*#",
    "0",
    "⌫",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        children: [
          GridView.builder(
            itemCount: keys.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              return keys[index] != "+*#"
                  ? Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                    child: MaterialButton(
                        color: ColorName.whiteColor,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        disabledElevation: 0,
                        elevation: 0,
                        highlightElevation: 0,
                        animationDuration: const Duration(microseconds: 50),
                        onPressed: () {
                          context.read<CustomKeyboardCubit>().postTextInput(
                            keys[index],
                          );
                        },
                        child: Center(
                          child: Text(
                            (keys[index]),
                            style: TextStyles.normalTextStyle.copyWith(
                              fontSize: 25,
                              fontWeight: index==9||index==11?FontWeight.normal:FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  )
                  : Center(
                      child: Text(
                        (keys[index]),
                        style: TextStyles.normalTextStyle.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
            },
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
