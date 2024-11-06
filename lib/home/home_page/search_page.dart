import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:recipes/functions/functions_page.dart';
import 'dart:async';


ApiProvider apiProvider = ApiProvider();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchEnterController = TextEditingController();
  List<Data> data = [];
  List<Data> originalDataList = [];
  Data? selectedItem;

  Future<void> fetchData1(String query) async {
    try {
      final jsonData = await fetchData('search/recipes?query=$query');
      if (jsonData['data'] != null) {
        List<dynamic> dataList = jsonData['data'];
        setState(() {
          originalDataList = dataList.map((item) => Data.fromJson(item)).toList();
          data = originalDataList.toList();
        });
      } else {
        throw Exception('Data not found in response');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData1('');
  }
  void clearData() {
    setState(() {
      data.clear();
    });
  }

  void navigateToSearchResultsPage(String query, List<Data> data1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query, data1: data1,clearData: clearData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Type the ingredients or dishes...',
                            border: InputBorder.none,
                          ),
                          onChanged: (query) {
                            fetchData1(query);
                          },
                          onSubmitted: (value) {
                            _searchEnterController.text = value;
                            if (selectedItem != null) {
                              navigateToSearchResultsPage(value, [selectedItem!]);
                            } else {
                              navigateToSearchResultsPage(value, data);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Data searchData = data[index];
                      Recipe? recipe = searchData.recipes;
                      return ListTile(
                        onTap: () {
                          setState(() {
                            selectedItem = searchData;
                            _searchController.text = recipe?.name ?? '';
                          });
                        },
                        leading: CircleAvatar(
                          backgroundImage: recipe?.mainImage != null
                              ? NetworkImage(recipe!.mainImage!)
                              : AssetImage('assets/recipes.png') as ImageProvider<Object>?,
                          radius: 20,
                        ),
                        title: Text(recipe?.name ?? 'Unknown'),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultsPage extends StatelessWidget {
  final String query;
  final List<Data> data1;
  final VoidCallback clearData;

  SearchResultsPage({required this.query, required this.data1,required this.clearData});

  Future<void> _navigateToRecipeDetails(BuildContext context, Recipe? recipe) async {
    try {
      if (recipe == null || recipe.id == null) {
        print('Error: Invalid recipe selected');
        return;
      }

      final data = await fetchData('recipes/${recipe.id}');

      final newProductDetails = ProductDetails.fromJson(data);

      final newRecipeId = newProductDetails.data?.recipe?.id;
      final currentRecipeId = recipe.id ?? 0;

      if (newRecipeId != null && currentRecipeId == newRecipeId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(details: newProductDetails,recipeId: currentRecipeId),
          ),
        );
      } else {
        print('IDs do not match');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Related Items for $query'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data1.length,
            itemBuilder: (BuildContext context, int index) {
              Data searchData = data1[index];
              Recipe? recipe = searchData.recipes;
              Cuisines? cuisine = searchData.cuisines;
              return ListTile(
                title: Text(recipe?.name ?? "No name"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cuisine: ${cuisine?.name ?? "no name"}"),
                    Text("Review: ${recipe?.reviewStar ?? 0}"),
                    RatingBar.builder(
                      initialRating: recipe?.reviewStar ?? 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) =>
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
                leading: buildLeadingImage(recipe?.mainImage),
                onTap: () {
                  _navigateToRecipeDetails(context, recipe);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
