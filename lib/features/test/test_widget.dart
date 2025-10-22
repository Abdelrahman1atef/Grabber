import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SameScreenHeroEffect(),
    );
  }
}

class SameScreenHeroEffect extends StatefulWidget {
  const SameScreenHeroEffect({super.key});

  @override
  State<SameScreenHeroEffect> createState() => _SameScreenHeroEffectState();
}

class _SameScreenHeroEffectState extends State<SameScreenHeroEffect> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Same Screen Hero Effect')),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: _isExpanded ? 0 : 50,
            top: _isExpanded ? 0 : 100,
            width: _isExpanded ? MediaQuery.of(context).size.width : 100,
            height: _isExpanded ? MediaQuery.of(context).size.height : 100,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: _isExpanded ? Colors.blueAccent : Colors.redAccent,
                borderRadius: BorderRadius.circular(_isExpanded ? 0 : 12),
              ),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Tap to Shrink' : 'Tap to Expand',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
