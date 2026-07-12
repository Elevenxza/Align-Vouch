import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatelessWidget {
  final String userName;
  final String userRole;
  final String userPhoto;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userPhoto,
  });

  Future<List<Map<String, dynamic>>> _fetchProfessionals() async {
    // Mengambil data dari Supabase
    final response = await Supabase.instance.client
        .from('professionals')
        .select('name, role, company, initial');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text("Align Vouch", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0077B5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProfessionals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0077B5)));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data profesional ditemukan"));
          }

          final professionals = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Professional Network",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Profil Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(radius: 25, backgroundColor: Color(0xFF0077B5), child: Icon(Icons.person, color: Colors.white)),
                    title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(userRole),
                  ),
                ),
                const SizedBox(height: 24),

                // List Data dari Supabase
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: professionals.length,
                  itemBuilder: (context, index) {
                    final person = professionals[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE1ECF4),
                          child: Text(person["initial"]?.toString() ?? "?", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0077B5))),
                        ),
                        title: Text(person["name"]?.toString() ?? "No Name", style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text("${person["role"] ?? ""} • ${person["company"] ?? ""}"),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}