import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoply/models/items_in_cart.dart';
import 'package:shoply/modules/cart/cart_cubit.dart';
import 'package:shoply/routes/app_pages.dart';
import 'package:shoply/themes/app_colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().getAllCartProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CartCubit, List<urunler_sepeti>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sepetinizde ürün bulunmuyor',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.HOME),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Alışverişe Başla'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, cartItems[index]);
                  },
                ),
              ),
              _buildBottomBar(cartItems),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(List<urunler_sepeti> cartItems) {
    int totalPrice = cartItems.fold(
      0,
      (sum, item) => sum + ((item.fiyat ?? 0) * (item.siparisAdet ?? 1)),
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Toplam Tutar',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Outfitm',
                ),
              ),
              Text(
                '$totalPrice ₺',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Outfitb',
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Siparişi Tamamla',
              style: TextStyle(fontFamily: 'Outfitb'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, urunler_sepeti urun) {
    final cartCubit = context.read<CartCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Future<void> handleDelete() async {
      try {
        if (urun.sepetId != null) {
          final String productName = urun.ad ?? "Ürün";
          await cartCubit.deleteCartItem(urun.sepetId!);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text("$productName sepetten çıkarıldı"),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Ürün silinirken bir hata oluştu"),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Card(
      color: AppColors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.primary,
                child:
                    urun.resim != null
                        ? Image.network(
                          "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image_not_supported, size: 30),
                            );
                          },
                        )
                        : const Center(
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    urun.ad ?? "İsimsiz Ürün",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Outfitb",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    urun.marka ?? "Marka belirtilmemiş",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: "Outfitm",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${urun.fiyat ?? 0} ",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: "Outfitb",
                        ),
                      ),
                      const Text(
                        "₺",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Adet: ${urun.siparisAdet ?? 1}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: "Outfitm",
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.trash, color: AppColors.black),
              onPressed: () async {
                await handleDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
