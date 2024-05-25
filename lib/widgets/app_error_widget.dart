import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/exceptions/api_exception.dart';

class AppErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  const AppErrorWidget(
    this.error, {
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning),
          const SizedBox(height: 8),
          Text(
            _getText(),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: onRetry,
              ),
            ),
        ],
      ),
    );
  }

  String _getText() {
    if (error is DioException) {
      return (error as DioException).message ?? error.toString();
    }
    if (error is ApiException) {
      return (error as ApiException).msg;
    }
    if (error is Exception) {
      return error.toString();
    } else {
      return 'Something got wrong';
    }
  }
}
