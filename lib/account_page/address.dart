import 'package:flutter/material.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/account_page/map_page.dart';
import 'package:recipes/functions/posts.dart';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();

class Address extends StatefulWidget{
  @override
  _AddressState createState() => _AddressState();
}
class _AddressState extends State<Address> {
  List<Addresses>? addressList = [];
  bool NewaddressTextField = false;
  int? selectedAddressIndex;

  Future<void> AddressList() async {
    try {
      final data = await fetchData('addresslist');
      setState(() {
        final saveAddress = SaveAddress.fromJson(data);
        addressList = saveAddress.data?.addresses;
      });
    } catch (e) {
      throw Exception('Failed to load address list: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    AddressList();
  }

  void navigateToGoogleMap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => googleMap(
          initialAddress: addressList![index].address ?? '',
          initialPincode: addressList![index].pincode ?? '',
          addressInfo: addressList![index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Address',
          style: TextStyle(color: colors['color7']),
        ),
        backgroundColor: colors['color2'],
      ),
      body: Stack(
        children: [
      Column(
      children: [
        Expanded(
          child:SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                Divider(color: Colors.grey.shade100),
                SizedBox(height: 15),
                   SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: addressList!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: index,
                                      groupValue: selectedAddressIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAddressIndex = value;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${addressList![index].address ?? ''}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text('${addressList![index].pincode ?? ''}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    TextButton(
                                      onPressed: () {
                                        navigateToGoogleMap(index);
                                      },
                                      child: Text('Edit'),
                                    ),
                                    SizedBox(width: 5),
                                    TextButton(
                                      onPressed: () {
                                        deleteaddress(context,addressList![index].id!);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ),
          ],
      ),
          Positioned(
            top: 10,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => googleMap(initialAddress: '', initialPincode: ''),
                  ),
                );
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: colors['color3'],
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'ADD NEW ADDRESS',
                      style: TextStyle(
                        color: colors['color3'],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom:10,
              left:0,
              right: 0,
              child:Container(
                width:MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:ElevatedButton(
                    onPressed: (){

                    },
                    style:ElevatedButton.styleFrom(
                      backgroundColor: colors['color3'],
                    ),
                    child:Text(
                      'Save',
                      style:TextStyle(color:colors['color7']),
                    )
                ),
              )
          ),
        ],
      ),
    );
  }
  Future<void> deleteaddress(BuildContext context, int addressId) async {
    await performCartOperation(context, 'deleteaddress/$addressId', {});
    setState(() {
      addressList!.removeWhere((item) => item.id == addressId);
    });
  }
}
