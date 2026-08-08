import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/infographic_card.dart';
import '../models/infographic.dart';
import 'viewer_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Infographic> _results = [];

  void _onSearch(String query) {
    setState(() {
      _results = Provider.of<AppProvider>(context, listen: false).searchInfographics(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search infographics...",
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
      ),
      body: _controller.text.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Type to search title or category", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : _results.isEmpty
              ? const Center(child: Text("No results found."))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final infographic = _results[index];
                    return InfographicCard(
                      infographic: infographic,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewerScreen(infographic: infographic),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
