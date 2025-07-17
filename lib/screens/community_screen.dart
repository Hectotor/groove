import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communauté Festivalière'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Naviguer vers les notifications
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Barre de recherche
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher des festivals, artistes ou discussions...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 20),
          // Filtres
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Tous'),
                _buildFilterChip('Électro'),
                _buildFilterChip('Rock'),
                _buildFilterChip('Hip-Hop'),
                _buildFilterChip('Jazz'),
                _buildFilterChip('Reggae'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Publications
          _buildPost(
            'Emma T.',
            '12 min',
            'https://randomuser.me/api/portraits/women/44.jpg',
            'Mon expérience à Tomorrowland 2024',
            'Incroyable expérience à Tomorrowland cette année ! La scène principale était tout simplement époustouflante. Je recommande vivement de réserver l\'hébergement en avance, les bonnes affaires partent vite !',
            'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            124,
            28,
            'Électro',
          ),
          const Divider(),
          _buildPost(
            'Lucas M.',
            '1h',
            'https://randomuser.me/api/portraits/men/32.jpg',
            'Conseils pour premier festival',
            'Je vais à mon premier festival (Glastonbury) et j\'aimerais des conseils sur ce qu\'il faut absolument emporter. Des vétérans des festivals dans le coin ?',
            'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            87,
            42,
            'Rock',
          ),
          const Divider(),
          _buildPost(
            'Sophie K.',
            '3h',
            'https://randomuser.me/api/portraits/women/68.jpg',
            'Meilleurs festivals de jazz en Europe ?',
            'Je cherche des recommandations pour des festivals de jazz en Europe cet été. J\'aime particulièrement le jazz manouche et le jazz fusion. Des idées ?',
            'https://images.unsplash.com/photo-1514525252781-ee8f1c1e0e1b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            53,
            17,
            'Jazz',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter une nouvelle publication
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: label == 'Tous',
        onSelected: (bool selected) {
          // Filtrer les publications
        },
      ),
    );
  }

  Widget _buildPost(
    String author,
    String timeAgo,
    String avatarUrl,
    String title,
    String content,
    String imageUrl,
    int likes,
    int comments,
    String category,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de la publication
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/1.jpg',
              ),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: _getCategoryColor(category),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Contenu de la publication
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(content),
        const SizedBox(height: 10),
        // Image de la publication
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            'https://images.unsplash.com/photo-1506157786151-b8491531f063?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        // Actions de la publication
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: _buildActionButton(Icons.thumb_up_outlined, '$likes J\'aime'),
            ),
            Flexible(
              child: _buildActionButton(Icons.chat_bubble_outline, '$comments Commentaires'),
            ),
            Flexible(
              child: _buildActionButton(Icons.share, 'Partager'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(
        label, 
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'électro':
        return Colors.purple;
      case 'rock':
        return Colors.red;
      case 'hip-hop':
        return Colors.blue;
      case 'jazz':
        return Colors.orange;
      case 'reggae':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
