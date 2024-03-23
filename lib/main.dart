import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:galaxia/providers/local_notification_service.dart';
import 'package:galaxia/providers/profile_setup_provider.dart';

import 'package:galaxia/stacks/onboarding.dart';

import 'package:is_first_run/is_first_run.dart';
import 'package:galaxia/stacks/app.dart';

import 'package:galaxia/stacks/authentication.dart';

import 'package:provider/provider.dart';

import 'package:galaxia/store/galaxia_store.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'firebase_options.dart';

const galaxiaStorage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: "assets/.env");
  Stripe.init(dotenv.env["STRIPE_PUBLISHABLE_KEY"]!);
  runApp(ChangeNotifierProvider(
    create: (_) => ProfileSetupProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
  // This widget is the root of your application.
}

class MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;

  bool? firstRun;
  checkFirstRun() async {
    bool value = await IsFirstRun.isFirstCall();
    setState(() {
      firstRun = value;
    });
  }

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });

    checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: galaxiaStore,
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: darkTheme,
            color: grayscale[100],
            home: Scaffold(
                extendBody: true,
                body: (firstRun != null && firstRun == true && _user == null)
                    ? const OnBoarding()
                    : _user == null
                        ? const Authentication()
                        : const App())));
  }
}
