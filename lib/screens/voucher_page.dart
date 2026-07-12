import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  // 1. Inisialisasi TextEditingController untuk menangkap input teks
  final TextEditingController _voucherController = TextEditingController();
  bool _isValidating = false;

  // 2. Fungsi validasi ketika tombol "Validate Code" ditekan
  void _validateVoucherCode() async {
    String inputCode = _voucherController.text.trim();

    // Validasi awal: jika kotak input kosong
    if (inputCode.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Peringatan"),
          content: const Text("Silakan masukkan kode voucher terlebih dahulu!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isValidating = true;
    });

    // Simulasi loading nge-cek data ke server selama 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _isValidating = false;
    });

    // Cek kecocokan kode voucher (Contoh kode sukses: ALIGN100 atau VOUCH2026)
    if (inputCode.toUpperCase() == "ALIGN100" || inputCode.toUpperCase() == "VOUCH2026") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          title: const Text("Voucher Valid!"),
          content: Text("Selamat! Kode '$inputCode' berhasil diverifikasi dan fitur premium aktif."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _voucherController.clear(); // Bersihkan text field setelah sukses
              },
              child: const Text("Selesai"),
            ),
          ],
        ),
      );
    } else {
      // Jika kode salah
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.error_outline_rounded, color: Colors.red, size: 50),
          title: const Text("Voucher Tidak Valid"),
          content: Text("Kode '$inputCode' salah atau tidak terdaftar di database."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Coba Lagi", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  // 3. Wajib di-dispose untuk menghindari memory leaks sesuai materi kuliah
  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text("Claim Voucher", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.confirmation_num_outlined, size: 100, color: const Color(0xFF0077B5).withOpacity(0.8)),
              const SizedBox(height: 24),
              const Text(
                "Masukkan Kode Voucher Anda",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masukkan kode voucher unik profesional Anda untuk mengaktifkan fitur premium Align Vouch.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // KOTAK TEXTFIELD INPUT (IMPLEMENTASI UTAMA TEORI KULIAH)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _voucherController, // Menghubungkan controller input
                    textCapitalization: TextCapitalization.characters, // Otomatis caps lock biar rapi
                    decoration: InputDecoration(
                      labelText: "Kode Voucher",
                      hintText: "Contoh: ALIGN100",
                      prefixIcon: const Icon(Icons.vpn_key_rounded, color: Color(0xFF0077B5)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0077B5), width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // TOMBOL DENGAN LOADING STATE
              _isValidating
                  ? const CircularProgressIndicator(color: Color(0xFF0077B5))
                  : SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _validateVoucherCode, // Memicu fungsi event handler
                  child: const Text(
                    "Validate Code",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}