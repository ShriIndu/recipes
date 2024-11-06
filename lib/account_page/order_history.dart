import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/home_page.dart';
import 'package:recipes/functions/functions_page.dart';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<int?> savedRecipeIds = [];
  Future<Orderdhistory>? _orderHistory;

  @override
  void initState() {
    super.initState();
    _orderHistory = fetchOrderHistory();
  }

  Future<Orderdhistory> fetchOrderHistory() async {
    final data = await fetchData('orderhistory');
    return Orderdhistory.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Center(
                        child: FutureBuilder<Orderdhistory>(
                          future: _orderHistory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.data == null ||
                                snapshot.data!.data!.orders == null ||
                                snapshot.data!.data!.orders!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(snapshot.data!.data!.orders!.length,
                                      (index) {
                                    final order = snapshot.data!.data!.orders![index];
                                    final recipe = order.recipes;
                                    final isRecipeSaved = savedRecipeIds.contains(recipe!.id);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(details: recipeDetails, recipeId: recipe.id!,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecipeDetails(details: recipeDetails, recipeId: recipe.id!,),
                                                      ),
                                                    );
                                                  },
                                                  child: recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                                      ? Image.network(
                                                    recipe.mainImage!,
                                                    height: 100.0,
                                                    width: 150.0,
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Image.asset('assets/recipes.png',
                                                    height: 100.0,
                                                    width: 150.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8.0),
                                            Container(
                                              width: 200,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    recipe.name ?? 'No Name',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text('Order Status: ${order.orderStatus ?? 'Unknown'}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

