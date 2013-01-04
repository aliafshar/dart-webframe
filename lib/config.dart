
part of webframe;



Map DEFAULT_OPTIONS = {
  'debug': false,
  'server_address': '0.0.0.0',
  'server_port': 8081,
};


class Config {

  final Map _options = {};

  dynamic get(String key) {
    return _options[key];
  }

  set(String key, dynamic value) {
    _options[key] = value;
  }

  Config() {
    DEFAULT_OPTIONS.forEach((k, v) => _options[k] = v);
  }

  String toString() {
    return _options.toString();
  }

}
