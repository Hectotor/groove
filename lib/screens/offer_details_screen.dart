import 'package:flutter/material.dart';

class SelectionState {
  Map<String, int> selectedTickets = {};
  Map<String, int> selectedFlights = {};
  Map<String, int> selectedAccommodations = {};
  Map<String, int> selectedExtras = {};

  double getTotal() {
    double total = 0.0;
    
    // Ajouter le prix des billets sélectionnés
    selectedTickets.forEach((ticket, quantity) {
      if (quantity > 0) {
        total += _getPriceForTicket(ticket) * quantity;
      }
    });
    
    // Ajouter le prix des vols sélectionnés
    selectedFlights.forEach((flight, quantity) {
      if (quantity > 0) {
        total += _getPriceForFlight(flight) * quantity;
      }
    });
    
    // Ajouter le prix des hébergements sélectionnés
    selectedAccommodations.forEach((accommodation, quantity) {
      if (quantity > 0) {
        total += _getPriceForAccommodation(accommodation) * quantity;
      }
    });
    
    // Ajouter le prix des extras sélectionnés
    selectedExtras.forEach((extra, quantity) {
      if (quantity > 0) {
        total += _getPriceForExtra(extra) * quantity;
      }
    });
    
    return total;
  }

  double _getPriceForTicket(String ticket) {
    switch (ticket) {
      case 'Pass 3 Jais VIP':
        return 499.0;
      case 'Pass 3 Jais Standard':
        return 299.0;
      case 'Pass 1 Jour':
        return 129.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForFlight(String flight) {
    switch (flight) {
      case 'Air France':
        return 189.0;
      case 'EasyJet':
        return 129.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForAccommodation(String accommodation) {
    switch (accommodation) {
      case 'Hôtel Festival Plaza':
        return 450.0;
      case 'Auberge de Jeunesse Central':
        return 120.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForExtra(String extra) {
    switch (extra) {
      case 'Transfert Aéroport':
        return 25.0;
      case 'Dîner Gourmet':
        return 75.0;
      case 'Pack Éco-Responsable':
        return 35.0;
      default:
        return 0.0;
    }
  }
}

class OfferDetailsScreen extends StatefulWidget {
  final String festivalName;
  final String festivalLocation;
  final String festivalDate;

  const OfferDetailsScreen({
    super.key,
    required this.festivalName,
    required this.festivalLocation,
    required this.festivalDate,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final _selection = SelectionState();
  
  @override
  void initState() {
    super.initState();
    // Initialisation des sélections avec des entiers (0 = non sélectionné)
    _selection.selectedTickets['Pass 3 Jais VIP'] = 0;
    _selection.selectedTickets['Pass 3 Jais Standard'] = 0;
    _selection.selectedTickets['Pass 1 Jour'] = 0;
    
    _selection.selectedFlights['Air France'] = 0;
    _selection.selectedFlights['EasyJet'] = 0;
    
    _selection.selectedAccommodations['Hôtel Festival Plaza'] = 0;
    _selection.selectedAccommodations['Auberge de Jeunesse Central'] = 0;
    
    _selection.selectedExtras['Transfert Aéroport'] = 0;
    _selection.selectedExtras['Dîner Gourmet'] = 0;
    _selection.selectedExtras['Pack Éco-Responsable'] = 0;
  }

  // Méthode utilitaire pour construire une ligne d'information
  Widget _buildInfoRow(BuildContext context, String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.festivalName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec les infos du festival
            _buildFestivalHeader(),
            const SizedBox(height: 24),
            
            // Section Billets
            _buildSectionTitle(context, '🎟️ Billets Festival'),
            _buildTicketSection(context),
            
            // Section Vols
            _buildSectionTitle(context, '✈️ Vols'),
            _buildFlightSection(context),
            
            // Section Hébergement
            _buildSectionTitle(context, '🏨 Hébergement'),
            _buildAccommodationSection(context),
            
            // Section Extras
            _buildSectionTitle(context, '🚐 Extras'),
            _buildExtrasSection(context),
            
            // Résumé des prix
            _buildPriceSummary(context),
            
            const SizedBox(height: 20),
            // Bouton de réservation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implémenter la logique de réservation
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Réserver maintenant',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.festivalName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.festivalLocation} • ${widget.festivalDate}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTicketSection(BuildContext context) {
    return Column(
      children: [
        _buildTicketOption(context, 
          'Pass 3 Jais VIP',
          'Accès illimité aux zones VIP, toilettes privées, recharge de téléphone, cadeau de bienvenue',
          '499€',
          true,
        ),
        const SizedBox(height: 12),
        _buildTicketOption(context, 
          'Pass 3 Jais Standard',
          'Accès général aux concerts et installations',
          '299€',
          false,
        ),
        const SizedBox(height: 12),
        _buildTicketOption(context, 
          'Pass 1 Jour',
          'Accès pour une journée au choix',
          '129€',
          false,
        ),
      ],
    );
  }

  Widget _buildTicketOption(BuildContext context, String title, String description, String price, bool isPopular) {
    final quantity = _selection.selectedTickets[title] ?? 0;
    final isSelected = quantity > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : (isPopular ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : (isPopular ? Theme.of(context).primaryColor : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Populaire',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),
                    onPressed: quantity > 0 ? () {
                      setState(() {
                        if (quantity > 0) {
                          _selection.selectedTickets[title] = quantity - 1;
                        }
                      });
                    } : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _selection.selectedTickets[title] = (quantity ?? 0) + 1;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightOption(BuildContext context, String company, String route, String schedule, String baggage, String price, bool isRecommended) {
    final quantity = _selection.selectedFlights[company] ?? 0;
    final isSelected = quantity > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : (isRecommended ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : (isRecommended ? Theme.of(context).primaryColor : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Recommandé',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            schedule,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            baggage,
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),
                    onPressed: quantity > 0 ? () {
                      setState(() {
                        _selection.selectedFlights[company] = quantity - 1;
                      });
                    } : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _selection.selectedFlights[company] = (quantity) + 1;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightSection(BuildContext context) {
    return Column(
      children: [
        _buildFlightOption(context, 
          'Air France',
          'Paris (CDG) → ${widget.festivalLocation}',
          '10:30 - 12:45 (2h15)',
          'Inclus: 1 bagage cabine + 1 bagage soute (23kg)',
          '189€',
          true,
        ),
        const SizedBox(height: 12),
        _buildFlightOption(context, 
          'EasyJet',
          'Paris (ORY) → ${widget.festivalLocation}',
          '06:15 - 08:20 (2h05)',
          'Inclus: 1 bagage cabine (sous le siège)',
          '129€',
          false,
        ),
      ],
    );
  }

  Widget _buildAccommodationSection(BuildContext context) {
    return Column(
      children: [
        _buildAccommodationOption(context, 
          'Hôtel Festival Plaza',
          '★★★★',
          'À 500m du site du festival',
          'Chambre double standard avec petit-déjeuner buffet inclus',
          '3 nuits • 2 personnes',
          '450€',
          true,
        ),
        const SizedBox(height: 12),
        _buildAccommodationOption(context, 
          'Auberge de Jeunesse Central',
          '★★',
          'À 1,2km du site du festival',
          'Lit en dortoir mixte (6 lits) avec petit-déjeuner',
          '3 nuits • 1 personne',
          '120€',
          false,
        ),
      ],
    );
  }

  Widget _buildAccommodationOption(BuildContext context, String name, String stars, String distance, String description, String details, String price, bool isPopular) {
    final quantity = _selection.selectedAccommodations[name] ?? 0;
    final isSelected = quantity > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : (isPopular ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : (isPopular ? Theme.of(context).primaryColor : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stars,
                style: const TextStyle(color: Colors.amber),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, '📍', distance),
          _buildInfoRow(context, '🏨', description),
          _buildInfoRow(context, 'ℹ️', details),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'À partir de',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'par personne',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(isSelected ? 'Sélectionné' : 'Voir disponibilités'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasSection(BuildContext context) {
    return Column(
      children: [
        _buildExtraOption(context, 
          '🚐 Transfert Aéroport',
          'Navette partagée entre l\'aéroport et votre hébergement',
          '25€',
          Icons.directions_bus,
        ),
        const SizedBox(height: 12),
        _buildExtraOption(context, 
          '🍽️ Dîner Gourmet',
          'Dîner gastronomique avec vue sur la scène principale',
          '75€',
          Icons.restaurant,
        ),
        const SizedBox(height: 12),
        _buildExtraOption(context, 
          '🎒 Pack Éco-Responsable',
          'Gourde réutilisable, sac à dos solaire et guide du festival durable',
          '35€',
          Icons.eco,
        ),
      ],
    );
  }

  Widget _buildExtraOption(BuildContext context, String title, String description, String price, IconData icon) {
    final quantity = _selection.selectedExtras[title] ?? 0;
    final isSelected = quantity > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),
                    onPressed: quantity > 0 ? () {
                      setState(() {
                        _selection.selectedExtras[title] = quantity - 1;
                      });
                    } : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _selection.selectedExtras[title] = quantity + 1;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context) {
    final total = _selection.getTotal();
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Afficher les billets sélectionnés
          ..._selection.selectedTickets.entries
              .where((entry) => entry.value > 0)
              .map((entry) => _buildPriceItem(
                '${entry.key} x${entry.value}', 
                '${_getPriceForTicket(entry.key).toStringAsFixed(2)} €'
              ))
              .toList(),
              
          // Afficher les vols sélectionnés
          ..._selection.selectedFlights.entries
              .where((entry) => entry.value > 0)
              .map((entry) => _buildPriceItem(
                'Vol ${entry.key} x${entry.value}', 
                '${_getPriceForFlight(entry.key).toStringAsFixed(2)} €'
              ))
              .toList(),
              
          // Afficher les hébergements sélectionnés
          ..._selection.selectedAccommodations.entries
              .where((entry) => entry.value > 0)
              .map((entry) => _buildPriceItem(
                '${entry.key} x${entry.value}', 
                '${_getPriceForAccommodation(entry.key).toStringAsFixed(2)} €'
              ))
              .toList(),
              
          // Afficher les extras sélectionnés
          ..._selection.selectedExtras.entries
              .where((entry) => entry.value > 0)
              .map((entry) => _buildPriceItem(
                '${entry.key} x${entry.value}', 
                '${_getPriceForExtra(entry.key).toStringAsFixed(2)} €', 
                isOptional: true
              ))
              .toList(),
              
          if (_selection.selectedTickets.entries.any((e) => e.value > 0) ||
              _selection.selectedFlights.entries.any((e) => e.value > 0) ||
              _selection.selectedAccommodations.entries.any((e) => e.value > 0) ||
              _selection.selectedExtras.entries.any((e) => e.value > 0))
            const Divider(height: 24),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total TTC :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getPriceForTicket(String ticket) {
    switch (ticket) {
      case 'Pass 3 Jais VIP':
        return 499.0;
      case 'Pass 3 Jais Standard':
        return 299.0;
      case 'Pass 1 Jour':
        return 129.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForFlight(String flight) {
    switch (flight) {
      case 'Air France':
        return 189.0;
      case 'EasyJet':
        return 129.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForAccommodation(String accommodation) {
    switch (accommodation) {
      case 'Hôtel Festival Plaza':
        return 450.0;
      case 'Auberge de Jeunesse Central':
        return 120.0;
      default:
        return 0.0;
    }
  }

  double _getPriceForExtra(String extra) {
    switch (extra) {
      case 'Transfert Aéroport':
        return 25.0;
      case 'Dîner Gourmet':
        return 75.0;
      case 'Pack Éco-Responsable':
        return 35.0;
      default:
        return 0.0;
    }
  }

  Widget _buildPriceItem(String label, String value, {bool isOptional = false, bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isOptional) const Text('+ ', style: TextStyle(color: Colors.green)),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? Colors.green : null,
                ),
              ),
            ],
          ),
          Text(
            isDiscount ? '-$value' : value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
