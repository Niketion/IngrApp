import 'user.dart';
import 'structure.dart';

class Characteristic {
  User _user;
  double _height;
  List<Preference> _hisPreference;
  List<Preference> _whoSearch;
  DateTime _dateTime;
  Gender _gender;

  Characteristic(User user) {
    this._user = user;
  }

  User getUser() {
    return _user;
  }
}