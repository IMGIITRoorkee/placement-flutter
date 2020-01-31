import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:placement/resources/strings.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/loadingPage.dart';

class SignIn extends StatefulWidget {

  final Function toggleview;
  SignIn({this.toggleview});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AnimationController _controller;
  Animation<double> _growAnimation;

  AnimationController _controllerForm;
  Animation<double> _growAnimationForm;

  var _obscurePasswordField = true;

  var _errorPasswordString;
  var _errorUsernameString;

  AuthService _auth;
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
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn
      )
    );
    _growAnimationForm = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controllerForm,
        curve: Curves.fastOutSlowIn
      )
    );
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
    return _loading ? LoadingPage() : Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
              child: _keyboardIsVisible() ? Container() : _lotsOfLove(context, _width, _height),
              alignment: Alignment.bottomCenter,
            )
          ),
        ],
      ),
    );
  }

  Widget containsForm(BuildContext context, double _width,double _height) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          AnimatedBuilder(
            animation: _growAnimation,
            child: containsBranding(context, _width, _height),
            builder: (context,child) {
              print(1-_growAnimation.value);
              return Transform.scale(
                child: child,
                scale: (1-_growAnimation.value),
              );
            },
          ),
          AnimatedBuilder(
            animation: _growAnimationForm,
            child: containsFormFields(context, _width, _height),
            builder: (context,child) {
              return Transform.translate(
                child: child,
                offset: Offset(0, _height*_growAnimationForm.value),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget containsFormFields(BuildContext context, double _width,double _height) {
        return Column(
          children: <Widget>[
            Container(
              width: _width*0.75,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: _errorUsernameString,
                  prefixIcon: Icon(Icons.person)
                ),
                controller: _usernameController,
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: _width*0.75,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _errorPasswordString,
                  prefixIcon: Icon(Icons.vpn_key),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePasswordField = ! _obscurePasswordField;
                      });
                    },
                    icon: _obscurePasswordField ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                  ),
                ),
                controller: _passwordController,
                obscureText: _obscurePasswordField,
          ),
        ),
        SizedBox(height: _height*0.04,),
        ButtonTheme(height: 40.0,
          minWidth: _width*0.60,
          child: RaisedButton(
            highlightColor: Colors.blueAccent[100],
            splashColor: Colors.blue,
            child: Text(
              "Log In",
              style: TextStyle(
                fontSize: 17.0
              ),
              ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0)
            ),
            onPressed: () {
              if( _validateUsername() && _validatePassword() ) {
                setState(() {
                  _loading = ! _loading;
                });
                Map<String,String> dataMap = {
                  'username' : _usernameController.text,
                  'password' : _passwordController.text
                };
                // if(_auth.signInWithEmailPassword(dataMap) == 0) {
                //   return;
                // }
                Navigator.of(context).pushNamedAndRemoveUntil('/home',(Route<dynamic> route)=>false);
                setState(() {
                  _loading = false ;
                });
              }
              return;
            },
          )
        ),
        SizedBox(height: _height*0.02,),
        Container(
          width: _width*0.60,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Having trouble signing in?"
                ),
                Text(
                  " Contact IMG",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget containsBranding(BuildContext context, double _width,double _height) {
    return Container(
      alignment: Alignment.center,
      child:
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.feedback,
              size: _width*0.15,
              color: Colors.blueAccent[200],
              ),
          ),
          Expanded(
            flex: 2,
            child:Text(
              Strings.BRANDING,
              style: TextStyle(
                color: Colors.blueAccent[200],
                fontSize: _width*0.1
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _lotsOfLove(BuildContext context, double _width,double _height) {
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
    var isPasswordEmpty = _passwordController.text == null || _passwordController.text == '';
    if(isPasswordEmpty) {
      setState(() {
        _errorPasswordString = 'Password can not be null';
      });
    }
    return !isPasswordEmpty;
  }

  bool _validateUsername() {
    var isUsernameEmpty = _usernameController.text == null || _usernameController.text == '';
    if(isUsernameEmpty) {
      setState(() {
        _errorUsernameString = 'Username can not be null';
      });
    }
    return !isUsernameEmpty;
  }
}
