import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/functions/functions_page.dart';
import 'Package:recipes/login/login_page.dart';
import 'package:email_validator/email_validator.dart';

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final Map<String, Color> colors = getCommonColors();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isPasswordObscured1 = true;


  Future<void> _resetpassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text;
      var newpassword = _newpasswordController.text;
      var confirmpassword = _confirmpasswordController.text;

      if (newpassword == confirmpassword) {
        Map<String, dynamic> payload = {'email':email,'newPassword': newpassword, 'confirmPassword': confirmpassword};

        await putApi('updatepassword', payload).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords reset successfully'),
              duration: Duration(seconds: 5),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reset password'),
              duration: Duration(seconds: 5),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            duration: Duration(seconds: 5),
          ),
        );
      }
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
                          'Reset Password',
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
                            controller: _newpasswordController,
                            obscureText: _isPasswordObscured,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your New password';
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
                              hintText: 'New Password',
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
                            controller: _confirmpasswordController,
                            obscureText: _isPasswordObscured1,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your confirm password';
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
                                      _isPasswordObscured1 = !_isPasswordObscured1;
                                    });
                                  },
                                  icon: Icon(
                                    _isPasswordObscured1 ? Icons.visibility : Icons.visibility_off,
                                    color: colors['color2'],
                                  ),
                                ),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: ElevatedButton(
                            onPressed: () => _resetpassword(context),
                            style: ElevatedButton.styleFrom(
                              elevation: 8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                              backgroundColor: colors['color3'],
                            ),
                            child: Text('Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
