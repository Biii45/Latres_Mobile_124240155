import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> _future;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchShowDetail(widget.id);
    _isFav = FavoriteService.isFavorite(widget.id);
  }

  String _stripHtml(String? html) =>
      (html ?? 'Tidak ada ringkasan.').replaceAll(RegExp(r'<[^>]*>'), '');

  Future<void> _toggleFav(Map<String, dynamic> show) async {
    if (_isFav) {
      await FavoriteService.remove(widget.id);
    } else {
      await FavoriteService.add(show);
    }
    setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final s = snap.data!;
          final img = s['image']?['original'] ?? s['image']?['medium'];
          final genres = (s['genres'] as List).join(', ');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (img != null)
                  Image.network(img, width: double.infinity, fit: BoxFit.contain),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(s['rating']?['average']?.toString() ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        genres.isEmpty ? '-' : genres,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF44336),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Memutar ${s['name']}...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Nonton'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () => _toggleFav(s),
                              icon: Icon(
                                _isFav ? Icons.favorite : Icons.favorite_border,
                                color: _isFav
                                    ? const Color(0xFFF44336)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_stripHtml(s['summary'])),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
