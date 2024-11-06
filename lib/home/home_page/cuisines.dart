import 'package:flutter/material.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/home_page/cuisines_clickrecipes.dart';
import 'dart:async';

ApiProvider apiProvider = ApiProvider();

class CuisinesList extends StatefulWidget {
  @override
  _CuisinesListState createState() => _CuisinesListState();
}

class _CuisinesListState extends State<CuisinesList> {
  Future<List<Cuisine>> getCuisines() async {
    try {
      final data = await fetchData('cuisines');
      List<Cuisine> tempList = [];
      if (data['data'] != null && data['data']['cuisines'] != null) {
        for (Map<String, dynamic> i in data['data']['cuisines']) {
          Cuisine cuisine = Cuisine(id:i['id'],name: i['name'], image: i['image'] ?? '');
          tempList.add(cuisine);
        }
      } else {
        print('Error: Invalid data format');
      }
      return tempList;
    } catch (e) {
      throw Exception('Failed to load cuisines: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuisines'),
      ),
      body: FutureBuilder(
        future: getCuisines(),
        builder: (context, AsyncSnapshot<List<Cuisine>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CuisinesPage(id: snapshot.data![index].id,name: snapshot.data![index].name,),
                      ),
                    );
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
            );
          }
        },
      ),
    );
  }
}

