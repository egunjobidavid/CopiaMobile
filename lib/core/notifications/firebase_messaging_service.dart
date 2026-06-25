import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _tokenController = StreamController<String>.broadcast();
  final _messageController = StreamController<RemoteMessage>.broadcast();

  Stream<String> get onTokenRefresh => _tokenController.stream;
  Stream<RemoteMessage> get onMessage => _messageController.stream;
  Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;

  Future<String?> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true, badge: true, sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await _fcm.getToken();
      if (token != null) _tokenController.add(token);

      _fcm.onTokenRefresh.listen((t) => _tokenController.add(t));
      FirebaseMessaging.onMessage.listen((m) => _messageController.add(m));

      return token;
    }
    return null;
  }

  void dispose() {
    _tokenController.close();
    _messageController.close();
  }
}
