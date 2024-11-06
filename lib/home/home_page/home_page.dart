import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipes/home/home_page/search_page.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/courses.dart';
import 'package:recipes/home/home_page/view_all.dart';
import 'package:recipes/home/home_page/cuisines.dart';
import 'package:recipes/home/home_page/diet.dart';
import 'package:recipes/account_page/account.dart';
import 'package:recipes/functions/functions_page.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

ApiProvider apiProvider = ApiProvider();
final Map<String, Color> colors = getCommonColors();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool _isFavorited = false;
  List<int?> savedRecipeIds = [];

  Future<List<Categorie>> getCategories() async {
    try {
      final data = await fetchData('categories');
      final categoriesData = data['data']['categories'];
      List<Categorie> tempList = [];
      for (var categoryData in categoriesData) {
        Categorie categorie = Categorie(
          name: categoryData['name'],
          image: categoryData['image'] ?? '',
        );
        tempList.add(categorie);
      }
      return tempList;
    } catch (e) {
      throw Exception('Failed to load cuisines: $e');
    }
  }

  Future<void> saveRecipe(int recipeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken1 = prefs.getString('authToken56');
    try {
      final response = await http.post(
        Uri.parse('http://159.89.95.7:5001/csapi/saveRecipe'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken1',
        },
        body: json.encode({'recipe_id': recipeId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final savedRecipeId = responseData['data']['savedRecipe']['id'];
        setState(() {
          savedRecipeIds.add(savedRecipeId);
          _isFavorited = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Recipe saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to save recipe: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving recipe: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recipes',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              icon: globalProfileImagePath != null
                  ? CircleAvatar(
                backgroundImage: FileImage(File(globalProfileImagePath!)),
                radius: 20,
              )
                  : Icon(Icons.account_circle, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),).then((_) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
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
                      Center(
                        child: BoxDecoratedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 100,
                        child: FutureBuilder(
                          future: getCategories(),
                          builder: (context, AsyncSnapshot<List<Categorie>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data == null) {
                              return Center(child: Text('No data available'));
                            } else {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(snapshot.data!.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      handleListItemTap(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20.0,
                                          bottom: 10.0,
                                          right: 5.0,
                                          left: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: Colors.white,
                                        ),
                                        width: 150.0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(snapshot.data![index].name),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3.0),
                                              child: Container(
                                                margin: EdgeInsets.only(right: 0.0, bottom: 10.0, top: 10.0),
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Image.network(snapshot.data![index].image ?? '',
                                                    height: 70.0,
                                                    width: 70.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Recommended for you',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AllRecommendedRecipesPage()),
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Center(
                        child: FutureBuilder<List<ARData>>(
                          future: getAllRecipes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.length, (index) {
                                    final recipe = snapshot.data![index];
                                    final isRecipeSaved = savedRecipeIds.contains(recipe.id!);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(details: recipeDetails, recipeId: recipe.id!,),
                                          ),
                                        );
                                      },
                                      child:Container(
                                      margin: EdgeInsets.all(10.0),
                                      child: Stack(
                                        children: [
                                          recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                              ? Image.network(
                                            recipe.mainImage!,
                                            height: 320.0,
                                            width: 320.0,
                                          )
                                              : Image.asset(
                                            'assets/recipes.png',
                                            height: 320.0,
                                            width: 320.0,
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            right: 10,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    recipe.name ?? 'No Name',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      _isFavorited ? Icons.favorite : Icons.favorite,
                                                      color: isRecipeSaved ? Colors.red : Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (isRecipeSaved) {
                                                        savedRecipeIds.remove(recipe.id!);
                                                      } else {
                                                        savedRecipeIds.add(recipe.id!);
                                                        saveRecipe(recipe.id!);
                                                      }
                                                    });
                                                  },
                                                  splashRadius: 20.0,
                                                ),
                                            ],
                                              ),
                                          ),
                                        ],
                                      ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Guided Recipes',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AllguidedRecipesPage()),
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: FutureBuilder<List<GuidedData>>(
                          future: getAllGuidedRecipes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.length, (index) {
                                    final recipe = snapshot.data![index];
                                    final isRecipeSaved = savedRecipeIds.contains(recipe.id!);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(
                                              details: recipeDetails,
                                              recipeId: recipe.id!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                                    ? Image.network(
                                                  recipe.mainImage!,
                                                  height: 120.0,
                                                  width: 160.0,
                                                  fit: BoxFit.cover,
                                                )
                                                    : Image.asset(
                                                  'assets/recipes.png',
                                                  height: 120.0,
                                                  width: 160.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 100,
                                                  right: 0,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      IconButton(
                                                        icon: Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white,
                                                          ),
                                                          padding: EdgeInsets.all(2.0),
                                                          child: Icon(
                                                            Icons.favorite,
                                                            color: isRecipeSaved ? Colors.red : Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (isRecipeSaved) {
                                                              savedRecipeIds.remove(recipe.id!);
                                                            } else {
                                                              savedRecipeIds.add(recipe.id!);
                                                              saveRecipe(recipe.id!);
                                                            }
                                                          });
                                                        },
                                                        splashRadius: 20.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Container(
                                              width: 150.0,
                                              child: Text(
                                                recipe.name ?? 'No Name',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 10.0),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OUR SPECIAL',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Premium Recipes',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Image.asset(
                              'assets/Juice_Muesli_Coffee_Fruit.png',
                              height: 150.0,
                              width: 200.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'under 10 Recipes',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  AllPremiumRecipesPage()),
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Center(
                        child: FutureBuilder<List<PremiumData>>(
                          future: getAllPremiumRecipes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.length, (index) {
                                    final recipe = snapshot.data![index];
                                    final isRecipeSaved = savedRecipeIds.contains(recipe.id!);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(details: recipeDetails, recipeId: recipe.id!,),
                                          ),
                                        );
                                      },
                                      child:Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Stack(
                                          children: [
                                            recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                                ? Image.network(
                                              recipe.mainImage!,
                                              height: 250.0,
                                              width: 280.0,
                                            )
                                                : Image.asset(
                                              'assets/recipes.png',
                                              height: 250.0,
                                              width: 280.0,
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      recipe.name ?? 'No Name',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        _isFavorited ? Icons.favorite : Icons.favorite,
                                                        color: isRecipeSaved ? Colors.red : Colors.black,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (isRecipeSaved) {
                                                          savedRecipeIds.remove(recipe.id!);
                                                        } else {
                                                          savedRecipeIds.add(recipe.id!);
                                                          saveRecipe(recipe.id!);
                                                        }
                                                      });
                                                    },
                                                    splashRadius: 20.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ' Desserts Special',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AllDessertRecipesPage()),
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: FutureBuilder<List<DessertsData>>(
                          future: getAllDessertsRecipes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No data available');
                            } else {
                              return  Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                children: List.generate(
                                    snapshot.data!.length > 4 ? 4 : snapshot.data!.length,
                                        (index) {
                                    final recipe = snapshot.data![index];
                                    final isRecipeSaved = savedRecipeIds.contains(recipe.id!);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(
                                              details: recipeDetails,
                                              recipeId: recipe.id!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Stack(
                                              children: [
                                                recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                                    ? Image.network(
                                                  recipe.mainImage!,
                                                  height: 100.0,
                                                  width: 150.0,
                                                  fit: BoxFit.cover,
                                                )
                                                    : Image.asset(
                                                  'assets/recipes.png',
                                                  height: 100.0,
                                                  width: 150.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 100,
                                                  right: 00,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      IconButton(
                                                        icon: Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white,
                                                          ),
                                                          padding: EdgeInsets.all(2.0),
                                                          child: Icon(
                                                            Icons.favorite,
                                                            color: isRecipeSaved ? Colors.red : Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (isRecipeSaved) {
                                                              savedRecipeIds.remove(recipe.id!);
                                                            } else {
                                                              savedRecipeIds.add(recipe.id!);
                                                              saveRecipe(recipe.id!);
                                                            }
                                                          });
                                                        },
                                                        splashRadius: 20.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8.0),
                                            Container(
                                              width:200,
                                              child: Text(
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              );
                            }
                          },
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Healthy Recipes',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  AllPremiumRecipesPage()),
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Center(
                        child: FutureBuilder<List<HealthyData>>(
                          future: getAllHealthyRecipes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No data available');

                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.length, (index) {
                                    final recipe = snapshot.data![index];
                                    final isRecipeSaved = savedRecipeIds.contains(recipe.id!);
                                    return GestureDetector(
                                      onTap: () async {
                                        var recipeDetails = await fetchRecipeDetails(recipe.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RecipeDetails(details: recipeDetails, recipeId: recipe.id!,),
                                          ),
                                        );
                                      },
                                      child:Container(
                                        margin: EdgeInsets.all(10.0),
                                        child: Stack(
                                          children: [
                                            recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                                                ? Image.network(
                                              recipe.mainImage!,
                                              height: 300.0,
                                              width: 300.0,
                                            )
                                                : Image.asset(
                                              'assets/recipes.png',
                                              height: 300.0,
                                              width: 300.0,
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      recipe.name ?? 'No Name',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        _isFavorited ? Icons.favorite : Icons.favorite,
                                                        color: isRecipeSaved ? Colors.red : Colors.black,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (isRecipeSaved) {
                                                          savedRecipeIds.remove(recipe.id!);
                                                        } else {
                                                          savedRecipeIds.add(recipe.id!);
                                                          saveRecipe(recipe.id!);
                                                        }
                                                      });
                                                    },
                                                    splashRadius: 20.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Explore more',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      SizedBox(height:5),
                      Center(
                        child:FutureBuilder(
                        future: getCategories(),
                        builder: (context, AsyncSnapshot<List<Categorie>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            return SizedBox(
                                height: 500,
                            child:ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    handleListItemTap(index);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
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
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child:Text(snapshot.data![index].name),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 3.0),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 10.0, bottom: 10.0, top: 10.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    snapshot.data![index].image,
                                                    height: 60.0,
                                                    width: 60.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
  void handleListItemTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoursesList()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>CuisinesList()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>DietList()),
        );
        break;
     //
        // case 3:
      //  Navigator.push(
       //   context,MaterialPageRoute(builder: (context) =>  CuisinesPage())
      //  );
    }
  }
}

class BoxDecoratedButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BoxDecoratedButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 400,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: Colors.black38,
                size: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  'Search...',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<ARData>> getAllRecipes({int page = 1}) async {
  return homeDisplayRecipes<ARData>('recommendedrecipes', (data) => ARData(id: data['id'], name: data['name'], mainImage: data['main_image'] ?? '',),
    page: page,
  );
}

Future<List<PremiumData>> getAllPremiumRecipes({int page = 1}) async {
  return homeDisplayRecipes<PremiumData>('premiumrecipes', (data) => PremiumData(id: data['id'], name: data['name'], mainImage: data['main_image'] ?? '',),
    page: page,
  );
}

Future<List<GuidedData>> getAllGuidedRecipes({int page = 1}) async {
  return homeDisplayRecipes<GuidedData>('guidedrecipes', (data) => GuidedData(id: data['id'], name: data['name'], mainImage: data['main_image'] ?? '',),
    page: page,
  );
}


Future<List<DessertsData>> getAllDessertsRecipes({int page = 1}) async {
  return homeDisplayRecipes<DessertsData>('celebritychefrecipes', (data) => DessertsData(id: data['id'], name: data['name'], mainImage: data['main_image'] ?? '',),
    page: page,
  );
}

Future<List<HealthyData>> getAllHealthyRecipes({int page = 1}) async {
  return homeDisplayRecipes<HealthyData>('healthyrecipes', (data) => HealthyData(id: data['id'], name: data['name'], mainImage: data['main_image'] ?? '',),
    page: page,
  );
}

Future<ProductDetails> fetchRecipeDetails(int recipeId) async {
  final responseJson = await fetchData('recipes/$recipeId');
  return ProductDetails.fromJson(responseJson);
}
