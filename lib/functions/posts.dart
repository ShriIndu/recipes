//home page list//
class Categorie {
  String name, image;
  Categorie({required this.name, required this.image});
}
//cuisines list//
class Cuisine {
  int id;
  String name, image;
  Cuisine({required this.id,required this.name, required this.image});
}
/*******diet list*************/
class Diets {
  String name,image;
  Diets({required this.name, required this.image});
}
/*******courses list************/
class Courses {
  int? id;
  String name, image;
  Courses({required this.id,required this.name, required this.image});
}
//for search//
class searchlist {
  List<Data>? data;

  searchlist({this.data});

  searchlist.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Data {
  Recipe? recipes;
  Cuisines? cuisines;
  int? id;
  int? recipeId;
  int? cuisinesId;

  Data({this.recipes, this.cuisines, this.id, this.recipeId, this.cuisinesId});

  Data.fromJson(Map<String, dynamic> json) {
    recipes = json['recipes'] != null ? Recipe.fromJson(json['recipes']) : null;
    cuisines = json['cuisines'] != null ? Cuisines.fromJson(json['cuisines']) : null;
    id = json['id'];
    recipeId = json['recipe_id'];
    cuisinesId = json['cuisines_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    if (this.cuisines != null) {
      data['cuisines'] = this.cuisines!.toJson();
    }
    data['id'] = this.id;
    data['recipe_id'] = this.recipeId;
    data['cuisines_id'] = this.cuisinesId;
    return data;
  }
}
class Cuisines {
  final int id;
  final String name;
  final String? image;

