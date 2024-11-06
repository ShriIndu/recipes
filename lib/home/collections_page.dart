import 'package:flutter/material.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/home/home_page/home_page.dart';

Future<Favorite?> fetchFavoriteData() async {
  try {
    final Map<String, dynamic> responseData = await fetchData('saveRecipe');
    return Favorite.fromJson(responseData);
  } catch (e) {
    throw Exception('Failed to load favorite data: $e');
  }
}

class FavoriteRecipesPage extends StatefulWidget {
  @override
  _FavoriteRecipesPageState createState() => _FavoriteRecipesPageState();
}

class _FavoriteRecipesPageState extends State<FavoriteRecipesPage> {
  late Future<Favorite?> favoriteData;

  @override
  void initState() {
    super.initState();
    favoriteData = fetchFavoriteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: Center(
        child: FutureBuilder<Favorite?>(
          future: favoriteData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.data?.savedRecipes?.length ?? 0,
                itemBuilder: (context, index) {
                  var recipe = snapshot.data!.data!.savedRecipes![index]
                      .recipes;
                  final int? recipeId = recipe!.id;
                  return InkWell(
                    onTap: () async {
                      var recipeDetails = await fetchRecipeDetails(recipe.id!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetails(
                                details: recipeDetails,
                                recipeId: recipe.id!,
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          recipe.mainImage != null && recipe.mainImage!.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              recipe.mainImage!,
                              height: 250.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/recipes.png',
                              height: 250.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      recipe.name ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.favorite, color: Colors.red),
                                    ),
                                    onPressed: () {
                                      deleteFromCart(context, recipeId).then((_) {
                                        setState(() {
                                          favoriteData = fetchFavoriteData();
                                        });
                                      });
                                    },
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> deleteFromCart(BuildContext context, int? recipeId) async {
    await performCartOperation(context, 'saveRecipe/$recipeId', {
      "id": recipeId,
    });
  }
}
