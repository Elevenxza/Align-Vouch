import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggingIn = false;

  final String clientId = "86up2v6uukcqzx";
  final String clientSecret = "WPL_AP1.Cd2cSPMQy1CFh0iB.ZvAW4Q==";
  final String redirectUri = "myapp://linkedin-login";

  Future<void> signInWithLinkedIn() async {
    setState(() {
      _isLoggingIn = true;
    });

    // =========================================================================
    // CATATAN UNTUK WINDOWS TESTING:
    // Kalo lu klik di Windows, kita bypass pake data mock/simulasi profesional.
    // Tapi kalo nanti di-run di HP Android, dia otomatis jalanin OAuth asli di bawah!
    // =========================================================================
    if (Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      print("Mode Windows Testing: Membuka Pintu Belakang dengan Data Mock Asli...");
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardPage(
              userName: "Lee Hyo Rie",
              userRole: "Information Technology Student at IBI Kwik Kian Gie",
              userPhoto: "", // Kosongkan biar pake avatar default
            ),
          ),
        );
      }
      setState(() { _isLoggingIn = false; });
      return;
    }

    // ALUR OAUTH ASLI (OTOMATIS JALAN DI HP ANDROID)
    final url = Uri.https('www.linkedin.com', '/oauth/v2/authorization', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'state': 'align_vouch_secure_state',
      'scope': 'openid profile email',
    });

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: "myapp",
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code != null) {
        await tukarCodeKeToken(code);
      }
    } catch (e) {
      print("User membatalkan login atau terjadi kendala: $e");
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  // Fungsi menembak API LinkedIn untuk menukar Code dengan Access Token
  Future<void> tukarCodeKeToken(String authCode) async {
    final tokenUrl = Uri.parse('https://www.linkedin.com/oauth/v2/accessToken');

    try {
      final response = await http.post(
        tokenUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': authCode,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String accessToken = data['access_token'];

        // AMBIL DATA PROFIL USER REAL DARI ENDPOINT USERINFO LINKEDIN (OpenID Connect)
        await ambilDataProfilLinkedIn(accessToken);
      } else {
        print("Gagal menukar token: ${response.body}");
      }
    } catch (e) {
      print("Terjadi gangguan jaringan: $e");
    }
  }

  // Fungsi Baru: Nembak API Profil LinkedIn menggunakan Access Token
  Future<void> ambilDataProfilLinkedIn(String token) async {
    final profileUrl = Uri.parse('https://api.linkedin.com/v2/userinfo');

    try {
      final response = await http.get(
        profileUrl,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        // Parsing data asli dari payload OpenID Connect LinkedIn
        String name = userData['name'] ?? "LinkedIn User";
        String email = userData['email'] ?? "";
        String picture = userData['picture'] ?? ""; // URL Foto Profil Asli LinkedIn

        // Karena endpoint /userinfo tidak memberikan headline pekerjaan secara default,
        // kita set fallback rolenya sebagai Verified Professional.
        String headline = "Verified LinkedIn Professional";

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(
                userName: name,
                userRole: headline,
                userPhoto: picture,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Gagal mengambil data profil asli: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI Code lu tetep sama bawaan yang rapi kemarin
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text("Align Vouch Pro", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const Text("Dating App Profesional Tanpa Akun Palsu", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 60),
              _isLoggingIn
                  ? const CircularProgressIndicator(color: Colors.blueAccent)
                  : SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  onPressed: signInWithLinkedIn,
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text("Sign In with LinkedIn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}