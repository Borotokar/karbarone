import 'package:borotokar/pages/Mesage.dart';
import 'package:borotokar/pages/Orders.dart';
import 'package:borotokar/pages/notification.dart';
import 'package:borotokar/utils/mesage/mesagePage.dart';
import 'package:borotokar/utils/mesage/suportMesagePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // This is the background message handler
  Get.log('Handling a background message: ${message.data}');
  await NotificationService.instance.setupFlutterLocalNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotfications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await requestPermission();
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    if (token != null) {
      Get.log('Firebase Messaging Token: $token');
      print(token);
    } else {
      Get.log('Failed to get Firebase Messaging Token');
    }
  }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Get.log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Get.log('User granted provisional permission');
    } else {
      Get.log('User declined or has not accepted permission');
    }
  }

  Future<void> setupFlutterLocalNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotfications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final _InitializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotfications.initialize(
      _InitializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {
        Get.log('Notification tapped: ${details.payload}');
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotfications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            icon: '@mipmap/ic_launcher',

            // Add this to show notification as heads-up (on screen)
            ticker: 'ticker',
            playSound: true,
            enableVibration: true,
            enableLights: true,
            visibility: NotificationVisibility.public,
            priority: Priority.max,
            importance: Importance.max,
            fullScreenIntent: true,
          ),
        ),

        payload: message.data['payload'],
      );
    }
  }

  void handleNotificationRoute(RemoteMessage message) {
    Get.log('Notification data: ${message.data}');
    final type = message.data['type']?.toString();
    // final type = "notif";
    Get.log('Notification type: $type');
    if (type == "notif") {
      Get.to(() => NotifPage());
    } else if (type == "chat") {
      Get.to(() => MesaggPage());
    } else if (type == "support") {
      Get.to(() => suportMesagePage(id: 1));
    } else if (type == "order") {
      Get.to(() => OrdersPage());
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.log('Received a message while in the foreground: ${message.data}');
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.log('Message clicked! ${message.data}');
      handleNotificationRoute(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);

    // زمانی که اپ با نوتیف باز می‌شود
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationRoute(initialMessage);
    }
  }

  Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
    handleNotificationRoute(message);
  }

  Future<String> getToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      Get.log('Firebase Messaging Token: $token');
      return token;
    } else {
      Get.log('Failed to get Firebase Messaging Token');
      return '';
    }
  }
}
