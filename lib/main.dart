import 'package:commuting_app_mobile/dto/account/account_response.dart';
import 'package:commuting_app_mobile/dto/account/add_fcm_token_request.dart';
import 'package:commuting_app_mobile/dto/notification/notification_type.dart';
import 'package:commuting_app_mobile/provider/active_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/active_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/car_provider.dart';
import 'package:commuting_app_mobile/provider/location_provider.dart';
import 'package:commuting_app_mobile/provider/notification_provider.dart';
import 'package:commuting_app_mobile/provider/past_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/past_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/past_trips_provider.dart';
import 'package:commuting_app_mobile/provider/profile_provider.dart';
import 'package:commuting_app_mobile/provider/trip_position_provider.dart';
import 'package:commuting_app_mobile/provider/trip_request_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/account/name_input.dart';
import 'package:commuting_app_mobile/screens/account/phone_input.dart';
import 'package:commuting_app_mobile/screens/account/phone_verification.dart';
import 'package:commuting_app_mobile/screens/account/welcome_screen.dart';
import 'package:commuting_app_mobile/screens/trips.dart';
import 'package:commuting_app_mobile/services/account_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/services/prefs_service.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  timeago.setLocaleMessages('ro', timeago.RoMessages());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
    ChangeNotifierProvider<CarProvider>(create: (_) => CarProvider()),
    ChangeNotifierProvider<TripRequestProvider>(
        create: (_) => TripRequestProvider()),
    ChangeNotifierProvider<UpcomingPassengerTripProvider>(
        create: (_) => UpcomingPassengerTripProvider()),
    ChangeNotifierProvider<UpcomingDriverTripProvider>(
        create: (_) => UpcomingDriverTripProvider()),
    ChangeNotifierProvider<ActivePassengerTripProvider>(
        create: (_) => ActivePassengerTripProvider()),
    ChangeNotifierProvider<ActiveDriverTripProvider>(
        create: (_) => ActiveDriverTripProvider()),
    ChangeNotifierProvider<PastPassengerTripProvider>(
        create: (_) => PastPassengerTripProvider()),
    ChangeNotifierProvider<PastDriverTripProvider>(
        create: (_) => PastDriverTripProvider()),
    ChangeNotifierProvider<NotificationProvider>(
        create: (_) => NotificationProvider()),
    ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
    ChangeNotifierProvider<TripPositionProvider>(
        create: (_) => TripPositionProvider()),
    ChangeNotifierProvider<TripRequestsProvider>(
        create: (_) => TripRequestsProvider()),
    ChangeNotifierProvider<UpcomingTripsProvider>(
        create: (_) => UpcomingTripsProvider()),
    ChangeNotifierProvider<PastTripsProvider>(
        create: (_) => PastTripsProvider()),
    ChangeNotifierProvider<ActiveTripsProvider>(
        create: (_) => ActiveTripsProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var prefsService = locator.get<PrefsService>();
  var tokenService = locator.get<TokenService>();
  var accountService = locator.get<AccountService>();
  var notificationService = locator.get<NotificationService>();

  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    notificationService.setMessengerKey(_messengerKey);
    notificationService.setNavKey(navigatorKey);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
        NotificationType? notificationType =
        EnumToString.fromString(NotificationType.values, event.data['type']);
        String entityId = event.data['entity'];
        await notificationService.refreshContent(context, notificationType, entityId);
        notificationService.showNotificationSnackbar(
            context, event.notification!.body!, notificationType, entityId);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      NotificationType? notificationType =
          EnumToString.fromString(NotificationType.values, event.data['type']);
      String entityId = event.data['entity'];
      notificationService.openScreen(context, notificationType, entityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _messengerKey,
        navigatorKey: navigatorKey,
        title: 'Commuting',
        theme: ThemeData(fontFamily: 'Poppins', primarySwatch: kPrimaryColor),
        locale: Locale.fromSubtags(languageCode: "ro"),
        localizationsDelegates: [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('ro', ''),
        ],
        home: _buildApp());
  }

  Widget _buildApp() {
    return FutureBuilder(
        future: _retrieveInitialData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return WelcomeScreen();
            }

            AccountResponse? account = snapshot.data;

            if (account == null) {
              return WelcomeScreen();
            }
            if (account.firstName == null) {
              return NameInput();
            }
            if (account.phoneNumber == null) {
              return PhoneInput();
            }
            if (account.phoneNumberVerified == null ||
                !account.phoneNumberVerified!) {
              return PhoneVerification(account.phoneNumber);
            }

            return FutureBuilder(
              future: sendFcmTokenAndGetProfile(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Trips();
                } else {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Future sendFcmTokenAndGetProfile() async {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    String? token = await FirebaseMessaging.instance.getToken();
    await accountService.addFcmToken(new AddFcmTokenRequest(token: token!));
    await profileProvider.getProfile();
    return Future.value(true);
  }

  Future<AccountResponse?> _retrieveInitialData() async {
    await prefsService.buildPreferences();
    await tokenService.retrieveTokens();
    if (tokenService.accessToken == null) {
      return null;
    }
    AccountResponse? accountResponse = await accountService.getAccount();
    if (accountResponse == null) {
      await accountService.reissueTokens();
      accountResponse = await accountService.getAccount();
    }
    return accountResponse;
  }
}
