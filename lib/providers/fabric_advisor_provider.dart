import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fabric_advisor/fabric_prediction_model.dart';
import '../services/fabric_advisor_service.dart';

class FabricAdvisorState {
  final bool isLoading;
  final FabricPrediction? prediction;
  final String? errorMessage;

  FabricAdvisorState({
    this.isLoading = false,
    this.prediction,
    this.errorMessage,
  });

  FabricAdvisorState copyWith({
    bool? isLoading,
    FabricPrediction? prediction,
    String? errorMessage,
  }) {
    return FabricAdvisorState(
      isLoading: isLoading ?? this.isLoading,
      prediction: prediction ?? this.prediction,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FabricAdvisorNotifier extends Notifier<FabricAdvisorState> {
  final FabricAdvisorService _service = FabricAdvisorService();

  @override
  FabricAdvisorState build() {
    return FabricAdvisorState();
  }

  Future<void> predict(File image, String? description) async {
    state = state.copyWith(isLoading: true, errorMessage: null, prediction: null);
    
    try {
      final result = await _service.predictFabric(
        image: image,
        description: description,
      );
      state = state.copyWith(isLoading: false, prediction: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void reset() {
    state = FabricAdvisorState();
  }
}

final fabricAdvisorProvider = NotifierProvider<FabricAdvisorNotifier, FabricAdvisorState>(() {
  return FabricAdvisorNotifier();
});
