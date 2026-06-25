import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_messaging_service.dart';
import 'local_notifications_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FirebaseMessagingService _fcm = FirebaseMessagingService();
  final LocalNotificationsService _local = LocalNotificationsService();
  final _onMessageController = StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onMessage => _onMessageController.stream;

  Future<void> init() async {
    await _local.init();

    final token = await _fcm.init();
    if (token != null) _onToken(token);

    _fcm.onTokenRefresh.listen(_onToken);

    _fcm.onMessage.listen((message) {
      _onMessageController.add(message);
      _local.show(message);
    });

    _fcm.onMessageOpenedApp.listen((message) {
      _onMessageController.add(message);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageController.add(initialMessage);
    }
  }

  void _onToken(String token) {
    // Send token to backend
  }
}
