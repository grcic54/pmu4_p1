import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/quake.dart';
import 'magnitude_badge.dart';

class QuakeTile extends StatelessWidget {
  final Quake quake;
  final bool pinned;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  const QuakeTile({
    super.key,
    required this.quake,
    required this.pinned,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed
  });


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(quake.id),
      direction: DismissDirection.endToStart, 
      background: Container(color: Colors.red, 
      alignment: Alignment.centerRight,padding: EdgeInsets.all(24), 
      child: Icon(Icons.delete,color: Colors.white)), child: ListTile(
      leading: Hero(
        tag: 'maginitude-${quake.id}',
        child: MagnitudeBadge(magnitude: quake.magnitude),
      ),
      title: Text(quake.place),
      subtitle: Text(quake.timeLabel),
      trailing: AnimatedScale(
        scale: pinned ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: const Icon(Icons.push_pin),
      ),  
      onTap: onTap,
      onLongPress: onLongPress,
    ));
    
  }
}