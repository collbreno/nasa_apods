import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/pages/home_page.dart';
import 'package:nasa_apod/repository/app_repository.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/utils/dio_utils.dart';

void main() async {
  final dio = await DioUtils.getAppDio();
  runApp(App(
    repository: AppRepository(dio),
  ));
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
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
