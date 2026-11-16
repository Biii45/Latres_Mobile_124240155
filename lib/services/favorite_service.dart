import 'package:hive/hive.dart';

class FavoriteService {
  static Box get _box => Hive.box('favorites');

  static bool isFavorite(int id) => _box.containsKey(id);

  static Future<void> add(Map<String, dynamic> show) async {
    await _box.put(show['id'], {
      'id': show['id'],
      'name': show['name'],
      'image': show['image']?['medium'],
      'rating': show['rating']?['average'],
    });
  }

  static Future<void> remove(int id) async => await _box.delete(id);
}