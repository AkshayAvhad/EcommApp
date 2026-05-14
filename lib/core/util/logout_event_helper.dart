import 'dart:async';

class LogoutEventHelper {
  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get logoutStream => _controller.stream;

  static void triggerLogout() => _controller.add(null);
}
