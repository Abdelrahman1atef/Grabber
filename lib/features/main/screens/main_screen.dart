import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:products/core/routes/routes.dart';
import '../../../core/common_widgets/basket_with_badger.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../empty_widget.dart';
import '../../home/logic/cart_cubit.dart';
import '../../home/logic/cart_state.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/cart_snack_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  // List of screens/widgets corresponding to each tab
  final List<Widget> _screens = [
    HomeScreen(),
    const EmptyWidget(),
    const EmptyWidget(),
    const EmptyWidget(),
    const EmptyWidget(),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorName.whiteColor,
          appBar: CustomAppBar(
            leadingWidth: 260,
            leadingWidget: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Assets.icons.motor.svg(),
                      const Gap(10),
                      Text(
                        "61 Hopper street..",
                        style: TextStyles.normalTextStyle,
                      ),
                      const Gap(10),

                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actionWidget: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => Assets.icons.basket.svg(),
                      loaded: (items) {
                        final totalCount = items.length;
                        return InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.cart),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Assets.icons.basket.svg(),
                              BasketWithBadger(
                                key: ValueKey(totalCount),
                                totalCount: totalCount,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              IndexedStack(index: currentIndex, children: _screens),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorColor: Colors.transparent, // remove default pill
                    indicatorShape: const StadiumBorder(), // not used now
                    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                      (states) => TextStyles.normalTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: states.contains(WidgetState.selected)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: states.contains(WidgetState.selected)
                            ? ColorName.primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                  child: NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    height: 70,
                    backgroundColor: Colors.white,
                    destinations: [
                      NavigationDestination(
                        icon: _buildNavIcon(Icons.home_outlined, 0),
                        label: "Home",
                      ),
                      NavigationDestination(
                        icon: _buildNavIcon(Icons.favorite_border, 1),
                        label: "Favorites",
                      ),
                      NavigationDestination(
                        icon: _buildNavIcon(Icons.search, 2),
                        label: "Search",
                      ),
                      NavigationDestination(
                        icon: _buildNavIcon(Icons.person_outline, 3),
                        label: "Profile",
                      ),
                      NavigationDestination(
                        icon: _buildNavIcon(Icons.menu, 4),
                        label: "Menu",
                      ),
                    ],
                  ),
                ),
              ),

              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loaded: (items) {
                      return CartSnackBar(items: items);
                    },
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ],
          ),
          // bottomNavigationBar: ,
        ),
      ],
    );
  }

  // custom widget builder
  Widget _buildNavIcon(IconData icon, int index) {
    final bool isSelected = currentIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSelected)
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: ColorName.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        Icon(icon, color: isSelected ? ColorName.primaryColor : Colors.grey),
      ],
    );
  }
}
