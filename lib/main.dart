import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Auto Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();

  bool isLoggedIn = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool logged = prefs.getBool('logged') ?? false;

    if (logged != false) {
      setState(() {
        isLoggedIn = true;
        name = prefs.getString('username') ?? 'No name yet';
      });
      return;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', false);
    setState(() {
      name = '';
      isLoggedIn = false;
    });
  }

  Future<void> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', true);
    prefs.setString('username', nameController.text);
    setState(() {
      name = nameController.text;
      isLoggedIn = true;
    });
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Login Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !isLoggedIn
                ? TextField(
                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter your name',
                    ))
                : Text('You are logged in as $name'),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                isLoggedIn ? logout() : loginUser();
              },
              child: isLoggedIn ? const Text('logout') : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
