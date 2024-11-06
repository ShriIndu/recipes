import 'package:flutter/material.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class CartPage extends StatefulWidget {
  final String? selectedProductId;

  CartPage({this.selectedProductId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItems>? cartItems;
  String? selectedProductName;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken56');

      final cartResponse = await http.get(
        Uri.parse('${apiProvider.baseUrl}/csapi/cartlist'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (cartResponse.statusCode == 200) {
        final jsonData = json.decode(cartResponse.body);
        final cartList = cartListDisplay.fromJson(jsonData);
        setState(() {
          cartItems = cartList.data?.cartItems;
          selectedProductName = cartItems
              ?.firstWhere(
                (item) => item.productId == widget.selectedProductId,
            orElse: () => CartItems(),
          )
              .product
              ?.name;
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems != null
          ? ListView.builder(
        itemCount: cartItems!.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems![index];
          return ListTile(
            title: Text(cartItem.product?.name ?? 'Unknown'),
            subtitle: Text('Quantity: ${cartItem.quantity}'),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Selected Product: ${selectedProductName ?? 'Unknown'}',
          ),
        ),
      ),
    );
  }
}
