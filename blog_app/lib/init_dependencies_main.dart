part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependensies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supaBaseUrl,
    anonKey: AppSecrets.annonKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  _initAuth();
  _initBlog();
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSources>(
      () => AuthRemoteDataSourcesImp(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoriesImpl(serviceLocator(), serviceLocator()),
    )
    //UseCases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSources>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSources>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
