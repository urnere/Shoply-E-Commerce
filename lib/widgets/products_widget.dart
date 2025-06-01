import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoply/models/products.dart';
import 'package:shoply/modules/cart/cart_cubit.dart';
import 'package:shoply/modules/details/product_details_page.dart';
import 'package:shoply/modules/favorites/favorites_cubit.dart';
import 'package:shoply/modules/home/home_cubit.dart';
import 'package:shoply/themes/app_colors.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.filteredProducts.isEmpty) {
          if (state.allProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    state.selectedCategory != null
                        ? "${state.selectedCategory} kategorisinde ürün bulunamadı"
                        : "Ürün bulunamadı",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.filteredProducts.length,
            itemBuilder: (context, index) {
              var urun = state.filteredProducts[index];
              return _buildProductCard(context, urun);
            },
          );
        }
      },
    );
  }

  Widget _buildProductCard(BuildContext context, urunler urun) {
    final favoritesCubit = context.read<FavoritesCubit>();
    final cartCubit = context.read<CartCubit>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: urun),
          ),
        );
      },
      child: Card(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8.0),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: AppColors.primary),
                      child:
                          urun.resim != null
                              ? Image.network(
                                "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                              : const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              urun.marka ?? "Marka",
                              style: TextStyle(
                                fontFamily: "Outfitm",
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              urun.ad ?? "İsimsiz Ürün",
                              style: const TextStyle(
                                fontFamily: "Outfitb",
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${urun.fiyat ?? 0} ",
                              style: const TextStyle(
                                fontFamily: "Outfitb",
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              "₺",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 8,
              right: 8,
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, favState) {
                  final isFavorite = favoritesCubit.isFavorite(urun);
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => favoritesCubit.toggleFavorite(urun),
                      child: Icon(
                        isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () async {
                      await cartCubit.addToCart(
                        urun.ad ?? "",
                        urun.resim ?? "",
                        urun.kategori ?? "",
                        urun.fiyat ?? 0,
                        1,
                        urun.marka ?? "",
                        urun.id ?? 0,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${urun.ad} sepete eklendi"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Iconsax.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
