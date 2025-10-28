import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/features/payment/logic/custom_keyboard_cubit.dart';
import 'custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterCreditCardInfoWidget extends StatelessWidget {
  const EnterCreditCardInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomKeyboardCubit>();
    return BlocListener<CustomKeyboardCubit, PaymentState>(
      listener: (context, state) {
        // Handle focus requests
        switch (state.nextFocusRequest) {
          case FocusTarget.expiry:
            FocusScope.of(context).requestFocus(state.expiryFocus);
            break;
          case FocusTarget.cvv:
            FocusScope.of(context).requestFocus(state.cvvFocus);
            break;
          case FocusTarget.cardNumber:
            FocusScope.of(context).requestFocus(state.cardNumberFocus);
            break;
          case FocusTarget.none:
            break;
        }

        // Optional: reset the request to avoid repeated focus
        if (state.nextFocusRequest != FocusTarget.none) {
          context.read<CustomKeyboardCubit>().resetFocusRequest();
        }
      },
      child: Column(
        key: const ValueKey('creditCardForm'),
        children: [
          // Card Number - with formatter
          CustomTextField(
            controller: cubit.state.cardNumberController,
            focusNode: cubit.state.cardNumberFocus,
            title: "Card Number",
            hintText: "XXXX XXXX XXXX XXXX",
            autofocus: true,
          ),

          const Gap(16),

          Row(
            children: [
              // Expiry - with formatter
              Expanded(
                child: CustomTextField(
                  controller: cubit.state.expiryController,
                  focusNode: cubit.state.expiryFocus,
                  title: "Expiry",
                  hintText: "mm/yy",
                  autofocus: false,
                ),
              ),
              const Gap(20),
              // CVC - CUSTOM KEYBOARD
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: "***",
                      controller: cubit.state.cvvController,
                      focusNode: cubit.state.cvvFocus,
                      haveSuffixIcon: true,
                      title: 'CVC',
                      autofocus: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
