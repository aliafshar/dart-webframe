
library logging;

import 'package:logging/logging.dart';

displayLog(LogRecord r) {
  print('${r.time}:${r.level.name}:${r.message}');
}

final Logger LOG = Logger.root;

initLogging() {
  LOG.level = Level.INFO;
  LOG.on.record.add(displayLog);
}
