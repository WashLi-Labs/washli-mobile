import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentType {
  points,
  touch,
  lankaQr,
  card,
}

class PaymentState {
  final PaymentType selectedType;
  final String? selectedCardNickname;
  final List<String> savedCards;

  PaymentState({
    this.selectedType = PaymentType.points,
    this.selectedCardNickname,
    this.savedCards = const [],
  });

  PaymentState copyWith({
    PaymentType? selectedType,
    String? selectedCardNickname,
    List<String>? savedCards,
  }) {
    return PaymentState(
      selectedType: selectedType ?? this.selectedType,
      selectedCardNickname: selectedCardNickname ?? this.selectedCardNickname,
      savedCards: savedCards ?? this.savedCards,
    );
  }

  String get displayName {
    switch (selectedType) {
      case PaymentType.points:
        return 'Points';
      case PaymentType.touch:
        return 'Touch';
      case PaymentType.lankaQr:
        return 'Pay with LANKAQR';
      case PaymentType.card:
        return selectedCardNickname ?? 'Card';
    }
  }

  String get iconPath {
    switch (selectedType) {
      case PaymentType.points:
        return 'assets/icons/points_payment.png';
      case PaymentType.touch:
        return 'assets/icons/touch_payment.png';
      case PaymentType.lankaQr:
        return 'assets/icons/qr_payment.png';
      case PaymentType.card:
        return 'assets/icons/card_payment_icon.png';
    }
  }

  bool get isSvg {
    return false; // Based on current project assets being mostly png for these
  }
}

class PaymentNotifier extends Notifier<PaymentState> {
  @override
  PaymentState build() {
    return PaymentState();
  }

  void selectMethod(PaymentType type, {String? cardNickname}) {
    state = state.copyWith(
      selectedType: type,
      selectedCardNickname: cardNickname,
    );
  }

  void addCard(String nickname) {
    if (state.savedCards.length < 3) {
      state = state.copyWith(
        savedCards: [...state.savedCards, nickname],
      );
    }
  }

  void removeCard(String nickname) {
    final updatedCards = state.savedCards.where((c) => c != nickname).toList();
    
    // If the removed card was selected, fallback to points
    PaymentType newType = state.selectedType;
    String? newCardNickname = state.selectedCardNickname;
    
    if (state.selectedType == PaymentType.card && state.selectedCardNickname == nickname) {
      newType = PaymentType.points;
      newCardNickname = null;
    }

    state = state.copyWith(
      savedCards: updatedCards,
      selectedType: newType,
      selectedCardNickname: newCardNickname,
    );
  }
}

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(() => PaymentNotifier());
