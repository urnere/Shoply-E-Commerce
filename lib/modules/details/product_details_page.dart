import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoply/models/products.dart';
import 'package:shoply/modules/cart/cart_cubit.dart';
import 'package:shoply/modules/favorites/favorites_cubit.dart';
import 'package:shoply/themes/app_colors.dart';

class ProductDetailPage extends StatefulWidget {
  final urunler product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.read<FavoritesCubit>();
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = favoritesCubit.isFavorite(widget.product);
              return IconButton(
                onPressed: () => favoritesCubit.toggleFavorite(widget.product),
                icon: Icon(
                  isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  color: isFavorite ? Colors.red : AppColors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: double.infinity,
                        color: AppColors.primary,
                        child:
                            widget.product.resim != null
                                ? Image.network(
                                  "http://kasimadalan.pe.hu/urunler/resimler/${widget.product.resim}",
                                  fit: BoxFit.cover,
                                )
                                : const Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.marka ?? "Marka",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontFamily: "Outfitm",
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.product.ad ?? "İsimsiz Ürün",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Outfitb",
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "${widget.product.fiyat ?? 0}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: AppColors.primary,
                                  fontFamily: "Outfitb",
                                ),
                              ),
                              const Text(
                                " ₺",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              " ${widget.product.kategori ?? 'Belirtilmemiş'}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontFamily: "Outfitm",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Miktar seçici
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => quantity++);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Sepete Ekle butonu
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await cartCubit.addToCart(
                          widget.product.ad ?? "",
                          widget.product.resim ?? "",
                          widget.product.kategori ?? "",
                          widget.product.fiyat ?? 0,
                          quantity,
                          widget.product.marka ?? "",
                          widget.product.id ?? 0,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${widget.product.ad} sepete eklendi",
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: const Icon(Iconsax.shopping_cart),
                      label: const Text(
                        "Sepete Ekle",
                        style: TextStyle(fontSize: 16, fontFamily: "Outfitb"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
