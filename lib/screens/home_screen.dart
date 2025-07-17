import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  Widget _buildCategory(String title, IconData icon, Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalCard(String name, String location, String date, String price, String imageUrl, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image d'arrière-plan
            Image.network(
              imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Dégradé pour améliorer la lisibilité du texte
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Contenu
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de prix
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nom du festival
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Informations de lieu et date
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bouton d'action
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Voir les offres',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groove Nomad'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bannière principale
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: const Center(
                child: Text(
                  'Votre prochain festival de musique vous attend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Catégories de festivals
          const Text(
            'Par genre musical',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategory('Électro', Icons.music_note, Colors.purple),
                _buildCategory('Rock', Icons.music_note, Colors.red),
                _buildCategory('Hip-Hop', Icons.music_note, Colors.blue),
                _buildCategory('Jazz', Icons.music_note, Colors.orange),
                _buildCategory('Reggae', Icons.music_note, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Prochains festivals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Prochains festivals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFestivalCard(
            'Tomorrowland',
            'Boom, Belgique',
            '18-20 Juillet 2025',
            'À partir de 299€',
            'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Coachella',
            'Indio, Californie',
            '11-13 Avril 2025',
            'À partir de 549€',
            'https://images.unsplash.com/photo-1506157786151-b8491531f063?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Glastonbury',
            'Pilton, Royaume-Uni',
            '25-29 Juin 2025',
            'À partir de 399€',
            'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Ultra Music Festival',
            'Miami, États-Unis',
            '28-30 Mars 2025',
            'À partir de 450€',
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Rock en Seine',
            'Paris, France',
            '22-24 Août 2025',
            'À partir de 179€',
            'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Primavera Sound',
            'Barcelone, Espagne',
            '4-8 Juin 2025',
            'À partir de 225€',
            'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Sziget Festival',
            'Budapest, Hongrie',
            '10-15 Août 2025',
            'À partir de 199€',
            'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Lollapalooza',
            'Chicago, États-Unis',
            '31 Juillet - 3 Août 2025',
            'À partir de 350€',
            'https://images.unsplash.com/photo-1522158637959-30385a09e0da?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Hellfest',
            'Clisson, France',
            '19-22 Juin 2025',
            'À partir de 269€',
            'https://images.unsplash.com/photo-1559519529-0936e4058364?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Burning Man',
            'Black Rock City, Nevada',
            '25 Août - 1 Sept 2025',
            'À partir de 575€',
            'https://images.unsplash.com/photo-1535463731090-e34f4b5098c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Fuji Rock',
            'Yuzawa, Japon',
            '25-27 Juillet 2025',
            'À partir de 420€',
            'https://images.unsplash.com/photo-1529981188441-8a2e6fe30103?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Montreux Jazz Festival',
            'Montreux, Suisse',
            '4-19 Juillet 2025',
            'À partir de 150€',
            'https://images.unsplash.com/photo-1511192336575-5a79af67a629?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Roskilde Festival',
            'Roskilde, Danemark',
            '28 Juin - 5 Juillet 2025',
            'À partir de 280€',
            'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Sónar',
            'Barcelone, Espagne',
            '18-20 Juin 2025',
            'À partir de 195€',
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Exit Festival',
            'Novi Sad, Serbie',
            '9-12 Juillet 2025',
            'À partir de 145€',
            'https://images.unsplash.com/photo-1493676304819-0d7a8d026dcf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Splendour in the Grass',
            'Byron Bay, Australie',
            '24-26 Juillet 2025',
            'À partir de 320€',
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Afro Nation',
            'Portimão, Portugal',
            '1-3 Juillet 2025',
            'À partir de 249€',
            'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Dour Festival',
            'Dour, Belgique',
            '14-18 Juillet 2025',
            'À partir de 185€',
            'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
        ],
      ),
    );
  }
}
