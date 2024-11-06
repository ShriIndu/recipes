import 'package:flutter/material.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/home/home_page/home_page.dart';
import 'dart:async';

class CuisinesPage extends StatefulWidget {
  final int id;
  final String name;
  CuisinesPage({required this.id, required this.name});
  @override
  _CuisinesPageState createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage> {
  late Future<cuisineslistdetails> futureCuisinesListDetails;

  @override
  void initState() {
    super.initState();
    futureCuisinesListDetails = fetchCuisinesListDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: FutureBuilder<cuisineslistdetails >(
          future: futureCuisinesListDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data?.data?.recipes == null) {
              return Text('No data available');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.data!.recipes!.length,
                itemBuilder: (context, index) {
                  var recipe = snapshot.data!.data!.recipes![index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
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
                    title: Stack(
                      children: [
                        recipe.mainImage != null
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
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
Future<cuisineslistdetails > fetchCuisinesListDetails(int id) async {
  final responseJson = await fetchData('reciperelatedcuisines/$id');
  return cuisineslistdetails .fromJson(responseJson);
}
