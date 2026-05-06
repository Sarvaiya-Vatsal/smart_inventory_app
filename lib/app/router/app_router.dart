import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/stock/presentation/screens/stock_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.routeDashboard,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeDashboard,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DashboardScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeProducts,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProductsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeStock,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StockScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeHistory,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeSearch,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
