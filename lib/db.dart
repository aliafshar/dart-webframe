
library db;

import 'webframe.dart';



class DbExtension {

  static final Map DEFAULT_OPTIONS = {
    'db_host': '127.0.0.1',
  };

  onAppConfig(Config config) {
    config.update(DEFAULT_OPTIONS);
  }

  setup(Webframe app) {
    app.onConfig.on(onAppConfig);
  }
}