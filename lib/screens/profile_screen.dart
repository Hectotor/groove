import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Mon Profil Festivalier'),
              background: Image.network(
                'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  // Naviguer vers les paramètres
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Photo de profil et informations
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/women/44.jpg',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lola',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Paris, France',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Statistiques
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('7', 'Festivals'),
                        _buildStatColumn('3', 'À venir'),
                        _buildStatColumn('24', 'Artistes vus'),
                        _buildStatColumn('4.9', 'Note'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Section Mes Festivals
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      'MES FESTIVALS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.festival,
                    title: 'Mes voyages à venir',
                    onTap: () {},
                    context: context,
                  ),
                  _buildSettingItem(
                    icon: Icons.history,
                    title: 'Mes voyages passés',
                    onTap: () {},
                    context: context,
                  ),
                  _buildSettingItem(
                    icon: Icons.favorite_border,
                    title: 'Mes voyages favoris',
                    onTap: () {},
                    context: context,
                  ),
                  const Divider(),
                  
                  // Section Compte
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      'MON COMPTE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Profil public',
                    onTap: () {},
                    context: context,
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {},
                    context: context,
                  ),
                  _buildSettingItem(
                    icon: Icons.payment,
                    title: 'Moyens de paiement',
                    onTap: () {},
                    context: context,
                  ),
                  _buildSettingItemWithImage(
                    imagePath: 'assets/whatsapp.png',
                    title: 'Nous contacter',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WhatsAppContactScreen(),
                        ),
                      );
                    },
                    context: context,
                  ),
                  _buildSettingItem(
                    icon: Icons.language,
                    title: 'Changer de langue',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Changer de langue'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Text('🇫🇷'),
                                  title: const Text('Français'),
                                  trailing: const Icon(Icons.check, color: Colors.blue),
                                  onTap: () {
                                    // TODO: Implémenter le changement de langue vers le français
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Text('🇬🇧'),
                                  title: const Text('English'),
                                  trailing: null,
                                  onTap: () {
                                    // TODO: Implémenter le changement de langue vers l'anglais
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ANNULER'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    context: context,
                  ),
                  
                  // Section Suivez-nous
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
                    child: Text(
                      'SUIVEZ-NOUS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSocialIcon('assets/Facebook.png', () {
                          // Lien vers Facebook
                        }),
                        _buildSocialIcon('assets/Instagram.png', () {
                          // Lien vers Instagram
                        }),
                        _buildSocialIcon('assets/tiktok.jpg', () {
                          // Lien vers TikTok
                        }),
                        _buildSocialIcon('assets/LinkedIn.png', () {
                          // Lien vers LinkedIn
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bouton de déconnexion
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Déconnexion
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Déconnexion'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSettingItemWithImage({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(imagePath),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class WhatsAppContactScreen extends StatefulWidget {
  const WhatsAppContactScreen({super.key});

  @override
  State<WhatsAppContactScreen> createState() => _WhatsAppContactScreenState();
}

class _WhatsAppContactScreenState extends State<WhatsAppContactScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://wa.me/33617038890'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/whatsapp.png', width: 24, height: 24),
            const SizedBox(width: 10),
            const Text('Nous contacter'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              controller.loadRequest(Uri.parse('https://www.whatsapp.com'));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
