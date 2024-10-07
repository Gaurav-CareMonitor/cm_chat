/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/chatview.dart';

class ReplyMessage {
  /// Provides reply message.
  final String message;

  /// Provides user id of who replied message.
  final ChatUser? replyBy;

  /// Provides user id of whom to reply.
  final ChatUser? replyTo;
  final MessageType messageType;

  /// Provides max duration for recorded voice message.
  final Duration? voiceMessageDuration;

  /// Id of message, it replies to.
  final String messageId;

  const ReplyMessage({
    this.messageId = '',
    this.message = '',
    this.replyTo,
    this.replyBy,
    this.messageType = MessageType.text,
    this.voiceMessageDuration,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        message: json['message']?.toString() ?? '',
        replyBy: ChatUser.fromJson(json['replyBy'] ?? {}),
        replyTo: ChatUser.fromJson(json['replyTo'] ?? {}),
        messageType: MessageType.tryParse(json['message_type']?.toString()) ??
            MessageType.text,
        messageId: json['id']?.toString() ?? '',
        voiceMessageDuration: Duration(
          microseconds:
              int.tryParse(json['voiceMessageDuration'].toString()) ?? 0,
        ),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'replyBy': replyBy?.toJson(),
        'replyTo': replyTo?.toJson(),
        'message_type': messageType.name,
        'id': messageId,
        'voiceMessageDuration': voiceMessageDuration?.inMicroseconds,
      };

  ReplyMessage copyWith({
    String? messageId,
    String? message,
    ChatUser? replyTo,
    ChatUser? replyBy,
    MessageType? messageType,
    Duration? voiceMessageDuration,
    bool forceNullValue = false,
  }) {
    return ReplyMessage(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      replyTo: replyTo ?? this.replyTo,
      replyBy: replyBy ?? this.replyBy,
      messageType: messageType ?? this.messageType,
      voiceMessageDuration: forceNullValue
          ? voiceMessageDuration
          : voiceMessageDuration ?? this.voiceMessageDuration,
    );
  }
}