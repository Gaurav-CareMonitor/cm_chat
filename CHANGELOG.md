## [2.0.0] (Unreleased)

* **Breaking**: [177](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/177) Fixed
  json serializable of models and added copyWith method (Message, Reaction and Reply Message).
* **Fix**: [182](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/182) Fix
  send message not working when user start texting after newLine.
* **Feat**: [156](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/156) Added
  default avatar, error builder for asset, network and base64 profile image and
  cached_network_image for network images.
* **Breaking**: [173](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/173) Added
  callback to sort message in chat.
* **Fix**: [181](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/181) Removed
  deprecated field `showTypingIndicator` from ChatView.
* **Fix**: [139](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/139) Added
  support to customize view for the reply of any message.
* **Fix**: [174](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/174) Fix
  wrong username shown while replying to any messages.
* **Fix**: [134](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/134)
  Added a reply message view for custom message type.
* **Feat**: [157](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/157)
  Added onTap of reacted user from reacted user list.
* **Fix**: [137](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/137) Added
  support for cancel voice recording and field to provide cancel record icon.
* **Feat**: [93](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/93) Added support
  that provide date pattern to change chat separation.
* **Fix**: [142](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/142) Added
  field to provide base64 string data for profile picture.
* **Fix**: [165](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/165) Fix issue
  of user reaction callback provides incorrect message object when user react on any message
  with double or from reaction sheet.
* **Fix**: [164](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/164)
  Add flag to enable/disable chat text field.
* **Feat**: [121](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/121)Added support
  for configuring the audio recording quality.
* **Fix**: [131](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/131)
  Fix unsupported operation while running on the web.
* **Fix**: [160](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/160) Added
  configuration for emoji picker sheet.
* **Fix**: [130](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/130) Added
  report button for receiver message and update onMoreTap, onReportTap callback.
* **Fix**: [126](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/126) Added
  flag to hide user name in chat.
* **Feat**: [161](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/161) Added
  field to set top padding of chat text field.

## [1.3.1]

* **Feat**: [105](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/105) Allow user
  to get callback when image is picked so user can perform operation like crop. Allow user to pass
  configuration like height, width, image quality and preferredCameraDevice.
* **Fix**: [95](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/95) Fix issue of
  chat is added to bottom while `loadMoreData` callback.
* **Fix**: [109](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/109) Added
  support for the hiding/Un-hiding gallery and camera buttons

## [1.3.0]

* **Feat**: [71](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/71) Added Callback
  when a user starts/stops composing typing a message.
* **Fix**: [78](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/78) Fix issue of
  unmodifiable list.
* **Feat**: [76](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/76) Message
  Receipts.
* **Fix**: [81](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/81) Fix issue of
  TypingIndicator Rebuilding ChatView.
* **Fix**: [94](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/pull/94) Fixed deprecated
  `showRecentsTab` property with new `recentTabBehavior`.
* Support for latest flutter version `3.10.5`.
* Update dependencies `http` to version `1.1.0` and `image_picker` to version
  range `'>=0.8.9 <2.0.0'`.

## [1.2.1]

* **Fix**: [60](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/60) Fix image from
  file is not loaded.
* **Fix**: [61](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/61) Fix issue of
  audio message is not working.
* **Feat**: [65](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/65) Add callback
  when user react on message.

## [1.2.0+1]

* **Feat**: [42](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/42) Ability to
  get callback on tap of profile circle avatar.
* **Breaking**: Add `messageType` in `onSendTap` callback for encountering messages.
* **Breaking**: Remove `onRecordingComplete` and you can get Recorded audio in `onSendTap` callback
  with `messageType`.
* **Breaking**: Remove `onImageSelected` from `ImagePickerIconsConfiguration` and can get selected
  image in `onSendTap` callback with `messageType`.
* **Feat**: [49](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/49)
  Add `onUrlDetect`
  callback for opening urls.
* **Feat**: [51](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/51) Ability to
  get callback on long press of profile circle avatar.

## [1.1.0]

* **Feat**: [37](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/37) Ability to
  enable or disable specific features.
* **Feat**: [34](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/34) Ability to
  add voice message.
* **Breaking**: Remove `onEmojiTap` from `ReactionPopupConfiguration`, it can be handled internally.
* **Breaking**: Remove `horizontalDragToShowMessageTime` from `ChatBackgroundConfiguration` and
  add `enableSwipeToSeeTime` parameter with same feature in `FeatureActiveConfig`.
* **Breaking**: Remove `showReceiverProfileCircle` and add `enableOtherUserProfileAvatar` parameter
  with same feature in `FeatureActiveConfig`.
*
    * **Breaking**: Move `enablePagination` parameter from `ChatView` to `FeatureActiveConfig`.

## [1.0.1]

* **Fix**: [32](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/32) Fix issue of
  while replying to image it highlights the link instead of the image.
* **Fix**: [35](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/35) Fix issue of
  removing reaction which is reacted accidentally.

## [1.0.0+1]

* **Breaking**: Remove `sender` and `receiver` from `ChatView`.
* **Breaking**: Add `currentUser` to chat view, which represent the sender.
* **Breaking**: Replace `title` and `titleTextStyle` with `chatTitle` and `chatTitleTextStyle`
  respectively in `ChatViewAppBar`
* **Breaking**: Add `profilePhoto` in `ChatUser` to show profile picture of sender.
* **Breaking**: Add `chatUsers` in `ChatController`.
* **Breaking**: Add `chatViewState` in `ChatView`.
* **Breaking**: Change type of `reaction` to `Reaction` in `Message`.
* [#8](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/8) Implement loading, error
  and no message UIs.
* [#13](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/13) Implement group chat
  and multiple reaction support.
* [#22](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/22) Add `TextInputType`
  for `TextField`.
* [#24](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/24)
  Add `MessageType.custom` for custom messages.
* **FEAT**: Auto scroll to replied message.

## [0.0.3]

* [#7](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/7) Add
  image-picker.

## [0.0.2]

* Fixed [#10](https://github.com/SimformSolutionsPvtLtd/flutter_chatview/issues/10) - emoji and
  text.

## [0.0.1]

* Initial release.


