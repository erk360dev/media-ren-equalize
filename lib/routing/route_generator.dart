import 'package:flutter/material.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/rename/widgets/rename_screen.dart';
import '../ui/equalize/widgets/equalize_screen.dart';
import '../domain/models/media_file.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
        
      case AppRoutes.rename:
        final args = settings.arguments as List<MediaFile>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => RenameScreen(files: args),
            settings: settings,
          );
        }
        return _errorRoute('Invalid arguments for rename screen');
        
      case AppRoutes.equalize:
        final args = settings.arguments as List<MediaFile>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => EqualizeScreen(files: args),
            settings: settings,
          );
        }
        return _errorRoute('Invalid arguments for equalize screen');
        
      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }
  
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Navigation Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}