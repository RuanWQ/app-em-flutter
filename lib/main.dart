import 'package:flutter/material.dart';

void main() => runApp(const WordApp());

const _pink = Color(0xFFF8DCD6);
const _red = Color(0xFFB92705);
const _ink = Color(0xFF3B3433);

class WordApp extends StatefulWidget {
  const WordApp({super.key});

  @override
  State<WordApp> createState() => _WordAppState();
}

class _WordAppState extends State<WordApp> {
  final List<String> _words = const [
    'newstay',
    'sunshine',
    'journey',
    'kindness',
    'daydream',
  ];
  final Set<String> _favorites = {};
  int _wordIndex = 0;
  bool _showFavorites = false;

  String get _word => _words[_wordIndex];

  void _nextWord() => setState(() => _wordIndex = (_wordIndex + 1) % _words.length);

  void _toggleFavorite([String? word]) {
    setState(() {
      final selected = word ?? _word;
      if (!_favorites.add(selected)) _favorites.remove(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namer3',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _red),
        scaffoldBackgroundColor: _pink,
        fontFamily: 'Arial',
      ),
      home: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              _SideNavigation(
                showFavorites: _showFavorites,
                onSelect: (favorites) => setState(() => _showFavorites = favorites),
              ),
              Expanded(
                child: _showFavorites ? _buildFavorites() : _buildHome(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHome() => LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth * .57).clamp(230.0, 430.0).toDouble();
          final cardHeight = (constraints.maxHeight * .29).clamp(100.0, 160.0).toDouble();
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _red,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 3, offset: Offset(0, 2)),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(_word, style: const TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
                const SizedBox(height: 19),
                Wrap(
                  spacing: 13,
                  children: [
                    _ActionButton(
                      icon: _favorites.contains(_word) ? Icons.favorite : Icons.favorite_border,
                      label: 'Like',
                      selected: _favorites.contains(_word),
                      onPressed: _toggleFavorite,
                    ),
                    _ActionButton(label: 'Next', onPressed: _nextWord),
                  ],
                ),
              ],
            ),
          );
        },
      );

  Widget _buildFavorites() {
    if (_favorites.isEmpty) return const SizedBox.expand();
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520, maxHeight: constraints.maxHeight),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: _favorites.map((word) => Card(
              color: const Color(0xFFFFF8F6),
              elevation: 1,
              child: ListTile(
                title: Text(word, style: const TextStyle(fontSize: 24, color: _ink)),
                trailing: IconButton(
                  tooltip: 'Remover dos favoritos',
                  onPressed: () => _toggleFavorite(word),
                  icon: const Icon(Icons.favorite, color: _red),
                ),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({required this.showFavorites, required this.onSelect});

  final bool showFavorites;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) => Container(
        width: 106,
        color: const Color(0xFFFAF8F8),
        child: Column(
          children: [
            const SizedBox(height: 9),
            _NavButton(icon: Icons.home, selected: !showFavorites, tooltip: 'Início', onTap: () => onSelect(false)),
            _NavButton(icon: Icons.favorite, selected: showFavorites, tooltip: 'Favoritos', onTap: () => onSelect(true)),
          ],
        ),
      );
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.selected, required this.tooltip, required this.onTap});

  final IconData icon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Tooltip(
            message: tooltip,
            child: Material(
              color: selected ? _pink : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 74,
                  height: 42,
                  child: Icon(icon, color: _ink, size: 28),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({this.icon, required this.label, required this.onPressed, this.selected = false});

  final IconData? icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFFF5F1F0),
        borderRadius: BorderRadius.circular(24),
        elevation: 1,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: icon == null ? 22 : 16, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: _red, size: 28),
                  const SizedBox(width: 11),
                ],
                Text(label, style: const TextStyle(color: _red, fontSize: 16)),
              ],
            ),
          ),
        ),
      );
}
