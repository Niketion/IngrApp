import 'dart:convert';

import 'package:ingrif_app/structure/chat/chat.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/user.dart';


class Message extends Chat {
  MessageType _type;
  Chat _chat;
  String _encodeType;
  int _index;
  User _whoSent;
  bool _viewed;

  Message(int index, MessageType messageType, {User user, Section section}) : super(user, section) {
    this._index = index;
    this._type = messageType;
  }

  String parseToJson() {
    Map<String, dynamic> toJson() =>
        {
          'chatID': _chat.getChatID(),
          'index': _index,
          'whoSent': _whoSent,
          'viewed': _viewed,
          'type': _type,
          'encode': _encodeType
        };
    return jsonEncode(toJson());
  }

  Message parseToMessage(String string) {
    return new Message(jsonDecode(string)['index'], jsonDecode(string)['type']);
  }

  Chat getChat() {
    return _chat;
  }
}

enum MessageType {
  TEXT, IMG, AUDIO, VIDEO
}