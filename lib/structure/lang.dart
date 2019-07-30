class LangManager {
  Lang _lang;

  LangManager(Lang lang) {
    this._lang = lang;
  }

  String name() {
    return _lang.toString().substring(_lang.toString().indexOf('.')+1);
  }

  Lang getEnum() {
    return _lang;
  }

  static Lang fromString(String string) {
    for(Lang langs in Lang.values) {
      if (string.toUpperCase() == new LangManager(langs).name()) {
        return new LangManager(langs).getEnum();
      }
    }
    return null;
  }
}

enum Lang {
  ENGLISH, ITALIAN
}