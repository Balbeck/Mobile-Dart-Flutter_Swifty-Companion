import 'package:flutter/material.dart';

class TopSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final bool isUserFound;
  final String errorText;

  const TopSearchBar({
    super.key,
    required this.onSearch,
    this.isUserFound = true,
    this.errorText = 'User not found',
  });

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: widget.isUserFound ? 'Search 42 Users' : widget.errorText,
          labelStyle: TextStyle(
            color: widget.isUserFound ? Colors.grey : Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          prefixIcon: const Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: widget.isUserFound ? Colors.blueAccent : Colors.red,
            ),
          ),
        ),
        onSubmitted: (querry) {
          if (querry.isNotEmpty) {
            widget.onSearch(querry);
            _searchController.clear();
          }
        },
      ),
    );
  }
}
