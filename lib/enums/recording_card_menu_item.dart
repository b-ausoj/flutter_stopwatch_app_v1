import 'package:flutter/material.dart';

enum RecordingCardMenuItem { 
  rename("Rename", Icons.edit_outlined), 
  export("Export", Icons.save_alt), 
  delete("Delete", Icons.delete_outline);
  final String label;
  final IconData icon;
  const RecordingCardMenuItem(this.label, this.icon);
  }
