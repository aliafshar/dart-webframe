
library db;

import 'webframe.dart';



class DbExtension {

  onAppConfig(Config config) {
    config.set('db_host', '127.0.0.1');
  }

  setup(Webframe app) {
    app.onConfig.on(onAppConfig);
  }
}