import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/login/login_page.dart';
import 'package:recipes/account_page/address.dart';
import 'package:recipes/account_page/order_history.dart';
import 'package:recipes/account_page/profile_information.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/functions/posts.dart';
import 'dart:io';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();
File? pickedImage;

String? globalProfileImagePath;

void updateGlobalProfileImagePath(String imagePath) {
  globalProfileImagePath = imagePath;
}


class Account extends StatefulWidget{
  @override
  _AccountState createState() => _AccountState();
}
class _AccountState extends State<Account>{
  bool _isLoading = false;
  String? firstName;
  String? lastName;
  String? email;
  String?  profileImagePath;

  @override
  void initState() {
    super.initState();
    fetchcustomerData();
  }
  Future<void> updateCustomerProfileImage(String imagePath) async {
    Map<String, dynamic> payload = {
      "profile_image_path": imagePath,
    };
    await putApi('customers/updateprofile', payload);
    setState(() {
      profileImagePath = imagePath;
    });
    updateGlobalProfileImagePath(imagePath);
  }

  void imagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
              color: Colors.white,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Edit Picture",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("CAMERA"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("GALLERY"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        deleteprofileimage(context);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("DELETE"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource imageType) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageType);
      if (pickedFile == null) return;
      final tempImage = File(pickedFile.path);
      setState(() {
        pickedImage = tempImage;
      });
      print('Image URL: ${pickedFile.path}');
      await updateCustomerProfileImage(pickedFile.path);
      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(color: colors['color7']),
        ),
        backgroundColor: colors['color2'],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: ClipOval(
                        child: profileImagePath != null
                            ? Image.file(
                          File(profileImagePath!),
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/recipes.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 1,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => imagePickerOption(context),
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text('$firstName $lastName',
                      style: TextStyle(
                          color: colors['color3'],
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Orders',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade100),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfile()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'My Profile',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Name, Email, Phone no & DOB',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade100),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Address()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'My Address',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Edit, Delete & Add New Address',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade100),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Bank Details',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Edit & Delete',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade100),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Feedback & Support',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Feedback & Ratings',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade100),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Policies',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Terms & Conditions, Privacy Policy & Cancellation Policy',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () async {
                  await clearAuthenticationToken();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['color3'],
                ),
                child: Text('Logout',
                  style: TextStyle(color: colors['color7']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteprofileimage(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await performCartOperation(context, 'customers/profile-image', {});
    setState(() {
      profileImagePath = null;
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  Future<void> clearAuthenticationToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken56');
  }

  Future<void> fetchcustomerData() async {
    try {
      final userData = await fetchData('customers/details');
      final customerDetails = Customerdetails.fromJson(userData);
      setState(() {
        firstName = customerDetails.data?.firstName;
        lastName = customerDetails.data?.lastName;
        email = customerDetails.data?.email;
        profileImagePath = customerDetails.data?.profileImagePath;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}



