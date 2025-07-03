import 'package:flutter/material.dart';
import 'login_page.dart'; // hanya untuk admin
import 'register_admin_page.dart';
import 'user_home.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_rounded, size: 80, color: Colors.orange[700]),
              SizedBox(height: 24),
              Text(
                'GarselFeed',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Cerita Garut Selatan Hari Ini',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                width: 300, // Ukuran sedang
                child: ElevatedButton.icon(
                  icon: Icon(Icons.remove_red_eye),
                  label: Text('Lihat Berita'),
                  style: _buttonStyle(Colors.green.shade700),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => UserHome()),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              SizedBox(
                width: 300, // Ukuran sedang
                child: ElevatedButton.icon(
                  icon: Icon(Icons.admin_panel_settings),
                  label: Text('Login Admin'),
                  style: _buttonStyle(Colors.orange.shade700),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterAdminPage()),
                  );
                },
                child: Text(
                  'Daftar sebagai Admin',
                  style: TextStyle(color: Colors.orange[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      minimumSize: Size(0, 48), // tinggi tombol
      textStyle: TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
