import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantModel {
  final String id;
  final String name;
  final double distance;
  final double rating;

  MerchantModel({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
  });
}

class MerchantState {
  final List<MerchantModel> availableMerchants;
  final bool isLoading;

  MerchantState({
    this.availableMerchants = const [],
    this.isLoading = false,
  });

  MerchantState copyWith({
    List<MerchantModel>? availableMerchants,
    bool? isLoading,
  }) {
    return MerchantState(
      availableMerchants: availableMerchants ?? this.availableMerchants,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MerchantNotifier extends Notifier<MerchantState> {
  @override
  MerchantState build() {
    return MerchantState();
  }

  void setMerchants(List<MerchantModel> merchants) {
    state = state.copyWith(availableMerchants: merchants, isLoading: false);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final merchantProvider = NotifierProvider<MerchantNotifier, MerchantState>(() {
  return MerchantNotifier();
});
