import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/models/products.dart';

class FavoritesState {
  final List<urunler> favoriteProducts;

  FavoritesState({required this.favoriteProducts});

  FavoritesState copyWith({List<urunler>? favoriteProducts}) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState(favoriteProducts: []));

  void toggleFavorite(urunler product) {
    final currentFavorites = List<urunler>.from(state.favoriteProducts);
    
    // Ürün zaten favorilerde mi kontrol et - daha güvenilir karşılaştırma
    final isAlreadyFavorite = currentFavorites.any((item) => 
        item.ad == product.ad && item.marka == product.marka);
    
    if (isAlreadyFavorite) {
      // Favorilerden çıkar
      currentFavorites.removeWhere((item) => 
          item.ad == product.ad && item.marka == product.marka);
    } else {
      // Favorilere ekle
      currentFavorites.add(product);
    }
    
    emit(state.copyWith(favoriteProducts: currentFavorites));
  }

  bool isFavorite(urunler product) {
    return state.favoriteProducts.any((item) => 
        item.ad == product.ad && item.marka == product.marka);
  }
}