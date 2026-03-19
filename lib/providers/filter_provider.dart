import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final String searchQuery;
  final double maxDistance;
  final List<String> selectedServices;

  FilterState({
    this.searchQuery = '',
    this.maxDistance = 10.0,
    this.selectedServices = const [],
  });

  FilterState copyWith({
    String? searchQuery,
    double? maxDistance,
    List<String>? selectedServices,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      maxDistance: maxDistance ?? this.maxDistance,
      selectedServices: selectedServices ?? this.selectedServices,
    );
  }
}

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() {
    return FilterState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDistance(double distance) {
    state = state.copyWith(maxDistance: distance);
  }

  void toggleService(String service) {
    final currentServices = List<String>.from(state.selectedServices);
    if (currentServices.contains(service)) {
      currentServices.remove(service);
    } else {
      currentServices.add(service);
    }
    state = state.copyWith(selectedServices: currentServices);
  }
  
  void clearFilters() {
    state = FilterState();
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterState>(() {
  return FilterNotifier();
});
