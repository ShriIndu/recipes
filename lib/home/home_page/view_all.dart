import 'package:flutter/material.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/home_page.dart';
import 'package:recipes/functions/functions_page.dart';

final Map<String, Color> colors = getCommonColors();

class AllRecommendedRecipesPage extends StatefulWidget {
  @override
  _AllRecommendedRecipesPageState createState() => _AllRecommendedRecipesPageState();
}
class _AllRecommendedRecipesPageState extends State<AllRecommendedRecipesPage> {
  List<ARData> recipes = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchRecipes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes = await getAllRecipes(page: currentPage);
      setState(() {
        recipes.addAll(newRecipes);
        currentPage++;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Text(
          'Recommended for you',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: recipes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(10.0),
        itemCount: recipes.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
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
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      recipe.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}


class AllPremiumRecipesPage extends StatefulWidget {
  @override
  _AllPremiumRecipesPageState createState() => _AllPremiumRecipesPageState();
}
class _AllPremiumRecipesPageState extends State<AllPremiumRecipesPage> {
  List<PremiumData> recipes = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchRecipes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes = await getAllPremiumRecipes(page: currentPage);
      setState(() {
        recipes.addAll(newRecipes);
        currentPage++;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Text(
          'Premium Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: recipes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(10.0),
        itemCount: recipes.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
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
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      recipe.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}


class AllguidedRecipesPage extends StatefulWidget {
  @override
  _AllguidedRecipesPageState createState() => _AllguidedRecipesPageState();
}
class _AllguidedRecipesPageState extends State<AllguidedRecipesPage> {
  List<GuidedData> recipes = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchRecipes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes = await getAllGuidedRecipes(page: currentPage);
      setState(() {
        recipes.addAll(newRecipes);
        currentPage++;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Text(
          'Guided Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: recipes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(10.0),
        itemCount: recipes.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
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
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      recipe.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}


class AllDessertRecipesPage extends StatefulWidget {
  @override
  _AllDessertRecipesPageState createState() => _AllDessertRecipesPageState();
}
class _AllDessertRecipesPageState extends State<AllDessertRecipesPage> {
  List<DessertsData> recipes = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchRecipes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes = await getAllDessertsRecipes(page: currentPage);
      setState(() {
        recipes.addAll(newRecipes);
        currentPage++;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Text(
          ' Desserts Special',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: recipes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(10.0),
        itemCount: recipes.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
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
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      recipe.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}

class AllHealthyRecipesPage extends StatefulWidget {
  @override
  _AllHealthyRecipesPageState createState() => _AllHealthyRecipesPageState();
}
class _AllHealthyRecipesPageState extends State<AllHealthyRecipesPage> {
  List<HealthyData> recipes = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchRecipes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes = await getAllHealthyRecipes(page: currentPage);
      setState(() {
        recipes.addAll(newRecipes);
        currentPage++;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors['color1'],
        title: Text(
          ' Desserts Special',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: recipes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(10.0),
        itemCount: recipes.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
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
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      recipe.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}