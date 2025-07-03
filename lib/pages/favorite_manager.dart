class FavoriteManager {
  static final List<Map<String, dynamic>> _favorites = [];

  static List<Map<String, dynamic>> get favorites => _favorites;

  static void add(Map<String, dynamic> item) {
    if (!_favorites.any((e) => e['title'] == item['title'])) {
      _favorites.add(item);
    }
  }

  static void remove(String title) {
    _favorites.removeWhere((e) => e['title'] == title);
  }

  static bool isFavorite(String title) {
    return _favorites.any((e) => e['title'] == title);
  }
}
