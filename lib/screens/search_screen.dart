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
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Search title or category...",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            onChanged: _onSearch,
          ),
        ),
      ),
      body: _controller.text.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("Type to start searching", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
          : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sentiment_dissatisfied_rounded, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text("No results found for \"${_controller.text}\"", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
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
