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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<String> _customWords = [];
  bool _isLoading = true;
  // Tracks which word index was most recently added for the wiggle animation
  int _newlyAddedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadPersistedWords();
  }

  Future<void> _loadPersistedWords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('custom_pack_words') ?? [];

    // Sanitize on load: trim whitespace, drop empty strings,
    // preserving special characters (ă, î, ș, ț, etc.) as-is
    final sanitized = raw
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    setState(() {
      _customWords = sanitized;
      _isLoading = false;
    });
  }

  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('custom_pack_words', _customWords);
  }

  void _addWord(String word) {
    final cleanWord = word.trim();
    if (cleanWord.isEmpty) return;

    // Case-insensitive duplicate check, preserves original casing
    final alreadyExists = _customWords.any(
      (w) => w.toLowerCase() == cleanWord.toLowerCase(),
    );
    if (alreadyExists) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"$cleanWord" is already in your pack.',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white12,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final insertIndex = 0; // New words appear at the top
    _customWords.insert(insertIndex, cleanWord);
    _listKey.currentState?.insertItem(insertIndex);

    setState(() => _newlyAddedIndex = insertIndex);

    // Reset the newly added marker after animation completes
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _newlyAddedIndex = -1);
    });

    _saveWords();
    _textController.clear();
    HapticFeedback.lightImpact();
  }

  void _removeWord(int index) {
    final removedWord = _customWords[index];
    _customWords.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildWordChip(removedWord, index, animation),
      duration: const Duration(milliseconds: 300),
    );

    _saveWords();
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
        title: const Text(
          'EDIT CUSTOM PACK',
          style: TextStyle(letterSpacing: 2),
        ),
        centerTitle: true,
        actions: [
          if (_customWords.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  '${_customWords.length} words',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _customWords.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.dashboard_customize_rounded,
                                size: 48,
                                color: theme.colorScheme.primary.withAlpha(80),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No words yet.',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Type a word below and press Enter.',
                                style: TextStyle(
                                  color: Colors.white24,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: AnimatedList(
                            key: _listKey,
                            initialItemCount: _customWords.length,
                            itemBuilder: (context, index, animation) {
                              return _buildWordChip(
                                _customWords[index],
                                index,
                                animation,
                                isNew: index == _newlyAddedIndex,
                              );
                            },
                          ),
                        ),
                ),
                _buildInputBar(theme),
              ],
            ),
    );
  }

  Widget _buildWordChip(
    String word,
    int index,
    Animation<double> animation, {
    bool isNew = false,
  }) {
    final theme = Theme.of(context);

    // Slide + fade for enter/exit
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

    Widget chip = FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withAlpha(50),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _removeWord(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Wiggle animation only for the newly added word
    if (isNew) {
      chip = _WiggleWrapper(child: chip);
    }

    return chip;
  }

  Widget _buildInputBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
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
                hintText: 'Type a word & press Enter...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
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
    );
  }
}

// Self-contained wiggle widget — plays once on build, no external controller needed
class _WiggleWrapper extends StatefulWidget {
  final Widget child;

  const _WiggleWrapper({required this.child});

  @override
  State<_WiggleWrapper> createState() => _WiggleWrapperState();
}

class _WiggleWrapperState extends State<_WiggleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _wiggle = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wiggle,
      builder: (context, child) => Transform.translate(
        offset: Offset(_wiggle.value, 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}