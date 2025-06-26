import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

enum MediaType {
  image(mimeTypes: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp']),
  video(
    mimeTypes: [
      'mp4',
      'webm',
      'x-matroska',
      'x-msvideo',
      'flv',
      'mkv',
      'avi',
      'mov',
      'quicktime',
      'ogg',
      '3gpp',
      '3gp',
      'ogv',
      'mpeg',
      'mpg',
    ],
  ),
  audio(mimeTypes: ['flac', 'ogg', 'wav', 'mp3', 'mid', 'wma', 'aac', 'x-wav']),
  pdf(mimeTypes: ['pdf', 'x-pdf', 'vnd.pdf']),
  file;

  final List<String> mimeTypes;

  const MediaType({this.mimeTypes = const []});

  int get maxSizeInMb => 100;

  static MediaType fromMimeType(String? mimeType) {
    for (final type in MediaType.values) {
      if (type.mimeTypes.contains(mimeType)) {
        return type;
      }
    }
    return file;
  }

  static MediaType fromFile(File file) {
    return fromMimeType(getFileExtension(file.path));
  }

  static String? getFileExtension(String? fileName) {
    if (fileName == null) return null;
    return fileName.split('.').last;
  }
}

class ChatAttachment {
  ChatAttachment({required this.url, this.id, this.name, this.mimetype, this.size});

  factory ChatAttachment.fromMap(Map<dynamic, dynamic> map) => ChatAttachment(
        url: map['url']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        mimetype: map['type']?.toString() ?? '',
        size: map['size'] is int ? map['size'] as int : null,
        id: map['id']?.toString() ?? '',
      );

  factory ChatAttachment.fromBackend(dynamic json, {required String? Function(String?) url}) {
    if (json is! Map) {
      debugPrint('ChatAttachment.fromBackend: Invalid JSON format');
      return ChatAttachment(url: '');
    }
    final fileInfo = json['fileInfo'] is Map ? json['fileInfo'] as Map : null;
    return ChatAttachment(
      id: json['id']?.toString(),
      name: fileInfo?['originalname']?.toString(),
      mimetype: fileInfo?['mimetype']?.toString(),
      size: (fileInfo?['size'] is int) ? (fileInfo?['size'] as int) : null,
      url: url.call(json['id']?.toString()) ?? '',
    );
  }
  String? id;
  String url;
  String? name;
  String? mimetype;
  int? size;

  bool get isLocal => (url.startsWith('file://') || !Uri.parse(url).hasScheme) && File(url).existsSync();

  /// Returns the file extension of the attachment
  String? get type {
    try {
      if (mimetype == null) return null;

      final type = mimetype!.contains('/') ? mimetype!.split('/').last : mimetype!;
      return type.contains('.') ? type.split('.').last : type;
    } catch (e) {
      debugPrint('Error getting mime type: $e');
      return null;
    }
  }

  String? get sizeStr => getFileSizeString(bytesVal: size);
  static String? getFileSizeString({required int? bytesVal, int decimals = 0}) {
    if (bytesVal == null) return null;
    const suffixes = ['bytes', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytesVal) / log(1024)).floor();
    return '${(bytesVal / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  MediaType get mediaType => MediaType.fromMimeType(type);

  Map<String, dynamic> toMap() => {'url': url, 'name': name, 'type': mimetype, 'size': size, 'id': id};
}
