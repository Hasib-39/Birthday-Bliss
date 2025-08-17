import 'package:flutter/material.dart';

class SettingsModel {
  final String recipientName;
  final String customMessage;
  final Color cakeColor;
  final String? musicUrl;

  SettingsModel({
    required this.recipientName,
    required this.customMessage,
    required this.cakeColor,
    this.musicUrl,
  });

  SettingsModel copyWith({
    String? recipientName,
    String? customMessage,
    Color? cakeColor,
    String? musicUrl,
  }) {
    return SettingsModel(
      recipientName: recipientName ?? this.recipientName,
      customMessage: customMessage ?? this.customMessage,
      cakeColor: cakeColor ?? this.cakeColor,
      musicUrl: musicUrl ?? this.musicUrl,
    );
  }
}
