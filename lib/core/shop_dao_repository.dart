import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoply/models/products.dart';
import 'package:shoply/models/products_response.dart';

import '../models/items_in_cart.dart';
import '../models/items_in_cart_response.dart';

class ShopDaoRepository {
  List<urunler> parseProducts(String response) {
    try {
      final decoded = json.decode(response);
      return ProductsResponse.fromJson(decoded).products;
    } catch (e) {
      print("Error parsing products: $e");
      return [];
    }
  }

  List<urunler_sepeti> parseCartProducts(String response) {
    try {
      final decoded = json.decode(response);
      var items = ItemsInCartResponse.fromJson(decoded).cartItem;
      return items;
    } catch (e) {
      print("Error parsing cart products: $e");
      return [];
    }
  }

  Future<List<urunler>> getAllProducts() async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var response = await Dio().get(url);
    print(response.data.toString());
    return parseProducts(response.data.toString());
  }

  Future<List<urunler_sepeti>> getCartProducts({
    String username = "baris_ozdemir",
  }) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php";
    var data = {"kullaniciAdi": username};
    var response = await Dio().post(url, data: FormData.fromMap(data));
    return parseCartProducts(response.data.toString());
  }

  Future<void> addCartItem(
    String name,
    String image,
    String category,
    int price,
    int siparisAdeti,
    String brand, {
    String username = "baris_ozdemir",
    required int sepetId,
  }) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php";

    var data = {
      "sepetId": sepetId,
      "ad": name,
      "resim": image,
      "kategori": category,
      "fiyat": price,
      "marka": brand,
      "kullaniciAdi": username,
      "siparisAdeti": siparisAdeti,
    };

    await Dio().post(url, data: FormData.fromMap(data));
  }

  Future<void> deleteCartItem(int id) async {
    try {
      var url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php";
      var data = {"sepetId": id, "kullaniciAdi": "baris_ozdemir"};

      var response = await Dio().post(url, data: FormData.fromMap(data));

      if (response.data.toString().contains("error")) {
        throw Exception("Ürün silinemedi: ${response.data}");
      }
    } catch (e) {
      throw Exception("Ürün silinirken bir hata oluştu: $e");
    }
  }
}
