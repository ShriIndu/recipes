import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final Map<String, Color> colors = getCommonColors();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured=true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      var firstname = _firstnameController.text;
      var lastname = _lastnameController.text;
      var email = _emailController.text;
      var password = _passwordController.text;

      final ApiProvider _apiProvider = ApiProvider();

      String requestBody = jsonEncode({
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
        'password': password,
      });
      await _apiProvider.makeHttpRequest('/csapi/signup', requestBody, context);
    }
  }



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
                  //image: DecorationImage(image: AssetImage('assets/background_image.jpg'),fit: BoxFit.cover,
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
                    children: <Widget>[
                      Text(
                        'Sign Up',
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
                          controller: _firstnameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your First Name';
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
                              Icons.person,
                              color: colors['color2'],
                            ),
                            hintText: 'First Name',
                            hintStyle: TextStyle(
                              color: Colors.black38,
                            ),
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
                          controller: _lastnameController,
                          keyboardType: TextInputType.name,
                           validator: (value) {
                             if (value?.isEmpty ?? true) {
                             return 'Please enter your last Name';
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
                                Icons.person,
                                color: colors['color2'],
                              ),
                              hintText: 'Last Name',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: ElevatedButton(
                          onPressed: () => _signUp(context),
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            backgroundColor: colors['color3'],
                          ),
                          child: Text('Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: ()
                      {
                        Navigator.pop(context);
                      },
                      child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Back to',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:22,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                                TextSpan(
                                  text: ' Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                          )
                      )
                  )
                    ],
                  ),
                ),
              ), //buildBack(),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
