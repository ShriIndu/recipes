import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/functions/functions_page.dart';
import 'Package:recipes/login/login_signup_page.dart';
import 'Package:recipes/login/forgot_password.dart';
import 'package:email_validator/email_validator.dart';
import 'Package:recipes/home/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, Color> colors = getCommonColors();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;


  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text;
      var password = _passwordController.text;

      final ApiProvider _apiProvider = ApiProvider();

      String requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var loginResponse =
      await _apiProvider.makeHttpRequest('/csapi/login', requestBody, context);

      if (loginResponse['status'] == 1) {
        String authToken12 = loginResponse['data']['authToken'];
        await saveAuthenticationToken(authToken12);
        print('Authentication12 : $authToken12');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation(selectedIndex: 0)),
        );
      }
    }
  }

  Future<void> saveAuthenticationToken(String authToken12) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken56', authToken12);
  }


  Widget buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Forgotpassword()),
            );
          },
        child:Text(
          'Forgot Password',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget buildLogin() {
    return Container(
      //home: Scaffold(
        //body: Center(
          child: ElevatedButton(
            onPressed: () => _login(context),
            style: ElevatedButton.styleFrom(
              elevation: 8,
              padding: EdgeInsets.symmetric(horizontal: 90, vertical:15),
              backgroundColor: colors['color3'],
            ),
            child: Text('LOGIN',
            style: TextStyle(
              color: Colors.white,
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }

  Widget buildSignUp(){
    return GestureDetector(
      onTap: ()
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
        },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize:20,
                fontWeight: FontWeight.w500
              )
            ),
            TextSpan(
              text: 'Sign up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
            ),
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    //image: DecorationImage(
                      //image: AssetImage('assets/background_image.jpg'),
                     // fit: BoxFit.cover,
                   // ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors:
                    [
                      colors['color2']!,
                      colors['color2']!
                   ]
                  )
                ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 120
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2)
                          )
                        ]
                    ),
                    height: 60,
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                      style: TextStyle(
                          color: Colors.black87
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(
                            Icons.email,
                            color: colors['color2'],
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2)
                          )
                        ]
                    ),
                    height: 60,
                    width: 350,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },

                      style: TextStyle(
                          color: Colors.black87
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: colors['color2'],
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                            icon: Icon(
                              _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                              color: colors['color2'],
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )
                      ),
                    ),
                  ),
                  buildForgotPassword(),
                  SizedBox(height: 50),
                  buildLogin(),
                  SizedBox(height: 10),
                  buildSignUp(),
                ],
                ),
              ),
              ),
            ],
          ),
        ),
       ),
      ),
    );
  }
}