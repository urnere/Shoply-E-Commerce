import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/core/shop_dao_repository.dart';
import '../../models/items_in_cart.dart';

class CartCubit extends Cubit<List<urunler_sepeti>> {
  CartCubit() : super([]);
  final shopDaoRepository = ShopDaoRepository();

  Future<void> deleteCartItem(int sepetId) async {
    try {
      
      final updatedList = state.where((item) => item.sepetId != sepetId).toList();
      emit(updatedList);
      
      await shopDaoRepository.deleteCartItem(sepetId);
      
    } catch (e) {
      await getAllCartProducts();
      rethrow;
    }
  }

  Future<void> getAllCartProducts() async {
    try {
      final cartProducts = await shopDaoRepository.getCartProducts();
      emit(cartProducts);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> addToCart(
    String name,
    String image,
    String category,
    int price,
    int siparisAdeti,
    String brand,
    int sepetId, 
  ) async {
    await shopDaoRepository.addCartItem(
      
      name,
      image,
      category,
      price,
      siparisAdeti,
      brand, 
      sepetId: sepetId,
    );
    getAllCartProducts();
  }
}
