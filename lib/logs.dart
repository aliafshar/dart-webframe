
part of webframe;


logRequest(HttpRequest request) => LOG.info('Requesting ${request.path}');

displayLog(LogRecord r) {
  print('${r.time}:${r.level.name}:${r.message}');
}

final Logger LOG = Logger.root;

initLogging() {
  LOG.level = Level.ALL;
  LOG.on.record.add(displayLog);
}
