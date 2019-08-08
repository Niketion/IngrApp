import 'dart:convert';

import 'package:ingrif_app/structure/chat/chat.dart';
import 'package:ingrif_app/structure/user.dart';

import '../../main.dart';


class Message {
  Chat _chat;
  MessageType _type;
  String _encode;
  User _whoSent;
  bool _viewed;

  Message(Chat chat, MessageType type, User whoSent, String encode) {
    this._type = type;
    this._whoSent = whoSent;
    this._viewed = false;
    this._encode = encode;
    this._chat = chat;
    _insertOnDatabase();
  }

  String parseToJson() {
    var json = {};
    json["type"] = MessageTypeManager(_type).name();
    json["encode"] = _encode;
    json["whoSent"] = _whoSent.getID();
    json["viewed"] = _viewed.toString();
    return jsonEncode(json);
  }

  /// Insert a [Message] on database
  void _insertOnDatabase() async {
    await getDatabase().query("SELECT messages FROM chats WHERE id="+_chat.getChatID().toString()).then((result) async {
      for (var message in result) {
        String toSet="";
        if (message[0].toString().split(",").length == 1) {
          toSet = parseToJson()+",";
        } else {
          List<String> list = message[0].toString().split(",");
          list.add(parseToJson());
          toSet=list.join(",");
        }

        await getDatabase().query("UPDATE chats SET messages ='"+toSet+"' WHERE id="+_chat.getChatID().toString());
        print("ID: "+_chat.getChatID().toString());
      }
    });
  }
}

enum MessageType {
  TEXT, IMG, AUDIO, VIDEO
}

class MessageTypeManager {
  MessageType _enum;

  MessageTypeManager(MessageType enums) {
    this._enum = enums;
  }

  String name() {
    return _enum.toString().substring(_enum.toString().indexOf('.')+1);
  }

  MessageType getEnum() {
    return _enum;
  }

  static MessageType fromString(String string) {
    for(MessageType types in MessageType.values) {
      if (string.toUpperCase() == new MessageTypeManager(types).name()) {
        return new MessageTypeManager(types).getEnum();
      }
    }
    return null;
  }
}