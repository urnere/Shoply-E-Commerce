import 'items_in_cart.dart';

class ItemsInCartResponse {
  List<urunler_sepeti> cartItem;
  int success;

  ItemsInCartResponse(this.cartItem, this.success);

  factory ItemsInCartResponse.fromJson(Map<String, dynamic> json) {
    var success = json["success"] as int;
    var jsonArray = json["urunler_sepeti"] as List;

    var urunler =
        jsonArray
            .map((jsonObject) => urunler_sepeti.fromJson(jsonObject))
            .toList();

    return ItemsInCartResponse(urunler, success);
  }
}
