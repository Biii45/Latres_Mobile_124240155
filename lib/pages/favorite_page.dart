import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada favorit'));
          }
          final items = box.values.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final s = Map<String, dynamic>.from(items[i]);
              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: s['image'] != null
                      ? Image.network(s['image'], width: 40, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(s['name']),
                  subtitle: Row(children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(s['rating']?.toString() ?? '-'),
                  ]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
                    onPressed: () => FavoriteService.remove(s['id']),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(id: s['id'])),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}