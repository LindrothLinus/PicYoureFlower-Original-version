import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import '../resources/constants.dart';

class FlowerInfoScreen extends StatelessWidget {
  final dynamic flowerItem; // Tar emot blomman som klickades på

  const FlowerInfoScreen({super.key, required this.flowerItem});

  @override
  Widget build(BuildContext context) {
    // Definierar färgerna utifrån bilden om de inte redan finns i dina constants
    final lightBlueBg = const Color(0xffbce3fc);
    final lightPinkBg = const Color(0xfffcd3e4);
    final infoPurple = const Color(0xffd5bbf7);
    
    // Generell stil för ramarna i appen
    final blackBorder = Border.all(color: Colors.black, width: 1.5);
    final standardRadius = BorderRadius.circular(12);

    return Scaffold(
      backgroundColor: lightBlueBg, // Matchar bildens bakgrund
      body: SafeArea(
        child: Column(
          children: [
            // 1. ÖVERSTA RADEN: Bakåtknapp + Titel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CustomBackButton(toHome: false),
                  const SizedBox(width: 12),
                  Text(
                    flowerItem.name, // T.ex. "Dandelion"
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w300, // Lite smalare/clean typsnitt
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // 2. MITTENSEKTIONEN: Bild + Info-rutor till höger
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // VÄNSTER: Blomman i en vit box med ram
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: standardRadius,
                            border: blackBorder,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                flowerItem.backGround,
                                color: flowerItem.color,
                                fit: BoxFit.contain,
                              ),
                              Image.asset(
                                flowerItem.frontImage,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // HÖGER: De tre info-rutorna staplade
                        Expanded(
                          child: SizedBox(
                            height: 140, // Samma höjd som bildboxen för symmetri
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Info 1: Datum
                                _buildInfoRow("26-05-05", Icons.calendar_month, infoPurple, blackBorder, standardRadius), // Byt ut Icons till Image.asset vid behov
                                // Info 2: Släkte
                                _buildInfoRow("Taraxacum", Icons.local_florist_outlined, infoPurple, blackBorder, standardRadius),
                                // Info 3: Plats
                                _buildInfoRow("Järvafältet", Icons.location_on_outlined, infoPurple, blackBorder, standardRadius),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 3. BESKRIVNINGSTEXT (Fritt liggande på den blå bakgrunden)
                    const Text(
                      "Taraxacums a genus of flowering plants in the family Asteraceae, which consists of species commonly known as dandelions. The scientific and hobby study of the genus is known as taraxacology.",
                      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.3),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The genus has a near-cosmopolitan distribution, absent only from tropical and polar areas. Two of the most common species worldwide, T. officinale (the common dandelion) and T.",
                      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),

            // 4. BOTTENMENY (Rosa fält med ikoner)
            Container(
              color: lightPinkBg,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Här kan du byta ut Icon-widgetarna mot dina egna: Image.asset('assets/din_fil.png', height: 40)
                  _buildBottomIcon(Icons.shopping_cart_outlined),
                  _buildBottomIcon(Icons.hardware_outlined), // T.ex. spade
                  _buildBottomIcon(Icons.camera_alt_outlined),
                  _buildBottomIcon(Icons.yard_outlined), // T.ex. blomma
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper-metod för att bygga de tre info-rutorna till höger om bilden
  Widget _buildInfoRow(String text, IconData icon, Color badgeColor, BoxBorder border, BorderRadius radius) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: border,
      ),
      child: Row(
        children: [
          // Lila ikon-box till vänster
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.only(topLeft: radius.topLeft, bottomLeft: radius.bottomLeft),
              border: Border(right: border.top), // Streck mellan ikon och text
            ),
            child: Icon(icon, size: 20, color: Colors.black87), // Byt till Image.asset om du har egna png-ikoner
          ),
          // Text-box till höger
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper-metod för ikonerna i bottenmenyn
  Widget _buildBottomIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 36, color: Colors.black87),
      onPressed: () {
        // Lägg till logik för knapptryck här sen
      },
    );
  }
}