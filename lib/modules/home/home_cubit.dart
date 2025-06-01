import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/core/shop_dao_repository.dart';
import 'package:shoply/models/products.dart';

class HomeState {
  final List<urunler> allProducts;
  final List<urunler> filteredProducts;
  final String? selectedCategory;
  final List<String> categories;

  HomeState({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategory,
    required this.categories,
  });

  HomeState copyWith({
    List<urunler>? allProducts,
    List<urunler>? filteredProducts,
    String? selectedCategory,
    List<String>? categories,
  }) {
    return HomeState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          allProducts: [],
          filteredProducts: [],
          selectedCategory: null,
          categories: [],
        ));

  var shopDaoRepository = ShopDaoRepository();

  Future<void> getAllProducts() async {
    var productList = await shopDaoRepository.getAllProducts();
    
    Set<String> categorySet = {};
    for (var product in productList) {
      if (product.kategori != null && product.kategori!.isNotEmpty) {
        categorySet.add(product.kategori!);
      }
    }
    List<String> categories = categorySet.toList();
    categories.sort();
    
    emit(HomeState(
      allProducts: productList,
      filteredProducts: productList,
      selectedCategory: null,
      categories: categories,
    ));
  }

  void filterByCategory(String? category) {
    if (category == null) {
      emit(state.copyWith(
        filteredProducts: state.allProducts,
        selectedCategory: null,
      ));
    } else {
      final filteredList = state.allProducts
          .where((product) => product.kategori == category)
          .toList();
      emit(state.copyWith(
        filteredProducts: filteredList,
        selectedCategory: category,
      ));
    }
  }
}
