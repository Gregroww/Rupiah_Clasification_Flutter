import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //Data koin untuk ditampilkan(Article Section)
  final List<Map<String, dynamic>> coins = [
    {
      'name': 'Komodo Coin',
      'year': '1991 - 1998',
      // 'image': 'assets/komodo_coin.png',
      'value': 50,
    },
    {
      'name': '100 Rupiah Coin',
      'year': '1978',
      // 'image': 'assets/100_rupiah.png',
      'value': 100,
    },
    {
      'name': 'Komodo Coin',
      'year': '1991 - 1998',
      // 'image': 'assets/komodo_coin.png',
      'value': 50,
    },
    {
      'name': '100 Rupiah Coin',
      'year': '1978',
      // 'image': 'assets/100_rupiah.png',
      'value': 100,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              //Header gambar koin
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Scan Your Coin',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      //Dua koin di tengah
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //koin kiri
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.monetization_on,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          //koin kanan
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.monetization_on,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              //Section Article
              Expanded(
                flex: 6,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      //Header Article
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Article',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color(0xFF4ECDC4),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      //Grid koin
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: coins.length,
                          itemBuilder: (context, index) {
                            final coin = coins[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Gambar koin
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: coin['value'] == 50 
                                          ? Colors.amber.shade300 
                                          : Colors.grey.shade300,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Rp${coin['value']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: coin['value'] == 50
                                              ? Colors.brown.shade700
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  //Nama koin
                                  Text(
                                    coin['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  // Tahun
                                  Text(
                                    coin['year'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      //Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Home button
                IconButton(
                  onPressed: () => _onItemTapped(0),
                  icon: Icon(
                    Icons.home,
                    color: _selectedIndex == 0 
                        ? const Color(0xFF4ECDC4) 
                        : Colors.grey,
                    size: 30,
                  ),
                ),
                
                //QR Scanner button (tengah)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4ECDC4),
                      width: 3,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Color(0xFF4ECDC4),
                      size: 32,
                    ),
                  ),
                ),
                
                //Library button
                IconButton(
                  onPressed: () => _onItemTapped(2),
                  icon: Icon(
                    Icons.library_books,
                    color: _selectedIndex == 2 
                        ? const Color(0xFF4ECDC4) 
                        : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}