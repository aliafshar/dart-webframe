
part of webframe;


typedef Future WebframeSetup(Webframe);


class Webframe {

  final Config config = new Config();
  final List<Future> waitingFor = [];
  final HttpServer server = new HttpServer();

  final Signal onConfig = new Signal();
  final Signal onAppSetup = new Signal();
  final Signal onBeforeResponse = new Signal();
  final Signal onRequest = new Signal();

  final RouteMap routes = new RouteMap();

  Extensible extensions;

  Webframe() {

    initLogging();
    LOG.fine('Started log.');
    extensions = new Extensible(this);
    routes.views['__static__'] = staticView;
  }

  /**
   * Add an extension to Dwf.
   */
  dynamic setup(Extension setup) {
    LOG.fine('Extending with $setup.');
    return extensions.extend(setup);
  }

  /**
   * Add a named route to the application.
   */
  route(name, {String path, dynamic method, WebframeView view}) {
    var routePath = ?path ? new RoutePath.fromPath(path) : null;
    var routeMethod = ?method ? new RouteMethod.fromAnything(method) : null;
    routes.add(new Route(name, path: routePath, method: routeMethod));
    if (view != null) {
      routes.views[name] = view;
    }
  }

  /**
   * Add a static route to the application.
   */
  staticRoute(String name, String prefix, String path) {
    var routeStatic = new RouteStatic(prefix, new Path(path));
    routes.add(new Route(name, static: routeStatic));
  }

  /**
   * Dispatch a single request to the first matched route, or respond with 404.
   */
  dispatch(HttpRequest request, HttpResponse response) {
    logRequest(request);
    var matched = routes.match(request);
    var ctx = new RoundTrip(request, response);
    if (matched == null) {
      ctx.respondError(HttpStatus.NOT_FOUND);
    }
    else {
      matched.args.forEach((k, v) => ctx.matchArgs[k] = v);
      LOG.fine('Match arguments ${ctx.matchArgs}');
      var view = routes.findView(matched);
      if (view == null) {
        ctx.respondError(HttpStatus.NOT_FOUND);
      }
      else {
        view(ctx);
      }
    }
  }

  /**
   * Starts the HTTP server.
   */
  start() {
    server.defaultRequestHandler = dispatch;
    extensions.start().then((_) {
      waitingFor.add(onConfig.emit(config));
      waitingFor.add(onAppSetup.emit(this));
      Futures.wait(waitingFor).then((_) {
        _start();
      });
    });
  }

  _start() {
    server.listen(config.get('server_address'), config.get('server_port'));
    LOG.info('Started Webframe.');
  }

}