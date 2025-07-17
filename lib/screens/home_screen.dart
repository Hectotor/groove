import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fonction pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('fr', 'FR'), // Pour avoir le calendrier en français
    );
    
    if (picked != null) {
      // Ici vous pouvez ajouter la logique pour filtrer les festivals par date
      // Par exemple : _filterFestivalsByDate(picked);
      print('Date sélectionnée: ${picked.toString()}');
    }
  }

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

  Widget _buildFestivalCard(String name, String location, String date, String price, String genre, String imageUrl, BuildContext context) {
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
                    // Genre musical
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.music_note, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            genre,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                // Barre de recherche
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Rechercher un festival...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (value) {
                              // La recherche sera implémentée plus tard
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Bouton calendrier
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ],
            ),
          ),
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
            '18-27 Juillet 2025',
            'À partir de 310€',
            'Électronique',
            'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Coachella',
            'Indio, Californie',
            '11-20 Avril 2025',
            'À partir de 499€',
            'Pop/Rock/Électronique',
            'https://images.unsplash.com/photo-1507878866276-a947ef722fee?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Glastonbury',
            'Somerset, Royaume-Uni',
            '25-29 Juin 2025',
            'À partir de 280€',
            'Rock/Alternative',
            'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Ultra Music Festival',
            'Miami, États-Unis',
            '28-30 Mars 2025',
            'À partir de 399€',
            'EDM/Électronique',
            'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Rock en Seine',
            'Paris, France',
            '22-24 Août 2025',
            'À partir de 159€',
            'Rock/Indie',
            'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Primavera Sound',
            'Barcelone, Espagne',
            '4-8 Juin 2025',
            'À partir de 225€',
            'Indie/Alternative',
            'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Sziget Festival',
            'Budapest, Hongrie',
            '10-15 Août 2025',
            'À partir de 199€',
            'Multi-genres',
            'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Lollapalooza',
            'Chicago, États-Unis',
            '31 Juillet - 3 Août 2025',
            'À partir de 350€',
            'Rock/Hip-Hop/Électronique',
            'https://images.unsplash.com/photo-1522158637959-30385a09e0da?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Hellfest',
            'Clisson, France',
            '19-22 Juin 2025',
            'À partir de 269€',
            'Metal/Hard Rock',
            'https://images.unsplash.com/photo-1559519529-0936e4058364?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Burning Man',
            'Black Rock City, Nevada',
            '25 Août - 1 Sept 2025',
            'À partir de 575€',
            'Art/Expérimental',
            'https://images.unsplash.com/photo-1535463731090-e34f4b5098c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Fuji Rock',
            'Yuzawa, Japon',
            '25-27 Juillet 2025',
            'À partir de 420€',
            'Rock/Alternative',
            'https://images.unsplash.com/photo-1529981188441-8a2e6fe30103?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Montreux Jazz Festival',
            'Montreux, Suisse',
            '4-19 Juillet 2025',
            'À partir de 150€',
            'Jazz/Blues',
            'https://images.unsplash.com/photo-1511192336575-5a79af67a629?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Roskilde Festival',
            'Roskilde, Danemark',
            '28 Juin - 5 Juillet 2025',
            'À partir de 280€',
            'Rock/Pop/Électronique',
            'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Sónar',
            'Barcelone, Espagne',
            '18-20 Juin 2025',
            'À partir de 195€',
            'Électronique/Expérimental',
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Exit Festival',
            'Novi Sad, Serbie',
            '9-12 Juillet 2025',
            'À partir de 145€',
            'Électronique/Rock',
            'https://images.unsplash.com/photo-1493676304819-0d7a8d026dcf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Splendour in the Grass',
            'Byron Bay, Australie',
            '24-26 Juillet 2025',
            'À partir de 320€',
            'Indie/Alternative',
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Afro Nation',
            'Portimão, Portugal',
            '1-3 Juillet 2025',
            'À partir de 249€',
            'Afrobeats/Dancehall',
            'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
          _buildFestivalCard(
            'Dour Festival',
            'Dour, Belgique',
            '14-18 Juillet 2025',
            'À partir de 185€',
            'Électronique/Hip-Hop',
            'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
            context,
          ),
        ],
      ),
    );
  }
}
