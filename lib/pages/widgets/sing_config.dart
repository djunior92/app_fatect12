class ConfigGlobal {
  static ConfigGlobal _instance;

  factory ConfigGlobal(
      {double textFontSize, double titleFontSize, double multiplier}) {
    //_instance ??= UsuarioGlobal._internalConstructor(email, pass);
    if ((_instance == null) ||
        (textFontSize != null && textFontSize != null && multiplier != null)) {
      _instance = ConfigGlobal._internalConstructor(
          textFontSize, titleFontSize, multiplier);
    }
    return _instance;
  }

  ConfigGlobal._internalConstructor(
      this.textFontSize, this.titleFontSize, this.multiplier);

  double textFontSize;
  double titleFontSize;
  double multiplier;
}
