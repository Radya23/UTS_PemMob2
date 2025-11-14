import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const ListInfoPage(), const AboutPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ListInfoPage extends StatefulWidget {
  const ListInfoPage({super.key});

  @override
  State<ListInfoPage> createState() => _ListInfoPageState();
}

class _ListInfoPageState extends State<ListInfoPage> {
  final List<String> topics = [
    'Konsep Flutter Widget',
    'Apa itu State Management di Flutter?',
    'Penjelasan Model-View-Controller (MVC)',
    'Keunggulan Pemrograman Mobile Lintas Platform',
  ];

  Future<String> generateContent(String topic) async {
    try {
      final prompt =
          'Jelaskan konsep "$topic" dalam 3 paragraf singkat dan mudah dipahami. Jangan gunakan Markdown.';
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Gagal mendapatkan data dari Gemini.';
    } catch (e) {
      return 'Error: Pastikan API Key benar dan koneksi internet tersedia. Detail: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Topik (Didukung Gemini)')),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(topics[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailInfoPage(
                    title: topics[index],
                    contentFuture: generateContent(topics[index]),
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

class DetailInfoPage extends StatelessWidget {
  final String title;
  final Future<String> contentFuture;

  const DetailInfoPage({
    super.key,
    required this.title,
    required this.contentFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: contentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  'Terjadi error: ${snapshot.error ?? "Data tidak ditemukan"}',
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Text(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Aplikasi')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 80, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text(
                'Aplikasi Mobile UTS',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Dibuat untuk memenuhi Tugas Ujian Tengah Semester mata kuliah Pemrograman Mobile 2.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 50),
              Text(
                'Copyright © 2025 by Radya Anantia DIvena_23552011415',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
