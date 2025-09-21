import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../utils/utils.dart';
import '../../home/logic/cart_cubit.dart';
import '../../home/logic/cart_state.dart';
import '../../home/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List of screens/widgets corresponding to each tab
  final List<Widget> _screens = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Gap(10),
                  Text(
                    "61 Hopper street..",
                    style: TextStyles.normalTextStyle,
                  ),
                  Gap(10),

                  /// TODO add action icon for location
                  Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ],
              ),
            ],
          ),
        ),
        actionWidget: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 15,vertical: 10),
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => Assets.icons.basket.svg(),
                  loaded: (items) {
                    final totalCount = items.length;
                    return InkWell(
                      onTap: () => Utils.cartIconAction(context),
                      child: Stack(
                          clipBehavior: Clip.none,
                        children: [
                          Assets.icons.basket.svg(),
                          if (totalCount > 0)
                            Positioned(
                              top: -8,
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: NavigationBarTheme(
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
