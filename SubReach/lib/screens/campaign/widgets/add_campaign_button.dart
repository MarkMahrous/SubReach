import 'package:flutter/material.dart';

class AddCampaignButton extends StatefulWidget {
  const AddCampaignButton({super.key, required this.onPressed});

  final void Function(String body) onPressed;

  @override
  State<AddCampaignButton> createState() => _AddCampaignButtonState();
}

class _AddCampaignButtonState extends State<AddCampaignButton> {
  bool _isExpanded = false; // To track the expansion state of the menu

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isExpanded) ...[
          Positioned(
            bottom: 70,
            right: 16,
            child: _buildOptionButton(Icons.play_arrow, "View", Colors.red),
          ),
          Positioned(
            bottom: 60,
            right: 60,
            child: _buildOptionButton(Icons.thumb_up, "Like", Colors.red),
          ),
          Positioned(
            bottom: 16,
            right: 70,
            child: _buildOptionButton(Icons.group, "Subscribe", Colors.red),
          ),
        ],
        // Main FAB button
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            backgroundColor: Colors.red,
            child: Icon(
              _isExpanded ? Icons.close : Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(IconData icon, String tooltip, Color color) {
    return FloatingActionButton(
      heroTag: tooltip, // Ensures unique tag for each button
      onPressed: () {
        // Add functionality here for each option button
        widget.onPressed(tooltip);
        debugPrint('$tooltip button pressed');
      },
      tooltip: tooltip,
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
      ),
      mini: true, // Makes the button smaller
    );
  }
}
