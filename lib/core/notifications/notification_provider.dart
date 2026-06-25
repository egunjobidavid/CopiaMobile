import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final fcmTokenProvider = StateProvider<String?>((ref) => null);

final lastNotificationProvider = StateProvider<RemoteMessage?>((ref) => null);

final notificationInitProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  await service.init();

  service.onMessage.listen((message) {
    ref.read(lastNotificationProvider.notifier).state = message;
  });
});
