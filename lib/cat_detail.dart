import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class CatDetailScreen extends StatelessWidget {
  final Map cat;

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat['name'] ?? 'Unknown'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cat['reference_image_id'] != null)
              Center(
                child: Image.network(
                  'https://cdn2.thecatapi.com/images/${cat['reference_image_id']}.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${cat['name'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            _buildAnimatedDetail('Origin', cat['origin']),
            _buildAnimatedDetail('Temperament', cat['temperament']),
            _buildAnimatedDetail('Description', cat['description']),
            _buildAnimatedDetail('Life Span', '${cat['life_span'] ?? 'Unknown'} years'),
            _buildAnimatedDetail('Weight', '${cat['weight']['metric'] ?? 'Unknown'} kg'),
            const SizedBox(height: 16),
            _buildRatingRow('Affection Level', cat['affection_level']),
            _buildRatingRow('Child Friendly', cat['child_friendly']),
            _buildRatingRow('Dog Friendly', cat['dog_friendly']),
            _buildRatingRow('Energy Level', cat['energy_level']),
            const SizedBox(height: 16),
            const Text(
              'More Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            _buildLink('CFA URL', cat['cfa_url']),
            _buildLink('Vetstreet URL', cat['vetstreet_url']),
            _buildLink('VCA Hospitals URL', cat['vcahospitals_url']),
            _buildLink('Wikipedia', cat['wikipedia_url']),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDetail(String title, String? detail) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (context, action) => ListTile(
        title: Text(
          '$title: ${detail ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
        onTap: action,
      ),
      openBuilder: (context, action) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              detail ?? 'No information available',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(String title, int? rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontSize: 18, color: Colors.purple)),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < (rating ?? 0) ? Icons.star : Icons.star_border,
                color: Colors.orange,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(String title, String? url) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Text(
          '$title: $url',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  canLaunch(String url) {}
  launch(String url) {}
}
