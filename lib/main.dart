import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/pages/home_page.dart';
import 'package:nasa_apod/repository/app_repository.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/utils/dio_utils.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final repository = await _getRepository();

  runApp(App(
    repository: repository,
  ));
}

Future<IAppRepository> _getRepository() async {
  final dio = await DioUtils.getAppDio();
  final cacheDir = await getApplicationCacheDirectory();
  dio.interceptors.add(DioCacheInterceptor(
    options: CacheOptions(
      store: FileCacheStore(cacheDir.path),
      policy: CachePolicy.forceCache,
    ),
  ));

  return AppRepository(dio);
}

class App extends StatelessWidget {
  final IAppRepository repository;
  const App({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IAppRepository>(
      create: (context) => repository,
      child: MaterialApp(
        title: 'NASA APODS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          // textTheme: TextTheme(
          //   headlineLarge: TextStyle(),
          // )
        ),
        home: const HomePage(),
      ),
    );
  }
}
