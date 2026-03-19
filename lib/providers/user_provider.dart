import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String? uid;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? token;
  final bool isAuthenticated;

  UserState({
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.token,
    this.isAuthenticated = false,
  });

  UserState copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? token,
    bool? isAuthenticated,
  }) {
    return UserState(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return UserState();
  }

  void login({
    required String uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? token,
  }) {
    state = state.copyWith(
      uid: uid,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      token: token,
      isAuthenticated: true,
    );
  }

  void logout() {
    state = UserState();
  }

  void updateProfile({String? name, String? email, String? phoneNumber}) {
    state = state.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
