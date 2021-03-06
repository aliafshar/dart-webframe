
part of webframe;



Map DEFAULT_OPTIONS = {
  'debug': true,
  'server_address': '0.0.0.0',
  'server_port': 9091,
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
    update(DEFAULT_OPTIONS);
  }

  update(Map from) {
    from.forEach((k, v) => _options[k] = v);
  }

  load(String filename) {
    loadFile(new File(filename));
  }

  loadFile(File file) {
    loadString(file.readAsStringSync());
  }

  loadString(String data) {
    update(JSON.parse(data));
  }

  String toString() {
    return _options.toString();
  }

}
