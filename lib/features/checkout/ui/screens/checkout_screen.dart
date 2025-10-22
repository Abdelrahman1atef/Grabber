import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:products/core/routes/routes.dart';
import 'package:products/gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common_widgets/custom_app_bar.dart';
import '../../../../core/model/payment_method_model.dart';
import '../../../../gen/assets.gen.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../home/logic/cart_cubit.dart';
import '../../../home/logic/cart_state.dart';
import '../../models/checkout_component_model.dart';
import '../widgets/checkout_component_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<PaymentMethodModel> paymentMethods = [
    PaymentMethodModel(
      id: 1,
      text: "Apple Pay",
      icon: Assets.svgs.applePay.svg(),
    ),
    PaymentMethodModel(
      id: 2,
      text: "Google Pay",
      icon: Assets.svgs.googlePay.svg(),
    ),
    PaymentMethodModel(
      id: 3,
      text: "Credit Card",
      icon: Assets.svgs.creditCard.svg(),
    ),
  ];
  late final PaymentMethodModel _selectedPaymentMethod = paymentMethods[0];
  @override
  Widget build(BuildContext context) {
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
        titleText: "Checkout",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          child: Column(
            children: AnimateList(
              children: [
                ///Details
                CheckoutComponentWidget(
                  key: const Key("Details"),
                  isListTile: false,
                  title: "Details",
                  trailingWidget: Assets.svgs.arrowRight.svg(),
                  items: [
                    CheckoutComponentModel(
                      icon: const Icon(Icons.person_outline),
                      text: "Kinglsey Ezechukwu",
                    ),
                    CheckoutComponentModel(
                      icon: const Icon(Icons.phone_outlined),
                      text: "+447404168963",
                    ),
                  ],
                ),

                ///Address
                CheckoutComponentWidget(
                  key: const Key("Address"),
                  title: "Address",
                  trailingWidget: Assets.svgs.arrowRight.svg(),
                  isListTile: true,
                  items: [
                    CheckoutComponentModel(
                      icon: const Icon(Icons.location_on_outlined),
                      text: "Apartment 609",
                      subText: "45 Soho loop street birmingham",
                    ),
                  ],
                ),

                ///Have coupon?
                CheckoutComponentWidget(
                  key: const Key("Have coupon?"),
                  title: "Have coupon?",
                  trailingWidget: Assets.svgs.arrowRight.svg(),
                  items: [
                    CheckoutComponentModel(
                      icon: const Icon(Icons.discount_outlined),
                      text: "Apply coupon",
                    ),
                  ],
                ),

                ///Delivery
                const CheckoutComponentWidget(
                  title: "Delivery",
                  haveRadioGroup: true,
                ),

                ///Order Summery(## items)
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const SizedBox.shrink(),
                      loaded: (items) {
                        if (items.isEmpty) {
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            if (items.isEmpty) {
                              Navigator.pop(context);
                            }
                          });
                          return const Center(child: Text("Cart is empty"));
                        }

                        // ✅ Calculate total once
                        final itemsTotalPrice = items.fold<double>(
                          0,
                          (sum, e) => sum + (e.product.price * e.totalItems),
                        );
                        final itemsCount = items.length;
                        //Bag fee
                        const bagFee = 0.25;
                        //Service fee
                        const serviceFee = 5.25;
                        // //Delivery
                        // const delivery = 10.0;
                        // ✅ Free delivery progress
                        const freeDeliveryThreshold = 50.0;
                        final remaining =
                            (freeDeliveryThreshold - itemsTotalPrice).clamp(
                              0.0,
                              freeDeliveryThreshold,
                            );
                        double delivery() {
                          const delivery = 10.0;
                          return remaining == 0 ? 0.0 : delivery;
                        }

                        double ceilTo2Decimals(double value) {
                          return (value * 100).ceilToDouble() / 100;
                        }

                        final total =
                            ceilTo2Decimals(itemsTotalPrice) +
                            bagFee +
                            serviceFee +
                            delivery();
                        return CheckoutComponentWidget(
                          key: const Key("Order Summery"),
                          title: "Order Summery ($itemsCount items)",
                          items: [
                            CheckoutComponentModel(
                              text: "Subtotal",
                              trailingText:
                                  "\$${ceilTo2Decimals(itemsTotalPrice)}",
                              grayTextStyle: true,
                            ),
                            CheckoutComponentModel(
                              text: "Bag fee",
                              trailingText: "\$$bagFee",
                              grayTextStyle: true,
                            ),
                            CheckoutComponentModel(
                              text: "Service fee",
                              trailingText: "\$$serviceFee",
                              grayTextStyle: true,
                            ),
                            CheckoutComponentModel(
                              text: "Delivery",
                              trailingText: "\$${delivery()}",
                              grayTextStyle: true,
                            ),
                            CheckoutComponentModel(
                              text: "Total",
                              trailingText: "\$${ceilTo2Decimals(total)}",
                            ),
                            CheckoutComponentModel(
                              text: "Request an invoice",
                              haveBackGround: true,
                              haveSwitch: true,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                ///Payment Method
                CheckoutComponentWidget(
                  key: const Key("Payment Method"),
                  title: "Payment Method",
                  trailingWidget: Assets.svgs.arrowRight.svg(),
                  action: () {
                    Navigator.pushNamed(
                      context,
                      Routes.payment,
                      arguments: paymentMethods,
                    );
                  },
                  items: [
                    CheckoutComponentModel(
                      icon: _selectedPaymentMethod.icon,
                      text: _selectedPaymentMethod.text,
                    ),
                  ],
                ),

                const Gap(300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
