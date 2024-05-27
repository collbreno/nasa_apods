import 'package:flutter/material.dart';
import 'package:nasa_apod/utils/exception_utils.dart';

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
            ExceptionUtils.getExceptionMessageText(error),
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
}
