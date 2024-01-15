import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignIn extends StatefulWidget {
  final Function toggleview;
  SignIn({required this.toggleview});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late AnimationController _controller;
  late Animation<double> _growAnimation;

  late AnimationController _controllerForm;
  late Animation<double> _growAnimationForm;

  var _obscurePasswordField = true;

  var _errorPasswordString;
  var _errorUsernameString;

  late AuthService _auth;
  bool _loading = false;

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _controllerForm = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _growAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _growAnimationForm = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controllerForm, curve: Curves.fastOutSlowIn));
    _controller.forward();
    _controllerForm.forward();
    _auth = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return containsLogin(context, _width, _height);
  }

  Widget containsLogin(BuildContext context, double _width, double _height) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? LoadingPage()
          : Stack(
              children: <Widget>[
                SafeArea(
                  child: Align(
                    alignment: Alignment.center,
                    child: containsForm(context, _width, _height),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Align(
                    child: _keyboardIsVisible()
                        ? Container()
                        : _lotsOfLove(context, _width, _height),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
    );
  }

  Widget containsForm(BuildContext context, double _width, double _height) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          AnimatedBuilder(
            animation: _growAnimation,
            child: containsBranding(context, _width, _height),
            builder: (context, child) {
              return Transform.scale(
                child: child,
                scale: (1 - _growAnimation.value),
              );
            },
          ),
          AnimatedBuilder(
              animation: _growAnimationForm,
              child: containsFormFields(context, _width, _height),
              builder: (context, child) {
                return Transform.translate(
                  child: child,
                  offset: Offset(0, _height * _growAnimationForm.value),
                );
              }),
        ],
      ),
    );
  }

  Widget containsFormFields(
      BuildContext context, double _width, double _height) {
    return Column(
      children: <Widget>[
        Container(
          width: _width * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Username',
                errorText: _errorUsernameString,
                prefixIcon: Icon(Icons.person)),
            controller: _usernameController,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: _width * 0.75,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _errorPasswordString,
              prefixIcon: Icon(Icons.vpn_key),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePasswordField = !_obscurePasswordField;
                  });
                },
                icon: _obscurePasswordField
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
              ),
            ),
            controller: _passwordController,
            obscureText: _obscurePasswordField,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: _width * 0.60,
          height: 40.0,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              "Log In",
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () async {
              if (_validateUsername() && _validatePassword()) {
                setState(() {
                  _loading = !_loading;
                });
                Map<String, String> dataMap = {
                  'username': _usernameController.text,
                  'password': _passwordController.text
                };
                var res = await _auth.signInWithEmailPassword(dataMap);
                print("Signed IN!! with $res");
                if (res == 0) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => AlertDialog(
                            content: Text((res == -2)
                                ? "Incorrect Credentials"
                                : "Unable to connect to Server"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                }
                setState(() {
                  _loading = false;
                });
              }
              return;
            },
          ),
        ),
        SizedBox(
          height: _height * 0.02,
        ),
        Container(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Having trouble signing in?"),
                InkWell(
                  onTap: () async {
                    String url = EndPoints.HOST + EndPoints.FORGOT_PASS;
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    " Contact IMG",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget containsBranding(BuildContext context, double _width, double _height) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: _width * 0.15,
              height: _width * 0.15,
              child: Image.asset("assets/channeliLogo.png"),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              Strings.BRANDING,
              style: TextStyle(
                  color: Colors.blueAccent[200], fontSize: _width * 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lotsOfLove(BuildContext context, double _width, double _height) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Made With ",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        Text(
          " by IMG",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  bool _validatePassword() {
    var isPasswordEmpty =
        _passwordController.text == null || _passwordController.text == '';
    if (isPasswordEmpty) {
      setState(() {
        _errorPasswordString = 'Password can not be empty';
      });
    }
    return !isPasswordEmpty;
  }

  bool _validateUsername() {
    var isUsernameEmpty =
        _usernameController.text == null || _usernameController.text == '';
    if (isUsernameEmpty) {
      setState(() {
        _errorUsernameString = 'Username can not be empty';
      });
    }
    return !isUsernameEmpty;
  }
}
