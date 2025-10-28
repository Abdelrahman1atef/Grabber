import 'package:flutter/material.dart';
import 'package:products/core/theme/text_styles.dart';
import 'package:products/features/order_map/ui/widgets/custom_map_widget.dart';
import 'package:products/features/order_map/ui/widgets/order_state_widget.dart';
import 'package:products/gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/order_cubit.dart';

class OrderMapScreen extends StatefulWidget {
  const OrderMapScreen({super.key});

  @override
  State<OrderMapScreen> createState() => _OrderMapScreenState();
}

class _OrderMapScreenState extends State<OrderMapScreen> {
  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..trackOrderState(),

      child: Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(height: height *61, child: const CustomMapScreen()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.40,
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              decoration: const BoxDecoration(
                color: ColorName.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorName.blackColor,
                    blurRadius: 10,
                    spreadRadius: 0.1,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: const OrderStateWidget(),
            ),
          ),
        ],
      ),
    ),
);
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Confirming your order", style: TextStyles.normalTextStyle),
    );
  }
}
