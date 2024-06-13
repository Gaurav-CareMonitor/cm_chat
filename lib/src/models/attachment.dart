import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

enum MediaType {
  image(mimeTypes: ["png", "jpg", "jpeg", "gif", "bmp", "webp"]),
  video(mimeTypes: [
    "mp4",
    "webm",
    "x-matroska",
    "x-msvideo",
    "flv",
    "mkv",
    "avi",
    "mov",
    "quicktime",
    "ogg",
    "3gpp",
    "3gp",
    "ogv",
    "mpeg",
    "mpg"
  ]),
  audio(mimeTypes: ["flac", "ogg", "wav", "mp3", "mid", "wma", "aac"]),
  pdf(mimeTypes: ["pdf", "x-pdf", "vnd.pdf"]),
  file;

  final List<String> mimeTypes;

  const MediaType({this.mimeTypes = const []});

  int get maxSizeInMb => 100;

  static MediaType fromMimeType(String? mimeType) {
    for (MediaType type in MediaType.values) {
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
  final String? id;
  final String url;
  final String? name;
  final String? mimetype;
  final int? size;

  ChatAttachment({
    this.id,
    required this.url,
    this.name,
    this.mimetype,
    this.size,
  });

  /// Returns the file extension of the attachment
  String? get type {
    try {
      return mimetype?.split('/').last;
    } catch (e) {
      debugPrint("Error getting mime type: $e");
    }
    return null;
  }

  String? get sizeStr => getFileSizeString(bytesVal: size);
  static String? getFileSizeString({required int? bytesVal, int decimals = 0}) {
    if (bytesVal == null) return null;
    const suffixes = ["bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytesVal) / log(1024)).floor();
    return "${(bytesVal / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  MediaType get mediaType => MediaType.fromMimeType(type);

  Map<String, dynamic> toMap() => {
        'url': url,
        'name': name,
        'type': mimetype,
        'size': size,
        'id': id,
      };

  factory ChatAttachment.fromMap(Map<String, dynamic> map) => ChatAttachment(
        url: map['url'],
        name: map['name'],
        mimetype: map['type'],
        size: map['size'],
        id: map['id'],
      );
}
