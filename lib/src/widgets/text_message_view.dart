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
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/message_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:linkify_plus/linkify_plus.dart';

import '../utils/constants/constants.dart';
import 'chat_view_inherited_widget.dart';
import 'link_preview.dart';
import 'reaction_widget.dart';

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    Key? key,
    required this.isMessageBySender,
    required this.message,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.messageReactionConfig,
    this.highlightMessage = false,
    this.highlightColor,
    this.messageDateTimeBuilder,
    this.messageTimeTextStyle,
    required this.messageConfig,
    this.children = const [],
  }) : super(key: key);

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides message instance of chat.
  final Message message;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents message should highlight.
  final bool highlightMessage;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  /// Allow user to set custom formatting of message time.
  final MessageDateTimeBuilder? messageDateTimeBuilder;

  /// Used to give text style of message's time of a chat bubble
  final TextStyle? messageTimeTextStyle;
  final List<Widget> children;

  final MessageConfiguration? messageConfig;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textMessage = message.message;
    final messageTimePositionType = ChatViewInheritedWidget.of(context)
            ?.featureActiveConfig
            .messageTimePositionType ??
        MessageTimePositionType.onRightSwipe;
    final defaultTextStyle = textTheme.bodyMedium!.copyWith(
      color: Colors.white,
      fontSize: 16,
    );

    final messageMetaData = _textSize(
      text: textMessage,
      context: context,
      style: _textStyle ?? defaultTextStyle,
    );

    final isSenderMessageOrURl = isMessageBySender || textMessage.isUrl;

    return Padding(
      padding: messageTimePositionType.isOutSideChatBubbleAtBottom
          ? const EdgeInsets.only(bottom: 10)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: isMessageBySender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ...children.map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 5), child: e)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (textMessage.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                      maxWidth: chatBubbleMaxWidth ??
                          MediaQuery.of(context).size.width * 0.75),
                  padding: _padding ??
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                  margin: _margin ??
                      EdgeInsets.fromLTRB(5, 0, 6,
                          message.reaction.reactions.isNotEmpty ? 15 : 2),
                  decoration: BoxDecoration(
                    color: highlightMessage ? highlightColor : _color,
                    borderRadius: _borderRadius(textMessage),
                  ),
                  child: Column(
                    crossAxisAlignment: isMessageBySender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textMessage.isUrl
                          ? LinkPreview(
                              linkPreviewConfig: _linkPreviewConfig,
                              url: textMessage,
                            )
                          : Wrap(
                              alignment: WrapAlignment.end,
                              spacing:
                                  messageMetaData.numberOfLine < 2 ? 10 : 0,
                              children: [
                                Linkify(
                                  textScaleFactor: MediaQuery.of(context)
                                      .textScaler
                                      .scale(1),
                                  text: textMessage,
                                  linkStyle: _linkStyle ??
                                      textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                  onOpen: (e) =>
                                      messageConfig?.onUrlTap?.call(e.url),
                                  style: _textStyle ??
                                      textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                  options: const LinkifyOptions(
                                    humanize: true,
                                    removeWww: true,
                                    looseUrl: false,
                                  ),
                                ),
                                if (messageTimePositionType.isInsideChatBubble)
                                  Transform.translate(
                                    offset: const Offset(0, 8),
                                    child: messageDateTimeBuilder
                                            ?.call(message.createdAt) ??
                                        MessageTimeWidget(
                                          messageTime: message.createdAt,
                                          isCurrentUser: isMessageBySender,
                                          messageTimeTextStyle:
                                              messageTimeTextStyle,
                                        ),
                                  ),
                              ],
                            ),
                      if (messageTimePositionType.isInsideChatBubblev2)
                        _wBottom()
                    ],
                  ),
                ),
              if (messageTimePositionType.isInsideChatBubblev2 &&
                  message.message.isEmpty)
                Padding(
                  padding: _padding ?? EdgeInsets.zero,
                  child: _wBottom(),
                ),
              if (message.reaction.reactions.isNotEmpty)
                ReactionWidget(
                  key: key,
                  isMessageBySender: isMessageBySender,
                  reaction: message.reaction,
                  messageReactionConfig: messageReactionConfig,
                ),
              if (messageTimePositionType.isOutSideChatBubbleAtBottom)
                Positioned(
                  bottom: messageMetaData.numberOfLine <= 1 &&
                          messageMetaData.messageWidth <= 90
                      ? -18
                      : message.reaction.reactions.isNotEmpty
                          ? -4
                          : -16,
                  right: isSenderMessageOrURl ? 10 : null,
                  left: isSenderMessageOrURl ? null : 12,
                  child: messageDateTimeBuilder?.call(message.createdAt) ??
                      MessageTimeWidget(
                        isCurrentUser: isMessageBySender,
                        messageTime: message.createdAt,
                        messageTimeTextStyle: messageTimeTextStyle,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wBottom() {
    return Transform.translate(
      offset: const Offset(0, 5),
      child: messageDateTimeBuilder?.call(message.createdAt) ??
          MessageTimeWidget(
            messageTime: message.createdAt,
            isCurrentUser: isMessageBySender,
            messageTimeTextStyle: messageTimeTextStyle,
          ),
    );
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     if ((message.metadata?["hint"]?.toString() ?? "").isNotEmpty)
    //       Padding(
    //         padding: const EdgeInsets.only(right: 10),
    //         child: Text(
    //           message.metadata?["hint"]?.toString() ?? "",
    //           style: _textStyle?.copyWith(
    //                   fontSize: 10, color: Colors.grey.shade700) ??
    //               textTheme.bodyMedium!
    //                   .copyWith(color: Colors.grey.shade100, fontSize: 10),
    //         ),
    //       ),
    //     Text(
    //       intl.DateFormat.jm().format(message.createdAt),
    //       style:
    //           _textStyle?.copyWith(fontSize: 10, color: Colors.grey.shade700) ??
    //               textTheme.bodyMedium!
    //                   .copyWith(color: Colors.grey.shade100, fontSize: 10),
    //     ),
    //   ],
    // );
  }

  ({int numberOfLine, double messageWidth}) _textSize({
    required String text,
    required TextStyle style,
    required BuildContext context,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth:
            (chatBubbleMaxWidth ?? MediaQuery.of(context).size.width * 0.75) -
                (_padding?.horizontal ?? 24));

    return (
      numberOfLine: textPainter.computeLineMetrics().length,
      messageWidth: textPainter.width
    );
  }

  EdgeInsetsGeometry? get _padding => isMessageBySender
      ? outgoingChatBubbleConfig?.padding
      : inComingChatBubbleConfig?.padding;

  EdgeInsetsGeometry? get _margin => isMessageBySender
      ? outgoingChatBubbleConfig?.margin
      : inComingChatBubbleConfig?.margin;

  LinkPreviewConfiguration? get _linkPreviewConfig => isMessageBySender
      ? outgoingChatBubbleConfig?.linkPreviewConfig
      : inComingChatBubbleConfig?.linkPreviewConfig;

  TextStyle? get _textStyle => isMessageBySender
      ? outgoingChatBubbleConfig?.textStyle
      : inComingChatBubbleConfig?.textStyle;

  TextStyle? get _linkStyle => isMessageBySender
      ? outgoingChatBubbleConfig?.linkStyle
      : inComingChatBubbleConfig?.linkStyle;

  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? outgoingChatBubbleConfig?.borderRadius ??
          (message.length < 37
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2))
      : inComingChatBubbleConfig?.borderRadius ??
          (message.length < 29
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2));

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;
}