  Cuisines({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Cuisines.fromJson(Map<String, dynamic> json) {
    return Cuisines(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image' : image,
    };
  }
}
class Recipe {
  final int id;
  final String name;
  final double? reviewStar;
  final String? mainImage;
  final String? createdDate;

  Recipe({
    required this.id,
    required this.name,
    required this.reviewStar,
    required this.mainImage,
    required this.createdDate,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      reviewStar: json['review_star'] != null ? json['review_star'].toDouble() : null,
      mainImage: json['main_image'],
      createdDate: json['created_date'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'review_star': reviewStar,
      'main_image': mainImage,
      'created_date': createdDate,
    };
  }
}
//product page//
class RecipeButtonList {
  String name;
  RecipeButtonList ({required this.name});
}
class ProductDetails {
  Data2? data;

  ProductDetails({this.data});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data2.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class Data2 {
  Recipe1? recipe;

  Data2({this.recipe});

  Data2.fromJson(Map<String, dynamic> json) {
    recipe =
    json['recipe'] != null ? new Recipe1.fromJson(json['recipe']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recipe != null) {
      data['recipe'] = this.recipe!.toJson();
    }
    return data;
  }
}
class Recipe1 {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;
  List<Nutritions>? nutritions;
  List<Product>? product;

  Recipe1(
      {this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
        this.nutritions,
        this.product});

  Recipe1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?? null;
    totalMinutes = json['total_minutes']?.toDouble();;
    ingredientsCount = json['ingredients_count'];
    servingCount = json['serving_count'];
    calories = json['calories'];
    reviewCount = json['review_count'];
    reviewStar = json['review_star']?.toDouble();;
    preparationTime = json['preparation_time'];
    cookTime = json['cook_time'];
    inactiveTime = json['inactive_time'];
    mainImage = json['main_image']?? null;
    mainVideo = json['main_video']?? null;
    status = json['status'];
    createdDate = json['created_date']?? null;
    createdUserid = json['created_userid'];
    if (json['nutritions'] != null) {
      nutritions = <Nutritions>[];
      json['nutritions'].forEach((v) {
        nutritions!.add(new Nutritions.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_minutes'] = this.totalMinutes;
    data['ingredients_count'] = this.ingredientsCount;
    data['serving_count'] = this.servingCount;
    data['calories'] = this.calories;
    data['review_count'] = this.reviewCount;
    data['review_star'] = this.reviewStar;
    data['preparation_time'] = this.preparationTime;
    data['cook_time'] = this.cookTime;
    data['inactive_time'] = this.inactiveTime;
    data['main_image'] = this.mainImage;
    data['main_video'] = this.mainVideo;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['created_userid'] = this.createdUserid;
    if (this.nutritions != null) {
      data['nutritions'] = this.nutritions!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Nutritions {
  int? id;
  String? name;
  RecipeNutrition? recipeNutrition;

  Nutritions({this.id, this.name, this.recipeNutrition});

  Nutritions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    recipeNutrition = json['RecipeNutrition'] != null
        ? new RecipeNutrition.fromJson(json['RecipeNutrition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.recipeNutrition != null) {
      data['RecipeNutrition'] = this.recipeNutrition!.toJson();
    }
    return data;
  }
}
class RecipeNutrition {
  int? id;
  int? recipeId;
  int? nutritionId;
  String? value;

  RecipeNutrition({this.id, this.recipeId, this.nutritionId, this.value});

  RecipeNutrition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    nutritionId = json['nutrition_id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipe_id'] = this.recipeId;
    data['nutrition_id'] = this.nutritionId;
    data['value'] = this.value;
    return data;
  }
}
class Product {
  int? id;
  String? name;
  RecipeIngredient? recipeIngredient;

  Product({this.id, this.name, this.recipeIngredient});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    recipeIngredient = json['RecipeIngredient'] != null
        ? new RecipeIngredient.fromJson(json['RecipeIngredient'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.recipeIngredient != null) {
      data['RecipeIngredient'] = this.recipeIngredient!.toJson();
    }
    return data;
  }
}
class RecipeIngredient {
  int? id;
  int? recipeId;
  String? usQuantity;
  String? usUnit;
  String? quantity;
  String? unit;
  int? productId;
  Null? comments;

  RecipeIngredient(
      {this.id,
        this.recipeId,
        this.usQuantity,
        this.usUnit,
        this.quantity,
        this.unit,
        this.productId,
        this.comments});

  RecipeIngredient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    usQuantity = json['us_quantity'];
    usUnit = json['us_unit'];
    quantity = json['quantity'];
    unit = json['unit'];
    productId = json['product_id'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipe_id'] = this.recipeId;
    data['us_quantity'] = this.usQuantity;
    data['us_unit'] = this.usUnit;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['product_id'] = this.productId;
    data['comments'] = this.comments;
    return data;
  }
}
//cart page List 'fetchCartList'//
class cartListDisplay {
  Datacart? data;

  cartListDisplay({this.data});

  cartListDisplay.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Datacart.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class Datacart {
  List<CartItems>? cartItems;

  Datacart({this.cartItems});

  Datacart.fromJson(Map<String, dynamic> json) {
    if (json['cartItems'] != null) {
      cartItems = <CartItems>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class CartItems {
  int? id;
  int? recipeId;
  int? productId;
  int? customerId;
  int? orderId;
  String? uniqueId;
  double? quantity;
  String? unit;
  Null? price;
  String? addedTime;
  String? json;
  Recipescart? recipes;
  Product? product;
  List<RecipeIngredientcart>? recipeIngredients;

  CartItems(
      {this.id,
        this.recipeId,
        this.productId,
        this.customerId,
        this.orderId,
        this.uniqueId,
        this.quantity,
        this.unit,
        this.price,
        this.addedTime,
        this.json,
        this.recipes,
        this.product,
        this.recipeIngredients});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    productId = json['product_id'];
    customerId = json['customer_id'];
    orderId = json['order_id'];
    uniqueId = json['unique_id'];
    quantity = json['quantity']?.toDouble();
    unit = json['unit'];
    price = json['price'];
    addedTime = json['added_time'];
    this.json = json['json'];
    recipes =
    json['recipes'] != null ? new Recipescart.fromJson(json['recipes']) : null;
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['recipe_ingredients'] != null) {
      recipeIngredients = <RecipeIngredientcart>[]; // Change here
      json['recipe_ingredients'].forEach((v) {
        recipeIngredients!.add(new RecipeIngredientcart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipe_id'] = this.recipeId;
    data['product_id'] = this.productId;
    data['customer_id'] = this.customerId;
    data['order_id'] = this.orderId;
    data['unique_id'] = this.uniqueId;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['added_time'] = this.addedTime;
    data['json'] = this.json;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.recipeIngredients != null) {
      data['recipe_ingredients'] =
          this.recipeIngredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Recipescart {
  int? id;
  String? name;
  String? mainImage;
  int? servingCount;


  Recipescart(
      {this.id, this.name, this.mainImage, this.servingCount});

  Recipescart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainImage = json['main_image'];
    servingCount = json['serving_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['serving_count'] = this.servingCount;
    return data;
  }
}
class Productcart {
  int? id;
  String? name;


  Productcart({this.id, this.name});

  Productcart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
class RecipeIngredientcart {
  int? id;
  int? recipeId;
  String? usQuantity;
  String? usUnit;
  String? quantity;
  String? unit;
  int? productId;
  Null? comments;
  Product? product;

  RecipeIngredientcart(
      {this.id,
        this.recipeId,
        this.usQuantity,
        this.usUnit,
        this.quantity,
        this.unit,
        this.productId,
        this.comments,
        this.product});

  RecipeIngredientcart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    usQuantity = json['us_quantity'];
    usUnit = json['us_unit'];
    quantity = json['quantity'];
    unit = json['unit'];
    productId = json['product_id'];
    comments = json['comments'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipe_id'] = this.recipeId;
    data['us_quantity'] = this.usQuantity;
    data['us_unit'] = this.usUnit;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['product_id'] = this.productId;
    data['comments'] = this.comments;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
//cart page Extra Ingredients adding//
class ExtraIngredients {
  DataEI? data;

  ExtraIngredients({this.data});

  ExtraIngredients.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DataEI.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class DataEI {
  int? count;
  List<Rows>? rows;

  DataEI({this.count, this.rows});

  DataEI.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Rows {
  int? id;
  String? name;

  Rows({this.id, this.name});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
//display product in cartpage//
class ProductListCart {
  DataPC? data;

  ProductListCart({this.data});

  ProductListCart.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataPC.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class DataPC {
  List<DataProduct>? data;
  int? recordsTotal;
  int? recordsFiltered;
  Null? draw;

  DataPC({this.data, this.recordsTotal, this.recordsFiltered, this.draw});

  DataPC.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataProduct>[];
      json['data'].forEach((v) {
        data!.add(new DataProduct.fromJson(v));
      });
    }
    recordsTotal = json['recordsTotal'];
    recordsFiltered = json['recordsFiltered'];
    draw = json['draw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['recordsTotal'] = this.recordsTotal;
    data['recordsFiltered'] = this.recordsFiltered;
    data['draw'] = this.draw;
    return data;
  }
}
class DataProduct{
  int? id;
  String? name;
  Null? buyCost;
  Null? sellCost;
  Null? brand;
  String? image;
  int? status;
  String? addedDate;

  DataProduct(
      {this.id,
        this.name,
        this.buyCost,
        this.sellCost,
        this.brand,
        this.image,
        this.status,
        this.addedDate});

  DataProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    buyCost = json['buy_cost'];
    sellCost = json['sell_cost'];
    brand = json['brand'];
    image = json['image'];
    status = json['status'];
    addedDate = json['added_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['buy_cost'] = this.buyCost;
    data['sell_cost'] = this.sellCost;
    data['brand'] = this.brand;
    data['image'] = this.image;
    data['status'] = this.status;
    data['added_date'] = this.addedDate;
    return data;
  }
}
//add products to cart ' addToCart'//
class AddProducts {
  int? status;
  String? message;
  DataAddCart? data;

  AddProducts({this.status,this.message,this.data});

  AddProducts.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataAddCart.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class DataAddCart {
  bool? success;
  DataAc? data;

  DataAddCart({this.success, this.data});

  DataAddCart.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new  DataAc.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class DataAc {
  int? productId;
  int? orderId;
  String? uniqueId;

  DataAc(
      {this.productId,
        this.orderId,
        this.uniqueId});

  DataAc.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    orderId = json['order_id'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['order_id'] = this.orderId;
    data['unique_id'] = this.uniqueId;
    return data;
  }
}
//address display in address.dart//
class SaveAddress {
  addressData? data;

  SaveAddress({this.data});

  SaveAddress.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new addressData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class addressData {
  Customer? customer;
  List<Addresses>? addresses;

  addressData({this.customer, this.addresses});

  addressData.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Customer {
  int? id;
  String? customerName;

  Customer({this.id, this.customerName});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_name'] = this.customerName;
    return data;
  }
}
class Addresses {
  int? id;
  int? customerId;
  String? address;
  String? pincode;
  String? latitude;
  String? longitude;
  String? createdDate;

  Addresses(
      {this.id,
        this.customerId,
        this.address,
        this.pincode,
        this.latitude,
        this.longitude,
        this.createdDate});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    address = json['address'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_date'] = this.createdDate;
    return data;
  }
}
//customer details//
class Customerdetails {
  CustomerData? data;
  Customerdetails({this.data});
  Customerdetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CustomerData.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class CustomerData {
  String? firstName;
  String? lastName;
  String? email;
  String? profileImagePath;
  String? phoneNo;
  String? dOB;
  String? gender;

  CustomerData({this.firstName, this.lastName, this.email,this.profileImagePath,this.phoneNo,
    this.dOB,
    this.gender});
  CustomerData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImagePath = json['profile_image_path'];
    phoneNo = json['phone_no'];
    dOB = json['DOB'];
    gender = json['Gender'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_image_path'] = this.profileImagePath;
    data['phone_no'] = this.phoneNo;
    data['DOB'] = this.dOB;
    data['Gender'] = this.gender;
    return data;
  }
}
/**************updated customerdata******/
class updateCustomerData {
  updateData? data;

  updateCustomerData({this.data});

  updateCustomerData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new updateData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class updateData {
  updateCustomer? customer;

  updateData({this.customer});

  updateData.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null ? new updateCustomer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}
class updateCustomer {
  int? id;
  String? firstName;
  String? lastName;
  String? totalAmount;
  String? amountDue;
  String? phoneNo;
  String? email;
  String? password;
  String? profileImagePath;
  String? gender;
  String? dOB;
  int? status;

  updateCustomer(
      {this.id,
        this.firstName,
        this.lastName,
        this.totalAmount,
        this.amountDue,
        this.phoneNo,
        this.email,
        this.password,
        this.profileImagePath,
        this.gender,
        this.dOB,
        this.status});

  updateCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    totalAmount = json['total_amount'];
    amountDue = json['amount_due'];
    phoneNo = json['phone_no'];
    email = json['email'];
    password = json['password'];
    profileImagePath = json['profile_image_path'];
    gender = json['gender'];
    dOB = json['DOB'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['total_amount'] = this.totalAmount;
    data['amount_due'] = this.amountDue;
    data['phone_no'] = this.phoneNo;
    data['email'] = this.email;
    data['password'] = this.password;
    data['profile_image_path'] = this.profileImagePath;
    data['gender'] = this.gender;
    data['DOB'] = this.dOB;
    data['status'] = this.status;
    return data;
  }
}
/***************Reccommended for you recipes**********************/
class ARData {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  ARData(
      { this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
      });
}
/*************premium Recipes *************************/
class PremiumData {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  PremiumData(
      { this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
      });
}
/***********guided recipes*********************/
class GuidedData {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  GuidedData(
      { this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
      });
}
/********desswets*******************************/
class DessertsData {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  DessertsData(
      { this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
      });
}
/****************Healthy*****************************/
class HealthyData {
  int? id;
  String? name;
  double? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  HealthyData(
      { this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid,
      });
}
/***************favorite**********************/
class Favorite {
  FavoriteData? data;

  Favorite({this.data});

  Favorite.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FavoriteData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class FavoriteData {
  List<SavedRecipes>? savedRecipes;

  FavoriteData({this.savedRecipes});

  FavoriteData.fromJson(Map<String, dynamic> json) {
    if (json['savedRecipes'] != null) {
      savedRecipes = <SavedRecipes>[];
      json['savedRecipes'].forEach((v) {
        savedRecipes!.add(new SavedRecipes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.savedRecipes != null) {
      data['savedRecipes'] = this.savedRecipes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class SavedRecipes {
  int? id;
  int? customerId;
  String? savedAt;
  FavoriteRecipes? recipes;

  SavedRecipes({this.id, this.customerId, this.savedAt, this.recipes});

  SavedRecipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    savedAt = json['saved_at'];
    recipes =
    json['recipes'] != null ? new FavoriteRecipes.fromJson(json['recipes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['saved_at'] = this.savedAt;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    return data;
  }
}
class FavoriteRecipes {
  int? id;
  String? name;
  String? mainImage;
  double? reviewStar;

  FavoriteRecipes({this.id, this.name, this.mainImage, this.reviewStar});

  FavoriteRecipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainImage = json['main_image'];
    reviewStar = json['review_star']?.toDouble();;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['review_star'] = this.reviewStar;
    return data;
  }
}
/********************cuisines full detail***************/
class cuisineslistdetails {
  cuisineslist? data;

  cuisineslistdetails({this.data});

  cuisineslistdetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new  cuisineslist.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class  cuisineslist {
  List< CuisineslistRecipes>? recipes;

  cuisineslist({this.recipes});

  cuisineslist.fromJson(Map<String, dynamic> json) {
    if (json['recipes'] != null) {
      recipes = < CuisineslistRecipes>[];
      json['recipes'].forEach((v) {
        recipes!.add(new  CuisineslistRecipes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class  CuisineslistRecipes {
  int? id;
  String? name;
  int? totalMinutes;
  int? ingredientsCount;
  int? servingCount;
  int? calories;
  int? reviewCount;
  double? reviewStar;
  int? preparationTime;
  int? cookTime;
  int? inactiveTime;
  String? mainImage;
  String? mainVideo;
  int? status;
  String? createdDate;
  int? createdUserid;

  CuisineslistRecipes(
      {this.id,
        this.name,
        this.totalMinutes,
        this.ingredientsCount,
        this.servingCount,
        this.calories,
        this.reviewCount,
        this.reviewStar,
        this.preparationTime,
        this.cookTime,
        this.inactiveTime,
        this.mainImage,
        this.mainVideo,
        this.status,
        this.createdDate,
        this.createdUserid});

  CuisineslistRecipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalMinutes = json['total_minutes'];
    ingredientsCount = json['ingredients_count'];
    servingCount = json['serving_count'];
    calories = json['calories'];
    reviewCount = json['review_count'];
    reviewStar = json['review_star']?.toDouble();
    preparationTime = json['preparation_time'];
    cookTime = json['cook_time'];
    inactiveTime = json['inactive_time'];
    mainImage = json['main_image'];
    mainVideo = json['main_video'];
    status = json['status'];
    createdDate = json['created_date'];
    createdUserid = json['created_userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_minutes'] = this.totalMinutes;
    data['ingredients_count'] = this.ingredientsCount;
    data['serving_count'] = this.servingCount;
    data['calories'] = this.calories;
    data['review_count'] = this.reviewCount;
    data['review_star'] = this.reviewStar;
    data['preparation_time'] = this.preparationTime;
    data['cook_time'] = this.cookTime;
    data['inactive_time'] = this.inactiveTime;
    data['main_image'] = this.mainImage;
    data['main_video'] = this.mainVideo;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['created_userid'] = this.createdUserid;
    return data;
  }
}
//******************************orderhistory*********************//
class Orderdhistory {
  orderData? data;

  Orderdhistory({this.data});

  Orderdhistory.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new orderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class orderData {
  List<Orders>? orders;

  orderData({this.orders});

  orderData.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Orders {
  int? id;
  int? customerId;
  int? recipeId;
  String? orderStatus;
  int? orderId;
  String? comments;
  String? paymentStatus;
  String? addedTime;
  orderRecipes? recipes;

  Orders(
      {this.id,
        this.customerId,
        this.recipeId,
        this.orderStatus,
        this.orderId,
        this.comments,
        this.paymentStatus,
        this.addedTime,
        this.recipes});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    recipeId = json['recipe_id'];
    orderStatus = json['order_status'];
    orderId = json['order_id'];
    comments = json['comments'];
    paymentStatus = json['payment_status'];
    addedTime = json['added_time'];
    recipes =
    json['recipes'] != null ? new orderRecipes.fromJson(json['recipes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['recipe_id'] = this.recipeId;
    data['order_status'] = this.orderStatus;
    data['order_id'] = this.orderId;
    data['comments'] = this.comments;
    data['payment_status'] = this.paymentStatus;
    data['added_time'] = this.addedTime;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    return data;
  }
}
class orderRecipes {
  int? id;
  String? name;
  String? mainImage;
  int? servingCount;

  orderRecipes({this.id, this.name, this.mainImage, this.servingCount});

  orderRecipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainImage = json['main_image'];
    servingCount = json['serving_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['serving_count'] = this.servingCount;
    return data;
  }
}

