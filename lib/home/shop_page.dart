import 'package:flutter/material.dart';
import 'package:recipes/functions/functions_page.dart';
import 'package:recipes/functions/posts.dart';
import 'package:recipes/home/bottom_navigation.dart';
import 'package:recipes/home/home_page/products.dart';
import 'package:recipes/account_page/address.dart';
import 'dart:async';
import 'dart:convert';

final Map<String, Color> colors = getCommonColors();
final ApiProvider apiProvider = ApiProvider();

class Shop extends StatefulWidget {
  final int selectedIndex;
  final String? selectedProductId;
  Shop({required this.selectedIndex, this.selectedProductId});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Rows> data = [];
  List<Rows> originalDataList = [];
  Rows? selectedItem;
  List<DataProduct>? productList;
  List<CartItems>? cartItems = [];
  String? selectedProduct;
  List<String> searchResults = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();
  List<CartItems> cartItemsList = [];
  List<List<bool>> ingredientCheckedList = [];
  late List<bool> isCheckedList;
  String selectedQuantity = '';
  String selectedCategory = '';
  String selectedCategory1 = '';
  String? selectedProductName;
  bool isLoading = false;
  int currentPage = 1;
  bool isLastPage = false;


  @override
  void initState() {
    super.initState();
    if (cartItems != null) {
      isCheckedList = List<bool>.filled(cartItems!.length, false);
    }
    _scrollController.addListener(_scrollListener);
    fetchCartList(setStateCallback);
    searchInCart('');
    fetchProducts();
    fetchCartItems();
  }
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchProducts(page: (productList!.length ~/ 10) + 1);
    }
  }
  void setStateCallback(List<CartItems> itemsList, List<List<bool>> ingredientCheckedList) {
    setState(() {
      cartItemsList = itemsList;
      this.ingredientCheckedList = ingredientCheckedList;
    });
  }

  void editpage(BuildContext context, CartItems cartItem,Function updateCartListCallback) {
    bool isQuantityClicked = false;
    bool isCategoryClicked = false;

    String selectedDropdownValue = 'unit';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            isQuantityClicked = true;
            return Container(
              color: Colors.white,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text('${cartItem.quantity ?? ''}  ${cartItem.product?.name ?? ''}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isQuantityClicked = true;
                            isCategoryClicked = false;
                          });
                        },
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                              fontSize: 16,
                              color: isQuantityClicked ? Colors.blue : Colors.black),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isQuantityClicked = false;
                            isCategoryClicked = true;
                          });
                        },
                        child: Text(
                          'Category',
                          style: TextStyle(
                              fontSize: 16,
                              color: isCategoryClicked ? Colors.blue : Colors
                                  .black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (isQuantityClicked)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    selectedQuantity = value;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: 'Quantity',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        selectedDropdownValue,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedDropdownValue = newValue!;
                                            selectedCategory1 = newValue;
                                          });
                                        },
                                        underline: Container(),
                                        items: <String>["unit", "can", " pkg.", "bag", "btl.", "box", "block", "cup", "qt.", "gal.", "jar", "oz.", "lb.", "pt.",
                                        ].map<DropdownMenuItem<String>>((
                                            String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                updateCartListCallback(cartItem.id.toString()).then((_) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),
                                    ),
                                        (route) => false,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 10),
                                backgroundColor: colors['color3'],
                              ),
                              child: Text('Save',style:TextStyle(color:colors['color7'])),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

//********************************************//
  Future<void> fetchProducts({int page = 1}) async {
    try {
      final responseData = await fetchData('products?page=$page');
      final productListCart = ProductListCart.fromJson(responseData);
      setState(() {
        if (page == 1) {
          productList = productListCart.data?.data;
        } else {
          productList?.addAll(productListCart.data?.data ?? []);
        }

      });
    } catch (e) {
      print('Failed to load products: $e');

    }
  }
//*********************************************//
  Future<void> fetchCartList(Function(List<CartItems>, List<List<bool>>) setState) async {
    try {
      final jsonData = await fetchData('cartlist');
      final cartList = cartListDisplay.fromJson(jsonData);
      List<CartItems> itemsList = cartList.data?.cartItems ?? [];
      List<List<bool>> ingredientCheckedList = List.generate(itemsList.length, (_) => []);

      for (int i = 0; i < itemsList.length; i++) {
        final List<RecipeIngredientcart>? ingredients = itemsList[i].recipeIngredients;
        if (ingredients != null) {
          ingredientCheckedList[i] = List.filled(ingredients.length, false);
        }
      }
      setState(itemsList, ingredientCheckedList);
    } catch (e) {
      throw Exception('Failed to load cart list: $e');
    }
  }
