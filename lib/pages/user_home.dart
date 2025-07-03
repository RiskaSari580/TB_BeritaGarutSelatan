import 'package:flutter/material.dart';
import '../services/berita_service.dart';
import 'detail_berita_page.dart';
import 'explore_page.dart';
import 'favorite_page.dart';
import 'landing_page.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<dynamic> berita = [];
  List<Map<String, dynamic>> favoriteList = [];
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadBerita();
  }

  void loadBerita() async {
    try {
      final data = await BeritaService.fetchBerita();
      setState(() {
        berita = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void toggleFavorite(Map<String, dynamic> item) {
    setState(() {
      final alreadySaved = favoriteList.any((fav) => fav['title'] == item['title']);
      if (alreadySaved) {
        favoriteList.removeWhere((fav) => fav['title'] == item['title']);
      } else {
        favoriteList.add(item);
      }
    });
  }

  bool isFavorite(Map<String, dynamic> item) {
    return favoriteList.any((fav) => fav['title'] == item['title']);
  }

  void onNavTapped(int index) {
    if (index == currentIndex) return;

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ExplorePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FavoritePage(favorites: favoriteList)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LandingPage()),
            );
          },
        ),
        title: Row(
          children: [
            Icon(Icons.article, color: Colors.orange[700]),
            SizedBox(width: 8),
            Text(
              'GarselFeed',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What You", style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text(
                    "Interested Today",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[900]),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: berita.take(4).map((item) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailBeritaPage(
                                  title: item['title'],
                                  content: item['content'],
                                  imageUrl: item['imageUrl'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 260,
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: Image.network(
                                      item['imageUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(Icons.broken_image, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("3h ago", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Highlights",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[900]),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Fitur Dalam Pengembangan"),
                              content: Text("Halaman 'See all' akan hadir di versi berikutnya."),
                              actions: [
                                TextButton(
                                  child: Text("Tutup"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("See all", style: TextStyle(color: Colors.green[700])),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: berita.length,
                    itemBuilder: (context, index) {
                      final item = berita[index];
                      final isFav = isFavorite(item);

                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 6),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: Image.network(
                              item['imageUrl'],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.bookmark : Icons.bookmark_border,
                                color: isFav ? Colors.orange[700] : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => toggleFavorite(item),
                            ),
                          ],
                        ),
                        subtitle: Text("2h ago", style: TextStyle(color: Colors.grey[600])),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailBeritaPage(
                                title: item['title'],
                                content: item['content'],
                                imageUrl: item['imageUrl'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        onTap: onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Favorite"),
        ],
      ),
    );
  }
}
 