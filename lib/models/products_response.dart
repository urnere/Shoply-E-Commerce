import 'package:shoply/models/products.dart';

class ProductsResponse {
  List<urunler> products;
  int success;

  ProductsResponse(this.products, this.success);
  factory ProductsResponse.fromJson(Map<String,dynamic> json) {
    var success = json["success"] as int;
    var jsonArray = json["urunler"];

    var products = jsonArray != null
        ? jsonArray.map((jsonObject) => urunler.fromJson(jsonObject)).toList().cast<urunler>()
        : <urunler>[];

    return ProductsResponse(products, success);
  }
}
