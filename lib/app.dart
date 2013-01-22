
part of webframe;



typedef Future WebframeSetup(Webframe);


class Webframe {

  final Config config = new Config();
  final List<Future> waitingFor = [];
  final HttpServer server = new HttpServer();
  final RouteMap routes = new RouteMap();

  final Signal<Config> onConfig = new Signal<Config>();
  final Signal<RoundTrip> onRoundTrip = new Signal<RoundTrip>();
  final Signal<Webframe> onApp = new Signal();

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
  Route route(name, {String path, dynamic method, WebframeView view}) {
    var routePath = ?path ? new RoutePath.fromPath(path) : null;
    var routeMethod = ?method ? new RouteMethod.fromAnything(method) : null;
    var route = new Route(name, path: routePath, method: routeMethod);
    routes.add(route);
    if (view != null) {
      routes.views[name] = view;
    }
  }

  /**
   * Add a static route to the application.
   */
  Route staticRoute(String name, String prefix, String path) {
    var routeStatic = new RouteStatic(prefix, new Path(path));
    var route = new Route(name, static: routeStatic);
    routes.add(route);
    return route;
  }

  /**
   * Add a route to redirect from one URI to another.
   */
  Route redirectRoute(String name, String from, String to) {
    return route(name, path: from, view: new RedirectView(to).call);
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
      waitingFor.add(onApp.emit(this));
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