import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:products/features/home/logic/cart_cubit.dart';
import 'package:products/features/home/logic/cart_state.dart';
import '../../../core/model/cart_model.dart';
import '../../../gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartListView extends StatefulWidget {
  const CartListView({super.key, required this.items});

  final List<CartModel> items;

  @override
  State<CartListView> createState() => _CartListViewState();
}

class _CartListViewState extends State<CartListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  int prevItems = 0;
  int currItems = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: BlocListener<CartCubit, CartState>(
          listenWhen: (prev, curr) {
            prev.whenOrNull(loaded: (items) => prevItems = items.length);
            curr.whenOrNull(loaded: (items) => currItems = items.length);
            return prevItems != currItems;
          },
          listener: (context, state) {
            state.whenOrNull(
              loaded: (items) {
                if (prevItems < currItems) {
                  _listKey.currentState?.insertItem(items.length - 1);
                } else if (prevItems > currItems) {
                  final removedIndex = prevItems - 1;
                  final removedItem = widget.items[removedIndex];
                  _listKey.currentState?.removeItem(
                    removedIndex,
                    (context, animation) => FadeTransition(
                      opacity: animation,
                      child: _buildItem(removedItem, context),
                    ),
                  );
                }
              },
            );
          },
          child: AnimatedList(
            key: _listKey,
            scrollDirection: Axis.horizontal,
            initialItemCount: widget.items.length,
            itemBuilder: (context, index, animation) {
              final cart = widget.items[index];
              return _build(context, index, cart);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(CartModel cart, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: ColorName.whiteColor,
            child: Hero(
              tag: "_${cart.product.id}",
                child: cart.product.image.image(height: 38)),
          ),

          // ✅ Quantity badge with animation
          if (cart.totalItems > 1)
            Positioned(
              top: -5,
              right: -1,
              child: TweenAnimationBuilder<double>(
                key: ValueKey(cart.totalItems),
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
                    border: Border.fromBorderSide(
                      BorderSide(color: ColorName.primaryColor, width: 2.5),
                    ),
                  ),
                  child: Text(
                    cart.totalItems.toString(),
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
  }

  _build(context, index, cart) {
    return index == 0
        ? _buildItem(cart, context)
        : Animate(
            effects: [FadeEffect(), SlideEffect()],
            child: _buildItem(
              cart,
              context,
            ).animate().slide(begin: Offset(2, 0.5), end: Offset(0, 0)),
          );
  }
}
