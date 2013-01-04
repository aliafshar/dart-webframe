
import '../../lib/webframe.dart';
import '../../lib/db.dart';


class JsonService {

  list(RoundTrip r) {
    r.respond(body: 'bababa');
  }

  setup(Webframe app) {
    app.route('banana', path: '/banana', view: list);
  }

}


setup(Webframe app) {
  app.route('index', path: '/', view: new RedirectView('/index.html'));
  app.route('humans', path: '/humans.txt', view: humans);
  app.setup(new JsonService().setup);
  app.setup(new DbExtension().setup);
  app.staticRoute('__static__', '/', 'example/web');
}

humans(RoundTrip r) => r.respond(body: 'Take me to your leader.');

main() {
  startWebframe(setup);
}
