import 'package:flutter/material.dart';
import '../services/berita_service.dart';
import 'detail_berita_page.dart';
import 'user_home.dart';
import 'favorite_page.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> categories = [
    'Trending',
    'Pemerintahan / Desa',
    'Politik',
    'Bencana Alam',
  ];

  Map<String, List<dynamic>> categorizedBerita = {};
  bool isLoading = true;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchAndCategorizeBerita();
  }

  Future<void> fetchAndCategorizeBerita() async {
    try {
      final berita = await BeritaService.fetchBerita();
      final Map<String, List<dynamic>> grouped = {};

      for (var category in categories) {
        grouped[category] = berita
            .where((item) =>
                item['category']?.toLowerCase() == category.toLowerCase())
            .toList();
      }

      setState(() {
        categorizedBerita = grouped;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching berita: $e");
      setState(() => isLoading = false);
    }
  }

  void onTabTapped(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserHome()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FavoritePage(favorites: []), // perbaikan: tambahkan parameter
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          elevation: 0,
          title: Row(
            children: [
              Icon(Icons.article, color: Colors.orange[700]),
              SizedBox(width: 8),
              Text(
                'GarselFeed',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [], // ← dikosongkan sesuai permintaan
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.green[100],
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: categories.map((category) {
                  final beritaList = categorizedBerita[category] ?? [];
                  if (beritaList.isEmpty) {
                    return Center(
                      child: Text(
                        "Belum ada berita di kategori ini",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: beritaList.length,
                    itemBuilder: (context, index) {
                      final item = beritaList[index];
                      return Card(
                        elevation: 3,
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          title: Text(
                            item['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                          subtitle: Text(
                            'Kategori: ${item['category']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
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
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.grey,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Favorite"),
          ],
        ),
      ),
    );
  }
}
