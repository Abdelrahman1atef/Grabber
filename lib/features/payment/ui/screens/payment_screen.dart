import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/features/payment/ui/widgets/custom_keyboard_text_field.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import '../../../../core/model/payment_method_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../logic/custom_keyboard_cubit.dart';
import '../widgets/enter_credit_card_info_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.paymentMethods, required this.total});

  final List<PaymentMethodModel> paymentMethods;
  final double total;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomKeyboardCubit(),
      child: _PaymentScreenContent(paymentMethods: paymentMethods, total: total),
    );
  }
}

class _PaymentScreenContent extends StatelessWidget {
  const _PaymentScreenContent({required this.paymentMethods, required this.total});

  final List<PaymentMethodModel> paymentMethods;
  final double total;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CustomKeyboardCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      appBar: CustomAppBar(
        leadingWidget: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Assets.svgs.arrowBack.svg(),
          ),
        ),
        leadingWidth: 50,
        titleText: "Payment",
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 150),
          switchInCurve: const Cubic(.49, .13, .65, 1.19),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: context.watch<CustomKeyboardCubit>().state.isKeyboardVisible
              ? SizedBox(
                  key: const ValueKey('keyboard-visible'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildButton(context),
                      const CustomKeyboardTextField(),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('keyboard-hidden')),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment method selection
              RadioGroup(
                groupValue: state.selectedPaymentMethodIndex,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<CustomKeyboardCubit>()
                        .selectPaymentMethod(value);
                  }
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    return Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 9),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: ColorName.grayBackGroundColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: index == 2 ? 30 : 50,
                                  child: method.icon,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  method.text,
                                  style: TextStyles.normalTextStyle,
                                ),
                              ],
                            ),
                            Radio<int>(
                              value: index,

                              activeColor: ColorName.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Credit card form (conditionally shown)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                reverseDuration: const Duration(milliseconds: 150),
                switchInCurve: const Cubic(.49, .13, .65, 1.19),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: state.isCreditCardSelected
                    ? const EnterCreditCardInfoWidget(
                        key: ValueKey('EnterCreditCardInfoWidget'),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return BlocBuilder<CustomKeyboardCubit, PaymentState>(
      builder: (context, state) {
        return SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: TextButton(
              onPressed: () {
                if (state.isProcessComplete) {
                  Navigator.pushNamed(context, Routes.orderMap);
                } else {
                  context
                      .read<CustomKeyboardCubit>()
                      .toggleKeyboardVisibility();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  state.isProcessComplete
                      ? ColorName.primaryColor
                      : ColorName.grayBackGroundColor,
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 18),
                ),
              ),
              child: Text(
                "Confirm and Pay (${total.toStringAsFixed(2)})",
                style: TextStyles.normalTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}
