import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoply/routes/app_pages.dart';
import 'package:shoply/services/auth_services.dart';
import 'package:shoply/themes/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = AuthServices();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                currentUser?.photoURL != null
                    ? NetworkImage(currentUser!.photoURL!)
                    : null,
            child:
                currentUser?.photoURL == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
          ),
          const SizedBox(height: 20),
          Text(
            currentUser?.displayName ?? "Kullanıcı Adı",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            currentUser?.email ?? "E-posta adresi",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("E-posta"),
            subtitle: Text(currentUser?.email ?? ""),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Telefon"),
            subtitle: Text(currentUser?.phoneNumber ?? "Belirtilmemiş"),
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text("E-posta Doğrulaması"),
            subtitle: Text(
              currentUser?.emailVerified ?? false
                  ? "Doğrulanmış"
                  : "Doğrulanmamış",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _auth
                  .logout()
                  .then((_) {
                    context.go(AppRoutes.INITIAL);
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Hata: $error')));
                  });
            },
            child: const Text("Çıkış Yap"),
          ),
        ],
      ),
    );
  }
}
