// File: lib/screens/custom_pack_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPackEditorScreen extends StatefulWidget {
  const CustomPackEditorScreen({super.key});

  @override
  State<CustomPackEditorScreen> createState() => _CustomPackEditorScreenState();
}

class _CustomPackEditorScreenState extends State<CustomPackEditorScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> _customWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersistedWords();
  }

  // Load words from phone storage
  Future<void> _loadPersistedWords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _customWords = prefs.getStringList('custom_pack_words') ?? [];
      _isLoading = false;
    });
  }

  // Save words to phone storage
  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_pack_words', _customWords);
  }

  void _addWord(String word) {
    final cleanWord = word.trim();
    if (cleanWord.isNotEmpty && !_customWords.contains(cleanWord)) {
      setState(() {
        _customWords.add(cleanWord);
      });
      _saveWords(); // Persist change
      _textController.clear();
      HapticFeedback.lightImpact();
    }
  }

  void _removeWord(String word) {
    setState(() {
      _customWords.remove(word);
    });
    _saveWords(); // Persist change
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT CUSTOM PACK', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: _customWords.map((word) {
                        return Container(
                          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(word, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _removeWord(word),
                                borderRadius: BorderRadius.circular(12),
                                child: Icon(Icons.close, size: 20, color: theme.colorScheme.primary),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 16),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.words,
                        onSubmitted: _addWord,
                        decoration: InputDecoration(
                          hintText: 'Type word & press Enter...',
                          hintStyle: const TextStyle(color: Colors.white30),
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _addWord(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}