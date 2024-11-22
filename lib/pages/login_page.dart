import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_lari/pages/lupa_password.dart';
import 'package:track_lari/pages/register_page.dart';
import 'package:track_lari/service/Auth_Service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hide = true;

  void _togglePasswordVisibility() {
    setState(() {
      _hide = !_hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/logo_pussimpur.png',
                height: 125,
              ),
              const SizedBox(height: 25),
              const Text(
                'Log In RunWalk Pussimpur',
                style: TextStyle(
                  color: Color(0xFFd9d9d9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Color(0xFFd9d9d9)),
                decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: const TextStyle(
                      color: Color(0xFFd9d9d9), fontWeight: FontWeight.w900),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFd9d9d9)),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Email tidak boleh kosong';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _hide,
                style: const TextStyle(color: Color(0xFFd9d9d9)),
                decoration: InputDecoration(
                  hintText: 'password',
                  hintStyle: const TextStyle(
                      color: Color(0xFFd9d9d9), fontWeight: FontWeight.w900),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFd9d9d9)),
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                    color: const Color(0xFFd9d9d9),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Password tidak boleh kosong';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: const Text(
                  "Belum Punya Akun, Register Sekarang!",
                  style: TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthService().login(
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 206, 202, 202),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                ),
              ),
              const LupaPassword()
            ],
          ),
        ),
      ),
    );
  }
}
