import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../classes/http_exception.dart';
import '../../provider/app_theme.dart';
import '../../provider/auth.dart';
import '../../widget/main_drawer.dart';
import '../navigation_bottom_screen.dart';

enum AuthMode { VerificationCode, Login }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      backgroundColor: Color(0xffF9F9F9),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: MainDrawer(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height - 80,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  top: -deviceSize.height * 0.1,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.4,
                          0.54,
                          0.7
                        ],
                        colors: [
                          Colors.white.withOpacity(1),
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(1)
                        ]).createShader(bounds),
                    child: Image.asset(
                      'assets/images/login_bg.png',
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned(
                top: deviceSize.height * 0.1,
                left: 0,
                right: 0,
                child: Text(
                  'تاپ سالن',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'BFarnaz',
                    fontStyle: FontStyle.normal,
                    fontSize: textScaleFactor * 35.0,
                  ),
                ),
              ),
              Positioned(
                top: deviceSize.height * 0.4,
                child: Container(
                  height: deviceSize.height * 0.99,
                  width: deviceSize.width,
                  child: AuthCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.VerificationCode;
  Map<String, String> _authData = {
    'phoneNumber': '',
    'verificationCode': '',
  };

  var _isLoading = false;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation1;
  Animation<double> _opacityAnimation1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation1 = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-3, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation1 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('مشکل در ورود'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('تایید'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.VerificationCode) {
        print('VerificationCode');

        await Provider.of<Auth>(context, listen: false).sendSMS(
          _authData['phoneNumber'],
        );

        print('veriiiii');

        _switchAuthMode();
      } else {
        print('loginmode');
        var response =
            await Provider.of<Auth>(context, listen: false).authenticate(
          _authData['verificationCode'],
          _authData['phoneNumber'],
        );
        if (response) {
//          Navigator.of(context).pushNamed('/');
          Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationBottomScreen.routeName,
              (Route<dynamic> route) => false);
        } else {
          _showErrorDialog('کد وارد شده صحیح نمیباشد');
        }
      }
    } on HttpException catch (error) {
      var errorMessage = 'ارتباط برقرار نشد.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'ارتباط برقرار نشد، لطفا دوباره تلاش کنید.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    print('swotchMode');
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.VerificationCode;
//        _controller.reverse();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _controller.forward();
      });
    }
  }

  void _switchPhoneCorrectMode() {
    print('swotchMode');
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.VerificationCode;
        _controller.reverse();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      width: deviceSize.width * 0.4,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AnimatedContainer(
                    duration: _controller.duration,
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Center(
                            child: Text(
                              'کد دریافتی را وارد نمایید',
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 11.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: _controller.duration,
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation1,
                      child: SlideTransition(
                          position: _slideAnimation1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Center(
                              child: Text(
                                'برای ورود شماره تلفن همراه را وارد نمایید',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12.0,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  AnimatedContainer(
                    duration: _controller.duration,
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Center(
                          child: Container(
//                            height: 50,
                            width: deviceSize.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.blue, width: 1.5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
//                                            filled: true,
//                                            fillColor: Colors.white,
                                      border: InputBorder.none,
                                      suffix: Text(''),
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 15.0,
                                      ),
                                    ),
                                    onFieldSubmitted: (String text) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _submit();
                                    },
                                    keyboardType: TextInputType.phone,
                                    validator: _authMode == AuthMode.Login
                                        ? (value) {
                                            _authData['verificationCode'] =
                                                value;
                                          }
                                        : null,
                                  ),
                                  Positioned(
                                      right: 3,
                                      top: 5,
                                      bottom: 12,
                                      child: Icon(
                                        Icons.phone_android,
                                        color: AppTheme.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: _controller.duration,
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation1,
                      child: SlideTransition(
                        position: _slideAnimation1,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: deviceSize.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.blue, width: 1.5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
//                                          filled: true,
//                                          fillColor: Colors.white,
                                      border: InputBorder.none,
                                      suffix: Text(''),
                                      focusColor: Colors.white,
                                      counterStyle: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.dashed,
                                        color: Colors.grey,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 18.0,
                                      ),
                                    ),
                                    onTap: () {
                                      _formKey.currentState.reset();
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.phone,
                                    onFieldSubmitted: (String text) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _submit();
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'لطفا شماره تلفن را وارد نمایید';
                                      }
                                    },
                                    onSaved: (value) {
                                      _authData['phoneNumber'] = value;
                                    },
                                  ),
                                  Positioned(
                                      right: 3,
                                      top: 7,
                                      bottom: 12,
                                      child: Icon(
                                        Icons.phone_android,
                                        color: AppTheme.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _isLoading
                  ? SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index.isEven
                                ? AppTheme.spinerColor
                                : AppTheme.spinerColor,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 50,
                      width: deviceSize.width * 0.6,
                      child: RaisedButton(
                        child: Text(
                          _authMode == AuthMode.Login
                              ? 'ورود'
                              : 'دریافت کد تایید',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 13.0,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _submit();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Colors.blue,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
              AnimatedContainer(
                duration: _controller.duration,
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FlatButton(
                      child: Text(
                        'اصلاح شماره تلفن',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 9.0,
                        ),
                      ),
                      onPressed: _switchPhoneCorrectMode,
                      padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
