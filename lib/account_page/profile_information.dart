import 'package:flutter/material.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/account_page/account.dart';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();

class MyProfile extends StatefulWidget{
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchcustomerData();
  }

  Future<void> fetchcustomerData() async {
    try {
      final userData = await fetchData('customers/details');
      final customerDetails = Customerdetails.fromJson(userData);
      setState(() {
        _firstNameController.text = customerDetails.data?.firstName ?? '';
        _lastNameController.text = customerDetails.data?.lastName ?? '';
        _emailController.text = customerDetails.data?.email ?? '';
        _phoneController.text = customerDetails.data?.phoneNo ?? '';
        _dateController.text = customerDetails.data?.dOB ?? '';
        _genderController.text = customerDetails.data?.gender ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile Information',
          style: TextStyle(color: colors['color7']),
        ),
        backgroundColor: colors['color2'],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C27B0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C27B0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C27B0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: _selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : 'Select date',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C27B0)),
                      ),
                    ),
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Please select your Date of Birth';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone No',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C27B0)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),

                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9C27B0)),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 10,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            onChanged: (String? newValue) {
                              setState(() {
                                _genderController.text = newValue ?? '';
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                updateCustomerApi().then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Account()),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors['color3'],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  Future<void> updateCustomerApi() async {
    Map<String, dynamic> payload = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone_no': _phoneController.text,
      'email': _emailController.text,
      'gender':_genderController.text,
      'DOB':_dateController.text,
    };
    await putApi('customers/updateprofile', payload);
  }
}