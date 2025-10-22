// custom_keyboard_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../utils/credit_card_formatter.dart';
import '../utils/expiry_date_formatter.dart';

enum FocusTarget { cardNumber, expiry, cvv, none }

class PaymentState extends Equatable {
  final int selectedPaymentMethodIndex;
  final bool isKeyboardVisible;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final FocusTarget nextFocusRequest;

  // 👇 Add focus nodes
  final FocusNode cardNumberFocus;
  final FocusNode expiryFocus;
  final FocusNode cvvFocus;

  //Process Complete
  final bool isProcessComplete;

  const PaymentState({
    this.selectedPaymentMethodIndex = 0,
    this.isKeyboardVisible = false,
    this.isProcessComplete = false,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.cardNumberFocus,
    required this.expiryFocus,
    required this.cvvFocus,
    this.nextFocusRequest = FocusTarget.none,
  });

  bool get isCreditCardSelected => selectedPaymentMethodIndex == 2;

  // 👇 Determine which controller is active
  TextEditingController? get activeController {
    if (cardNumberFocus.hasFocus) return cardNumberController;
    if (expiryFocus.hasFocus) return expiryController;
    if (cvvFocus.hasFocus) return cvvController;
    return null;
  }

  @override
  List<Object?> get props => [
    selectedPaymentMethodIndex,
    isKeyboardVisible,
    cardNumberController.text,
    // 👈 compare by text, not controller instance
    expiryController.text,
    cvvController.text,
    cardNumberFocus.hasFocus,
    expiryFocus.hasFocus,
    cvvFocus.hasFocus,
    nextFocusRequest,
    isProcessComplete
  ];

  PaymentState copyWith({
    int? selectedPaymentMethodIndex,
    bool? isKeyboardVisible,
    bool? isProcessComplete,
    FocusTarget? nextFocusRequest,
  }) {
    return PaymentState(
      selectedPaymentMethodIndex:
          selectedPaymentMethodIndex ?? this.selectedPaymentMethodIndex,
      isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
      cardNumberController: cardNumberController,
      expiryController: expiryController,
      cvvController: cvvController,
      cardNumberFocus: cardNumberFocus,
      expiryFocus: expiryFocus,
      cvvFocus: cvvFocus,
      nextFocusRequest: nextFocusRequest ?? this.nextFocusRequest,
      isProcessComplete: isProcessComplete ?? this.isProcessComplete,
    );
  }
}

class CustomKeyboardCubit extends Cubit<PaymentState> {
  CustomKeyboardCubit()
    : super(
        PaymentState(
          cardNumberController: TextEditingController(),
          expiryController: TextEditingController(),
          cvvController: TextEditingController(),
          cardNumberFocus: FocusNode(),
          expiryFocus: FocusNode(),
          cvvFocus: FocusNode(),
        ),
      );

  void selectPaymentMethod(int index) {
    final newState = state.copyWith(selectedPaymentMethodIndex: index);
    // Show keyboard only if credit card is selected
    if (newState.isCreditCardSelected) {
      emit(newState.copyWith(isKeyboardVisible: true));
    } else {
      emit(newState.copyWith(isKeyboardVisible: false));
    }
  }

  void toggleKeyboardVisibility() {
    emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible));
  }

  void postTextInput(String text) {
    final controller = state.activeController;
    if (controller == null) return;

    // Get raw digits (remove formatting like spaces or slashes)
    String currentRaw = controller.text.replaceAll(RegExp(r'\D'), '');

    if (text == "⌫") {
      // Delete last digit
      if (currentRaw.isNotEmpty) {
        currentRaw = currentRaw.substring(0, currentRaw.length - 1);
      }
    } else if (text == "+*#") {
      // Ignore
      return;
    } else {
      // Add new digit (only if within limit)
      if (state.activeController == state.cardNumberController &&
          currentRaw.length >= 16) {
        return;
      }
      if (state.activeController == state.expiryController &&
          currentRaw.length >= 4) {
        return;
      }
      if (state.activeController == state.cvvController &&
          currentRaw.length >= 3) {
        return; // CVV max 4
      }

      currentRaw += text;
    }

    // Format based on field type
    String formattedText;
    if (state.activeController == state.cardNumberController) {
      formattedText = CreditCardFormatter.format(currentRaw);
    } else if (state.activeController == state.expiryController) {
      formattedText = ExpiryDateFormatter.format(currentRaw);
    } else {
      // CVV: just digits, no formatting (or limit to 3/4)
      formattedText = currentRaw;
    }

    // Update controller
    controller.text = formattedText;

    // Optional: move cursor to end
    controller.selection = TextSelection.collapsed(
      offset: formattedText.length,
    );

    // 👇 AUTO-FOCUS NEXT FIELD WHEN FULL
    FocusTarget next = FocusTarget.none;
    bool isProcessComplete = false;
    if (state.activeController == state.cardNumberController &&
        currentRaw.length == 16) {
      next = FocusTarget.expiry;
    } else if (state.activeController == state.expiryController &&
        currentRaw.length == 4) {
      next = FocusTarget.cvv;
    } else if (state.activeController == state.cvvController &&
        currentRaw.length == 3) {
      isProcessComplete = true;
    }
    // Emit updated state (including focus request)
    emit(
      state.copyWith(
        nextFocusRequest: next,
        isProcessComplete: isProcessComplete,
      ),
    );
  }

  void resetFocusRequest() {
    if (state.nextFocusRequest != FocusTarget.none) {
      emit(state.copyWith(nextFocusRequest: FocusTarget.none));
    }
  }

  void goToCheckout(BuildContext context) {
    // You can emit a state or just navigate directly
    // Navigation is a side effect, so it's okay to do here or in UI
  }

  @override
  Future<void> close() {
    state.cardNumberController.dispose();
    state.expiryController.dispose();
    state.cvvController.dispose();
    state.cardNumberFocus.dispose();
    state.expiryFocus.dispose();
    state.cvvFocus.dispose();
    return super.close();
  }
}
