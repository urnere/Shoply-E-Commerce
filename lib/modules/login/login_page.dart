import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoply/routes/app_pages.dart';
import 'package:shoply/services/auth_services.dart';
import 'package:shoply/themes/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final  _auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Shoply",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Outfitb',
              ),
            ),
            const SizedBox(height: 100), // Üstten boşluk
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white, // Buton rengi
                foregroundColor: AppColors.primary, // Buton yazı rengi
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Buton içi boşluk
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Buton köşe yuvarlama
                ),
              ),
              onPressed: () {
                _auth.loginWithGoogle().then((userCredential) {
                  if (userCredential.user != null) {
                    // Giriş başarılı, anasayfaya yönlendir
                    context.go(AppRoutes.HOME);
                  } else {
                    // Giriş başarısız, hata mesajı göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Giriş başarısız')),
                    );
                  }
                }).catchError((error) {
                  // Hata durumunda mesaj göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hata: $error')),
                  );
                });
                
              }, 
              child: const Text("Google ile Giriş Yap")
            ),
          ],
        ),
      ),
    );
  }
}
