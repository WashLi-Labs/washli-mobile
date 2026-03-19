import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletState {
  final double pointsBalance;
  final String currency;

  WalletState({
    this.pointsBalance = 0.0,
    this.currency = 'LKR',
  });

  WalletState copyWith({
    double? pointsBalance,
    String? currency,
  }) {
    return WalletState(
      pointsBalance: pointsBalance ?? this.pointsBalance,
      currency: currency ?? this.currency,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    return WalletState();
  }

  void addPoints(double amount) {
    state = state.copyWith(pointsBalance: state.pointsBalance + amount);
  }

  void deductPoints(double amount) {
    if (state.pointsBalance >= amount) {
      state = state.copyWith(pointsBalance: state.pointsBalance - amount);
    }
  }

  void setBalance(double balance) {
    state = state.copyWith(pointsBalance: balance);
  }
}

final walletProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});
