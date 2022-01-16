import 'package:flutter/material.dart';
import 'models/pr.dart';
import 'pages/home_page.dart';
import 'pages/pr_page.dart';
import 'pages/unknown_page.dart';

enum ReleasesPage {
  unknown,
  home,
  pr,
}

class ReleasesRoutePath {
  final int? prNumber;
  final ReleasesPage page;

  ReleasesRoutePath.home()
      : prNumber = null,
        page = ReleasesPage.home;

  ReleasesRoutePath.pr(this.prNumber)
      : page = ReleasesPage.pr;

  ReleasesRoutePath.unknown()
      : prNumber = null,
        page = ReleasesPage.unknown;
}

class ReleasesRouteInformationParser extends RouteInformationParser<ReleasesRoutePath> {
  @override
  Future<ReleasesRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return ReleasesRoutePath.home();
    }

    // Handle '/pr/:prNumber'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'pr') {
        return ReleasesRoutePath.unknown();
      }

      late final int prNumber;
      try {
        prNumber = int.parse(uri.pathSegments[1]);
      } catch (error) {
        return ReleasesRoutePath.unknown();
      }

      return ReleasesRoutePath.pr(prNumber);
    }

    // Handle unknown routes
    return ReleasesRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(ReleasesRoutePath configuration) {
    if (configuration.page == ReleasesPage.unknown) {
      return const RouteInformation(location: '/404');
    }
    if (configuration.page == ReleasesPage.home) {
      return const RouteInformation(location: '/');
    }
    if (configuration.page == ReleasesPage.pr) {
      return RouteInformation(location: '/pr/${configuration.prNumber}');
    }
    return null;
  }
}

class ReleasesRouterDelegate extends RouterDelegate<ReleasesRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ReleasesRoutePath> {

  ReleasesRouterDelegate({
    this.pr,
    this.page = ReleasesPage.home,
  }) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  ReleasesPage page;
  PR? pr;

  @override
  ReleasesRoutePath get currentConfiguration {
    if (page == ReleasesPage.unknown) {
      return ReleasesRoutePath.unknown();
    }
    assert(pr != null || page != ReleasesPage.pr);
    return page == ReleasesPage.pr
        ? ReleasesRoutePath.pr(pr!.number)
        : ReleasesRoutePath.home();
  }

  void onNavigateToPR(PR selectedPR) {
    pr = selectedPR;
    page = ReleasesPage.pr;
    notifyListeners();
  }

  /*
  @override
  Future<void> setInitialRoutePath(ReleasesRoutePath configuration) {
    return setNewRoutePath(configuration);
  }
  */

  @override
  Future<void> setNewRoutePath(final ReleasesRoutePath configuration) async {
    if (configuration.page == ReleasesPage.unknown) {
      pr = null;
      page = ReleasesPage.unknown;
      return;
    }

    if (configuration.page == ReleasesPage.pr) {
      page = ReleasesPage.pr;
      // TODO(justinmc): Fetch PR here?
      /*
      pr = stations.singleWhere(
        (Station station) => station.id == configuration.stationId,
      );

      if (station == null) {
        page = ReleasesPage.unknown;
        return;
      }
      */
    } else {
      pr = null;
      page = ReleasesPage.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      restorationScopeId: 'root',
      pages: <Page>[
        const HomePage(),
        if (page == ReleasesPage.unknown)
          const UnknownPage(),
        if (page == ReleasesPage.pr)
          PRPage(
            pr: pr!,
          ),
      ],
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        pr = null;
        page = ReleasesPage.home;
        notifyListeners();

        return true;
      },
    );
  }
}
