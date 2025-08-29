class AppRoutes {
  static const String home = '/';
  static const String rename = '/rename';
  static const String equalize = '/equalize';
  static const String settings = '/settings';
  
  /// Get all available routes
  static List<String> get allRoutes => [
    home,
    rename,
    equalize,
    settings,
  ];
  
  /// Check if a route is valid
  static bool isValidRoute(String route) {
    return allRoutes.contains(route);
  }
  
  /// Get route name from path
  static String getRouteName(String route) {
    switch (route) {
      case home:
        return 'Home';
      case rename:
        return 'Rename Files';
      case equalize:
        return 'Equalize Audio';
      case settings:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }
}