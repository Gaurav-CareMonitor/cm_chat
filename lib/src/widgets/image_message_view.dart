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
import 'dart:convert';
import 'dart:io';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
  }) : super(key: key);

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  String get imageUrl => message.message;

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageMessageConfig?.shareIconConfig,
        imageUrl: imageUrl,
      );

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;

  TextStyle? get _textStyle => isMessageBySender
      ? outgoingChatBubbleConfig?.textStyle
      : inComingChatBubbleConfig?.textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender) iconButton,
        Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              margin: imageMessageConfig?.margin ??
                  EdgeInsets.only(
                    top: 6,
                    right: isMessageBySender ? 6 : 0,
                    left: isMessageBySender ? 0 : 6,
                    bottom: message.reaction.reactions.isNotEmpty ? 15 : 0,
                  ),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: imageMessageConfig?.borderRadius ??
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => imageMessageConfig?.onTap != null
                        ? imageMessageConfig?.onTap!(imageUrl)
                        : null,
                    child: Transform.scale(
                      scale: highlightImage ? highlightScale : 1.0,
                      alignment: isMessageBySender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: imageMessageConfig?.padding ??
                            const EdgeInsets.all(5),
                        height: imageMessageConfig?.height ?? 200,
                        width: imageMessageConfig?.width ?? 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: imageMessageConfig?.borderRadius ??
                              BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: imageMessageConfig?.borderRadius ??
                              BorderRadius.circular(14),
                          child: (() {
                            if (imageUrl.isUrl) {
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.fitHeight,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              );
                            } else if (imageUrl.fromMemory) {
                              return Image.memory(
                                base64Decode(imageUrl
                                    .substring(imageUrl.indexOf('base64') + 7)),
                                fit: BoxFit.fill,
                              );
                            } else {
                              return Image.file(
                                File(imageUrl),
                                fit: BoxFit.fill,
                              );
                            }
                          }()),
                        ),
                      ),
                    ),
                  ),
                  // Visibility(
                  //   visible: false,
                  //   maintainAnimation: true,
                  //   maintainSize: true,
                  //   maintainState: true,
                  //   child: _wBottom(textTheme),
                  // ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //   child: _wBottom(textTheme),
            // ),
            if (message.reaction.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reaction: message.reaction,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender) iconButton,
      ],
    );
  }

  Widget _wBottom(TextTheme textTheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if ((message.hint ?? "").isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              message.hint!,
              style: _textStyle?.copyWith(
                      fontSize: 10, color: Colors.grey.shade700) ??
                  textTheme.bodyMedium!
                      .copyWith(color: Colors.grey.shade100, fontSize: 10),
            ),
          ),
        Text(
          DateFormat.jm().format(message.createdAt),
          style:
              _textStyle?.copyWith(fontSize: 10, color: Colors.grey.shade700) ??
                  textTheme.bodyMedium!
                      .copyWith(color: Colors.grey.shade100, fontSize: 10),
        ),
      ],
    );
  }
}
