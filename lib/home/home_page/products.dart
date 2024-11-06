import 'package:flutter/material.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/functions/functions_page.dart';
import 'dart:convert';

final Map<String, Color> colors = getCommonColors();
final ApiProvider apiProvider = ApiProvider();
bool isAddedToCart = false;

class RecipeDetails extends StatefulWidget {
  final ProductDetails details;
  final int recipeId;
  RecipeDetails({required this.details,required this.recipeId});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {

  int currentIndex = 0;
  List<RecipeButtonList>? recipedetails;
  List<Widget> currentData = [];
  Recipe1? selectedRecipe;
  bool isLoading = false;
  bool isAddedToCart = false;

  void updateCartState(bool value) {
    setState(() {
      isAddedToCart = value;
    });
  }

  Widget build(BuildContext context) {
    Recipe1 recipe = widget.details.data?.recipe ?? Recipe1();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: SizedBox(
                      width: 400,
                      height: 400,
                      child: buildLeadingImage(recipe?.mainImage),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      }, child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors['color7'],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.arrow_back_ios_new,
                            color:colors['color6'],),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe?.name ?? "No Name",
                            style: TextStyle(fontSize: 24),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    GestureDetector(
                      onTap: () {
                        if (!isAddedToCart) {
                          addToShoppingCart(context, recipe.id,
                              updateCartState);
                        } else {
                          removeFromShoppingCart(context, recipe.id,
                              updateCartState);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isAddedToCart ? Colors.red : colors['color3'],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isAddedToCart ? Icons.remove : Icons.add,
                          color: colors['color7'],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: FutureBuilder(
                  future: getRecipeButtonList(),
                  builder: (context, AsyncSnapshot<List<RecipeButtonList>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      recipedetails = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Recipe1 currentRecipe = recipe;
                          return GestureDetector(
                            onTap: () {
                              handleButtonClick(index, currentRecipe);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 20.0,
                                  right: 5.0,
                                  left: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors['color7'],
                                ),
                                width: 150.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        snapshot.data![index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: currentData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: data,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleButtonClick(int index, Recipe1 recipe) {
    setState(() {
      currentIndex = index;
      if (index == 0) {
        currentData = [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              buildRow('⭐ Star Rating', '${recipe.reviewStar ?? 0}'),
              buildRow('🍽️ Serving counts', '${recipe.servingCount ?? 0}'),
              buildRow('🔥 Calories per serving', '${recipe.calories ?? 0}'),
              buildRow('⌛ Total Cookingtime', '${recipe.cookTime ?? 0.0}'),
            ],
          ),
        ];
      } else if (index == 1) {
        List<Widget> productInfoWidgets = widget.details.data?.recipe?.product
            ?.map((product) {
          String name = product.name ?? "Unnamed Product";
          String quantity = product.recipeIngredient?.quantity ?? "";
          String unit = product.recipeIngredient?.unit ?? "";
          TextSpan nameText = TextSpan(
            text: ' $name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          );
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: colors['color3'],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: colors['color6'],
                      ),
                      children: [
                        TextSpan(
                          text: ' $quantity $unit',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        nameText,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        })?.toList() ?? [];
        currentData = [
          SizedBox(height: 5),
          if (productInfoWidgets.isNotEmpty)
            ...productInfoWidgets
          else
            Text("No Products"),
        ];
      } else if (index == 3) {
        List<Widget> nutritionInfoWidgets = widget.details.data?.recipe
            ?.nutritions
            ?.map((nutritions) {
          String name = nutritions.name ?? "Unnamed Product";
          String value = nutritions.recipeNutrition?.value ?? "0";
          TextSpan nameText = TextSpan(
            text: ' $name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          );
          String formattedProduct = '$value${nameText.toPlainText()}';

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: colors['color6'],
                      ),
                      children: [
                        TextSpan(
                          text: ' $value. ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        nameText,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        })?.toList() ?? [];
        currentData = nutritionInfoWidgets.isNotEmpty ? nutritionInfoWidgets : [
          Text("No nutritions")
        ];
      }
    });
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<RecipeButtonList>> getRecipeButtonList() async {
    try {
      final data = await fetchData('recipedetails');

      List<RecipeButtonList> tempList = [];
      if (data['data'] != null && data['data']['recipedetails'] != null) {
        for (Map<String, dynamic> i in data['data']['recipedetails']) {
          RecipeButtonList recipebuttonlist = RecipeButtonList(name: i['name']);
          tempList.add(recipebuttonlist);
        }
      }
      return tempList;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}

Future<void> addToShoppingCart(BuildContext context, int? recipeId, void Function(bool) updateState) async {
  try {
    final Map<String, dynamic> requestBody = {"recipe_id": recipeId};
    final jsonResponse = await apiProvider.makeHttpRequest('/csapi/addallproducts', jsonEncode(requestBody), context);

    if (jsonResponse.containsKey("status") && jsonResponse["status"] == 1) {
      updateState(true);
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> removeFromShoppingCart(BuildContext context, int? recipeId, void Function(bool) updateState) async {
  await performCartOperation(context,'removeproduct/$recipeId', {
    "recipe_id": recipeId,
  });
  updateState(false);
}

