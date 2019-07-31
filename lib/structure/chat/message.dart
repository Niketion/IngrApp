import 'dart:convert';

import 'package:ingrif_app/structure/chat/chat.dart';
import 'package:ingrif_app/structure/structure.dart';
import 'package:ingrif_app/structure/user.dart';


class Message {
  MessageType _type;
  Chat _chat;
  String _encodeType;
  int _index;
  User _whoSent;
  bool _viewed;

  Message({int index, int chatID, bool viewed, int whoSentID, String encode, MessageType type}) {
    this._index = index;
    //this._chat = new Chat(chatID);
    this._viewed = viewed;
    User.fromID(whoSentID).then((result) {
      this._whoSent = result;
    });
    this._encodeType = encode;
    this._type = type;
  }

  Future<String> parseToJson() async {
    Map<String, dynamic> toJson() =>
        {
          'chatID': _chat.getChatID(),
          'index': _index,
          'whoSent': _whoSent.getID(),
          'viewed': _viewed,
          'type': _type,
          'encode': _encodeType
        };
    return jsonEncode(toJson());
  }

  Message parseToMessage(String string) {
    Map<String, dynamic> map = jsonDecode(string);
    return new Message(index: map['index'], viewed: map['viewed'], type: map['type'],
        encode: map['encode'], whoSentID: map['whoSent'], chatID: map['chatID']);
  }

  Chat getChat() {
    return _chat;
  }
}

enum MessageType {
  TEXT, IMG, AUDIO, VIDEO
}