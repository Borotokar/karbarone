import 'package:adtrace_sdk_flutter/adtrace.dart';
import 'package:adtrace_sdk_flutter/adtrace_attribution.dart';
import 'package:adtrace_sdk_flutter/adtrace_config.dart';
import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/controller/SuportConversations%20Controller.dart';
import 'package:borotokar/pages/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:borotokar/controller/Conversations%20Controller%20.dart';
import 'package:borotokar/controller/DataBase%20Controller.dart';
import 'package:borotokar/controller/HomeController%20.dart';
import 'package:borotokar/controller/NotificationController.dart';
import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/controller/ProfileController%20.dart';
import 'package:borotokar/controller/Service%20Controller.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:borotokar/firebase_options.dart';
import 'package:borotokar/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 

    try {
      final config = AdTraceConfig(
        '7yvjwbmjji62', // توکن اپلیکیشن خودت از داشبورد AdTrace
        AdTraceEnvironment.sandbox // یا AdTraceEnvironment.production
      );

      // Callback Attribution AdTrace
      config.attributionCallback = (AdTraceAttribution attributionChangedData) {
        Get.log('[AdTrace]: Attribution changed!');
        if (attributionChangedData.trackerToken != null) {
          Get.log('[AdTrace]: Tracker token: ' + attributionChangedData.trackerToken!,);
        }
        if (attributionChangedData.trackerName != null) {
          Get.log('[AdTrace]: Tracker name: ' + attributionChangedData.trackerName!,);
        }
        if (attributionChangedData.campaign != null) {
          Get.log('[AdTrace]: Campaign: ' + attributionChangedData.campaign!);
        }
        if (attributionChangedData.network != null) {
          Get.log('[AdTrace]: Network: ' + attributionChangedData.network!);
        }
        if (attributionChangedData.creative != null) {
          Get.log('[AdTrace]: Creative: ' + attributionChangedData.creative!);
        }
        if (attributionChangedData.adgroup != null) {
          Get.log('[AdTrace]: Adgroup: ' + attributionChangedData.adgroup!);
        }
        if (attributionChangedData.clickLabel != null) {
          Get.log('[AdTrace]: Click label: ' + attributionChangedData.clickLabel!,);
        }
        if (attributionChangedData.adid != null) {
          Get.log('[AdTrace]: Adid: ' + attributionChangedData.adid!);
        }
        if (attributionChangedData.costType != null) {
          Get.log('[AdTrace]: Cost type: ' + attributionChangedData.costType!);
        }
        if (attributionChangedData.costAmount != null) {
          Get.log('[AdTrace]: Cost amount: ' + attributionChangedData.costAmount!.toString(),);
        }
        if (attributionChangedData.costCurrency != null) {
          Get.log('[AdTrace]: Cost currency: ' + attributionChangedData.costCurrency!,);
        }
      };

      AdTrace.start(config);
    } catch (e) {
      Get.log('adtrace Error: $e');
    }
  }

  @override
  void dispose() {
        WidgetsBinding.instance.removeObserver(this); 
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AdTrace.onResume();
        break;
      case AppLifecycleState.paused:
        AdTrace.onPause();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8), 
          child: child!,
        );
      },
      title: 'borotokar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'kalameh', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'kalameh', fontSize: 14),
          bodySmall: TextStyle (fontFamily: 'kalameh', fontSize: 12),
          displayLarge: TextStyle (fontFamily: 'kalameh', fontSize: 16),
          displayMedium: TextStyle(fontFamily: 'kalameh', fontSize: 14),
          displaySmall: TextStyle(fontFamily: 'kalameh', fontSize: 12),
          headlineLarge: TextStyle(fontFamily: 'kalameh', fontSize: 16),
          headlineMedium: TextStyle(fontFamily: 'kalameh', fontSize: 14),
          headlineSmall: TextStyle(fontFamily: 'kalameh', fontSize: 12),
          labelLarge: TextStyle (fontFamily: 'kalameh', fontSize: 12),
          labelMedium: TextStyle(fontFamily: 'kalameh', fontSize: 14),
          labelSmall: TextStyle (fontFamily: 'kalameh', fontSize: 12),
          titleLarge: TextStyle(fontFamily: 'kalameh', fontSize: 16),
          titleMedium: TextStyle(fontFamily: 'kalameh', fontSize: 14),
          titleSmall: TextStyle(fontFamily: 'kalameh', fontSize: 12),
        ),
      ),
      
            initialBinding: BindingsBuilder(() async {
        Get.put(AuthController(), permanent: true);
        Get.put(ConversationsController(), permanent: true);
        Get.put(DatabaseController(), permanent: true);
        Get.put(HomeController(), permanent: true);
        Get.put(NotificationController(), permanent: true);
        Get.put(OrderController(), permanent: true); 
        Get.put(ProfileController(), permanent: true);
        Get.put(ServiceController(), permanent: true); 
        Get.put(SuportConversationsController(), permanent: true);

                await SmsAutoFill().listenForCode;
        
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        
        await NotificationService.instance.initialize();
      }),
      
      home: const Directionality(
        textDirection: TextDirection.rtl, 
        child: SplashScreen(),
      ),
    );
  }
}