//***********************************************************************//
  Future<void> searchInCart(String query,{int page = 1}) async {
    try {
      if (query.isEmpty) {
        currentPage = 1;
        isLoading = false;
        isLastPage = false;
        setState(() {data = [];});
        return;
      }
      final encodedQuery = Uri.encodeComponent(query);
      final jsonData = await fetchData('search/product?query=$encodedQuery&page=$page');
      if (jsonData['data'] != null) {
        List<dynamic> dataList = jsonData['data']['rows'];
        setState(() {
          if (page == 1) {
            data = dataList.map((item) => Rows.fromJson(item)).toList();
          } else {
            data.addAll(dataList.map((item) => Rows.fromJson(item)).toList());
          }
        });
        if (dataList.isEmpty) {
          isLastPage = true;
        }
      } else {
        setState(() {data = [];});
      }
    } catch (e) {
      setState(() {data = [];});
      throw Exception('Failed to load data: $e');
    }
  }
//********************************************************************************//
  Future<void> addproductToCart(BuildContext context, DataAc? productData) async {
    if (productData == null || productData.productId == null) {
      print('Invalid product data');
      return;
    }
    final requestBody = jsonEncode({"product_id": productData.productId});
    try {
      final response = await apiProvider.makeHttpRequest("/csapi/addcartlist", requestBody, context,);
      if (response.containsKey("status") && response["status"] == 1) {
        final message = response["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? 'Product added to cart successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final errorMessage = response.containsKey("error") ? response["error"] : 'Failed to add product to cart';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Fetch updated cart list
      final cartResponse = await fetchData("cartlist");
      final cartList = cartListDisplay.fromJson(cartResponse);
      final selectedProduct = cartList.data?.cartItems?.firstWhere((item) => item.productId == productData.productId,
        orElse: () => CartItems(),
      );
      selectedProductName = selectedProduct?.product?.name;
      print("product: $selectedProductName");
    } catch (e) {
      print("Failed to add to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
          duration: Duration(seconds: 10),
        ),
      );
    }
  }
  //**********************************************************//
  Future<void> fetchCartItems() async {
    try {
      final data = await fetchData('cartlist');
      final cartList = cartListDisplay.fromJson(data);
      setState(() {
        cartItems = cartList.data?.cartItems;
        selectedProduct = cartItems?.firstWhere((item) => item.productId == widget.selectedProductId,
          orElse: () => CartItems(),
        )
            .product
            ?.name;
        isCheckedList = List<bool>.filled(cartItems!.length, false);
      });
    } catch (error) {
      print('Error: $error');
    }
  }
  //*******************************************************************//
  Future<void> deleteselectedproduct(BuildContext context) async {
    await performCartOperation(context, 'removeallproduct/NULL', {});
  }
  //*************************************************************//
  Future<void >deleteProduct(BuildContext context,String productId) async {
    await performCartOperation(context, 'removeoneproduct/NULL/$productId', {});

    setState(() {
      cartItems!.removeWhere((item) => item.productId == productId);
    });
  }
  //**************************************************************//
  Future<void> deleteFromCart(BuildContext context, int? recipeId, int? productId) async {
    await performCartOperation(context,'removeproduct/$recipeId/$productId', {
      "recipe_id": recipeId,
      "product_id": productId,
    });
  }
  //***************************************************************//
  Future<void>clearCart(BuildContext context) async {
    await performCartOperation(context, 'cart/clear', {});
  }
  //***************************************************//
  Future<void> updateCartlist(String productId) async {
    Map<String, dynamic> payload = {
      "quantity": selectedQuantity,
      "unit": selectedCategory1
    };
    await putApi('updatecart/$productId', payload);
  }
  //**************************************************//

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: colors['color7'],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                hintText: "Type the items you'd like to add",
                                border: InputBorder.none,
                              ),
                              onChanged: (query) {
                                setState(() {
                                  searchInCart(query);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_controller.text.isNotEmpty)
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLastPage) {
                              setState(() {
                                isLoading = true;
                              });
                              currentPage++;
                              searchInCart(_controller.text, page: currentPage).then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                            return true;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: data.length + (isLoading && !isLastPage ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == data.length && isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                Rows searchData = data[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: ListTile(
                                    onTap: () {
                                      DataAc productData = DataAc(productId: searchData.id);
                                      addproductToCart(context, productData).then((_) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BottomNavigation(
                                                    selectedIndex: widget.selectedIndex),
                                          ),
                                              (route) => false,
                                        );
                                      });
                                    },
                                    title: Text(
                                      searchData.name ?? 'Unknown',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    if (_controller.text.isEmpty)
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                              setState(() {
                                isLoading = true;
                              });
                              // Simulate loading delay
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                            return true;
                          },
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 10),
                            ),
                            controller: _scrollController,
                            itemCount: isLoading ? productList!.length + 1 : productList!.length,
                            itemBuilder: (context, index) {
                              if (index == productList!.length && isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                DataProduct product = productList![index];
                                return GestureDetector(
                                  onTap: () {
                                    DataAc productData = DataAc(productId: product.id);
                                    addproductToCart(context, productData).then((_) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BottomNavigation(
                                                  selectedIndex: widget.selectedIndex),
                                        ),
                                            (route) => false,
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colors['color7'],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          buildLeadingImage(product.image),
                                          SizedBox(width: 10),
                                          Text(product.name ?? ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colors['color6'],
                  ),
                ),
               // SizedBox(width: 250),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Clear All'),
                      value: 'Clear',
                    ),
                  ],
                  onSelected: (value){
                    if(value == 'Clear'){
                      clearCart(context).then((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),
                          ),
                        );
                      });
                    }
                  }
                ),
              ],
            ),
            Divider(color: Colors.grey.shade100),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showBottomSheet(context);
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors['color7'],
                      borderRadius: BorderRadius.circular(
                          20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors['color3'],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: colors['color7'],
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Add to Shopping List',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colors['color6'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade100),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cartItemsList.isEmpty
                        ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 200.0, left: 140.0),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 140.0),
                          child: Text(
                            'Shop is empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItemsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == cartItemsList.length) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(left:10.0,top:10.0),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/cartpage.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                                Text(
                                  ' Not In A Recipe',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            SizedBox(width: 50),
                            TextButton(
                              onPressed: () {
                                  deleteselectedproduct(context).then((_) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),
                                      ),
                                    );
                                  });
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: colors['color3'],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                              ],
                          ),
                              Divider(color: Colors.grey.shade300),
                        Padding(
                        padding: EdgeInsets.only(left: 1.0),
                           child: cartItems != null
                                ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                             itemCount: cartItems!.where((item) => item.recipeId == null).length,
                              itemBuilder: (context, index) {
                                final cartItem = cartItems!.where((item) => item.recipeId == null).toList()[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text('${cartItem.quantity}, ${cartItem.unit ?? ''},${cartItem.product?.name ?? 'Unknown'}', style: TextStyle(fontSize: 15)),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (String value) {
                                              if (value == 'delete') {
                                                deleteProduct(context,cartItem.productId.toString()).then((_) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),
                                                    ),
                                                  );
                                                });
                                              } else if (value == 'edit') {
                                                editpage(context,cartItem,updateCartlist);
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('Edit'),
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text('Delete'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(color: Colors.grey.shade300),
                                  ],
                                );
                              },
                            )
                                : Center(
                              child: CircularProgressIndicator(),
                            ),
                        ),
                            ],
                          );
                        } else {
                          final recipe = cartItemsList[index].recipes;
                          final recipeId = recipe?.id;
                          final recipeName = recipe?.name;
                          final mainImage = recipe?.mainImage;
                          final servingCount = recipe?.servingCount;
                          final isRecipeInfoDisplayed = index == 0 || recipeId != cartItemsList[index - 1].recipes?.id;
                          return Column(
                            children: [
                              if (recipeName != null && isRecipeInfoDisplayed)
                                ListTile(
                                  title: Text(recipeName ?? '',style: TextStyle(fontWeight: FontWeight.bold),),
                                  leading: buildLeadingImage(mainImage),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            removeFromShoppingCart(context, cartItemsList[index].recipeId, (bool isRemoved) {}).then((_) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),
                                                ),
                                              );
                                            });
                                          },
                                          backgroundColor: colors['color3'],
                                          child: Icon(Icons.remove,  color: colors['color7'], size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 15),
                              if (recipeName != null && isRecipeInfoDisplayed)
                                Container(
                                  color: Colors.grey.shade100,
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'SERVINGS: ${servingCount ?? ''}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cartItemsList[index].recipeIngredients?.length ?? 0,
                                itemBuilder: (context, ingredientIndex) {
                                  final CartItems cartItem = cartItemsList[index];
                                  final RecipeIngredientcart ingredient = cartItemsList[index].recipeIngredients![ingredientIndex];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${cartItem.quantity
                                                    ?? ''}  ${cartItem.unit ?? ''} ${ingredient.product?.name ?? ''}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (String result) async {
                                              if (result == 'recipe') {
                                                try {
                                                  final data = await fetchData('recipes/${cartItem.recipeId}');
                                                  final newProductDetails = ProductDetails.fromJson(data);
                                                  if (newProductDetails != null && newProductDetails.data?.recipe != null) {
                                                    final recipeId = cartItem.recipeId ?? 0;
                                                    Navigator.push(context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecipeDetails(details: newProductDetails, recipeId: recipeId),
                                                      ),
                                                    );
                                                  } else {
                                                    print('Error: Invalid recipe details');
                                                  }
                                                } catch (e) {
                                                  print('Error fetching recipe details: $e');
                                                }
                                              } else if (result == 'edit') {
                                                editpage(context,cartItem,updateCartlist);
                                              } else if (result == 'delete') {
                                                final int? recipeId = cartItemsList[index].recipeId;
                                                final int? productId = ingredient.productId;
                                                deleteFromCart(context, recipeId, productId) .then((_) {
                                                  Navigator.pushReplacement(context,
                                                    MaterialPageRoute(builder: (BuildContext context) => BottomNavigation(selectedIndex: widget.selectedIndex),),
                                                  );
                                                });
                                              }
                                            },
                                            itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'recipe',
                                                child: ListTile(
                                                  leading: Icon(Icons.restaurant_menu),
                                                  title: Text('Recipe'),
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('Edit'),
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text('Delete'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.grey.shade100),
                                    ],
                                  );
                                },
                              ),
                              // SizedBox(height: 15),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Address()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

