import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class ResultPage extends StatefulWidget {
  final String name;
  final String linkedinUrl;

  const ResultPage({
    super.key,
    required this.name,
    required this.linkedinUrl,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();

    // FORMAT FIX: Mengubah spasi menjadi strip (-) agar cocok dengan format URL asli LinkedIn
    String namaFormatUrl = widget.name.toLowerCase().trim().replaceAll(' ', '-');
    String urlBersih = widget.linkedinUrl.toLowerCase();

    // Sekarang sistem mengecek apakah URL mengandung format 'linkedin.com/in/'
    // DAN mengandung nama lu yang sudah berformat strip (lee-hyo-rie)
    if (urlBersih.contains('linkedin.com/in/') && urlBersih.contains(namaFormatUrl)) {
      _isSuccess = true;
    } else {
      _isSuccess = false;
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hasil Verifikasi"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Mencocokkan Profil LinkedIn...",
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _isSuccess ? Icons.check_circle : Icons.cancel,
                size: 100,
                color: _isSuccess ? Colors.green : Colors.red
            ),
            const SizedBox(height: 20),
            Text(
              _isSuccess ? "VERIFIED!" : "VERIFICATION FAILED",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _isSuccess ? Colors.green : Colors.red
              ),
            ),
            const SizedBox(height: 20),

            Text(
              _isSuccess ? "Profil: ${widget.name}" : "Verifikasi Gagal!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                _isSuccess
                    ? widget.linkedinUrl
                    : "Nama yang anda input tidak cocok dengan format username di URL LinkedIn.",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            if (_isSuccess) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardPage()),
                  );
                },
                child: const Text(
                  "MASUK KE DASHBOARD",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
            ],

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "KEMBALI",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}