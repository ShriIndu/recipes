import 'dart:async';
import 'dart:convert';
import 'package:recipes/functions/functions_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recipes/account_page/address.dart';
import 'package:recipes/functions/posts.dart';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();

class googleMap extends StatefulWidget {
  final String initialAddress;
  final String initialPincode;
  final Addresses? addressInfo;

  const googleMap({Key? key, required this.initialAddress, required this.initialPincode, this.addressInfo}) : super(key: key);

  @override
  State<googleMap> createState() => _googleMapState();
}
class _googleMapState extends State<googleMap> {
  late TextEditingController houseController;
  late TextEditingController apartmentController;

  final Map<String, Color> colors = getCommonColors();
  String address = '';

  String pincode = '';
  LatLng mylatlong = LatLng(12.9716, 77.5946);

  final Completer<GoogleMapController> _controller = Completer();
  late List<Marker> _markers;
  late CameraPosition _kGooglePlex;

  @override
  void initState() {
    super.initState();
    _markers = [
      Marker(
        infoWindow: InfoWindow(title: address),
        position: mylatlong,
        draggable: true,
        markerId: MarkerId('1'),
        onDragEnd: (value) {
          print(value);
          setMarker(value);
        },
      ),
    ];
    _kGooglePlex = CameraPosition(
      target: mylatlong,
      zoom: 13,
    );
    loadData();
    houseController = TextEditingController();
    apartmentController = TextEditingController();
  }

  @override
  void dispose() {
    houseController.dispose();
    apartmentController.dispose();
    super.dispose();
  }

  setMarker(LatLng value) async {
    mylatlong = value;

    List<Placemark> result = await placemarkFromCoordinates(
        value.latitude, value.longitude);

    if (result.isNotEmpty) {
      address = '${result[0].name}, ${result[0].subLocality},${result[0]
          .locality},${result[0].administrativeArea} ${result[0].country}.';
      pincode = result[0].postalCode ?? '';
      print('Pincode is: $pincode');
      print('MarkedAddress is: $address');
      print(
          'LatLng:${value.latitude.toString()},${value.longitude.toString()}');
      setState(() {});
    }
    _markers.clear();
    _markers.add(
      Marker(
        infoWindow: InfoWindow(title: address),
        position: value,
        draggable: true,
        markerId: MarkerId('1'),
        onDragEnd: (value) {
          print(value);
          setMarker(value);
        },
      ),
    );
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error,
        stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  loadData() {
    _getUserCurrentLocation().then((value) async {
      _markers.add(
          Marker(
              markerId: const MarkerId('SomeId'),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: InfoWindow(
                  title: address
              )
          )
      );
      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers.toSet(),
              onTap: (value) {
                setMarker(value);
              },
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          _getUserCurrentLocation().then((value) async {
                            _markers.add(
                                Marker(
                                    markerId: const MarkerId('SomeId'),
                                    position: LatLng(
                                        value.latitude, value.longitude),
                                    infoWindow: InfoWindow(
                                        title: address
                                    )
                                )
                            );
                            final GoogleMapController controller = await _controller
                                .future;
                            CameraPosition _kGooglePlex = CameraPosition(
                              target: LatLng(value.latitude, value.longitude),
                              zoom: 14,
                            );
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(_kGooglePlex));
                            List<
                                Placemark> placemarks = await placemarkFromCoordinates(
                                value.latitude, value.longitude);
                            final add = placemarks.first;
                            address = add.name.toString() + " " + add.subLocality.toString() + " " + add.locality.toString() + " " + add.administrativeArea.toString() + " " + add.country.toString();
                            setState(() {});
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                              color: colors['color3'],
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(child: Text('Current Location',
                            style: TextStyle(color: Colors.white,fontSize: 15),)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      child: Column(
                                        children: [
                                          Padding(padding:EdgeInsets.all(15),
                                            child: Row(
                                              children:[
                                                Icon(
                                                  Icons.my_location_outlined,
                                                  color: colors['color3'],
                                                  size: 30,
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    '$address',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    Padding(padding:EdgeInsets.all(15),
                                        child: TextField(
                                          controller: houseController,
                                            decoration: InputDecoration(
                                              labelText: 'House/Flat/Block No.',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF9C27B0)),
                                              ),
                                            ),
                                          ),
                                    ),
                                    Padding(padding:EdgeInsets.all(15),
                                         child: TextField(
                                           controller: apartmentController,
                                            decoration: InputDecoration(
                                              labelText: 'Apartment/Road/Area',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xFF9C27B0)),
                                              ),
                                            ),
                                          ),
                                    ),
                                          SizedBox(height: 40),
                                          Container(
                                            width: 300,
                                            height: 40,
                                            child:  ElevatedButton(
                                              onPressed: () {
                                                String newAddress = '${houseController.text} ${apartmentController.text}';
                                                saveAddress(context, newAddress);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => Address()),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colors['color3'],
                                              ),
                                              child: Text('Save and Proceed',
                                                style: TextStyle(color: colors['color7']),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.red),
                                                color: Colors.red[100],
                                              ),
                                              width: 400,
                                              height: 60,
                                              child: Text(
                                                'Your Detailed address will help 3our Delivery Partner to reach your doorstep easily and early...',
                                                style: TextStyle(color:Colors.brown),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            color: colors['color3'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text('Confirm Location',
                              style: TextStyle(color: Colors.white,fontSize: 15))),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(address),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateaddresslist(String AddressId,String newAddress) async {
    String completeAddress = address.isNotEmpty ? '$newAddress,$address' : newAddress;
    Map<String, dynamic> payload = {
      'address': completeAddress,
      'pincode': pincode,
      'latitude': mylatlong.latitude.toString(),
      'longitude': mylatlong.longitude.toString(),
    };
    await putApi('updateAddress/$AddressId', payload);
  }

  Future<void> saveAddress(BuildContext context, String newAddress) async  {
    final ApiProvider _apiProvider = ApiProvider();
    String completeAddress = address.isNotEmpty ? '$newAddress,$address' : newAddress;
    String requestBody = jsonEncode({
      'address': completeAddress,
      'pincode': pincode,
      'latitude': mylatlong.latitude.toString(),
      'longitude': mylatlong.longitude.toString(),
    });
    if (widget.initialAddress.isNotEmpty && widget.initialPincode.isNotEmpty) {
      await updateaddresslist(widget.addressInfo!.id.toString(),newAddress);
    } else {
      await _apiProvider.makeHttpRequest('/csapi/address', requestBody, context);
    }
  }
}


