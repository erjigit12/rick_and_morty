import 'package:get_it/get_it.dart';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rick_morty/src/core/network/network_info.dart';
import 'package:rick_morty/src/features/data/datasources/person_local_data_source.dart';
import 'package:rick_morty/src/features/data/datasources/person_remote_data_source.dart';
import 'package:rick_morty/src/features/data/repositories/person_repository_impl.dart';
import 'package:rick_morty/src/features/domain/repositories/person_repository.dart';
import 'package:rick_morty/src/features/domain/usecases/get_all_persons_usecase.dart';
import 'package:rick_morty/src/features/domain/usecases/get_favorite_persons_usecase.dart';
import 'package:rick_morty/src/features/domain/usecases/is_favorite_usecase.dart';
import 'package:rick_morty/src/features/domain/usecases/search_person_usecase.dart';
import 'package:rick_morty/src/features/domain/usecases/toggle_favorite_usecase.dart';
import 'package:rick_morty/src/features/presentation/bloc/favorites/favorites_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/main/main_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/person_list/person_list_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/search/search_bloc.dart';
import 'package:rick_morty/src/features/presentation/bloc/theme/theme_cubit.dart';

final sl = GetIt.instance;
const _personBoxName = 'person_box';
const _settingsBoxName = 'settings_box';

Future<void> init() async {
  await Hive.initFlutter();
  final personsBox = await Hive.openBox<dynamic>(_personBoxName);
  final settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);

  // Bloc
  sl.registerFactory(() => MainCubit());
  sl.registerFactory(() => PersonListCubit(getAllPersonsUsecase: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPersonUsecase: sl()));
  sl.registerFactory(
    () => FavoritesCubit(
      getFavoritePersonsUsecase: sl(),
      toggleFavoriteUsecase: sl(),
    ),
  );
  sl.registerFactory(() => ThemeCubit(settingsBox: settingsBox));

  // UseCases
  sl.registerLazySingleton(() => GetAllPersonsUsecase(personRepository: sl()));
  sl.registerLazySingleton(() => GetFavoritePersonsUsecase(personRepository: sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUsecase(personRepository: sl()));
  sl.registerLazySingleton(() => IsFavoriteUsecase(personRepository: sl()));
  sl.registerLazySingleton(() => SearchPersonUsecase(personRepository: sl()));

  //Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImpl(personsBox: personsBox),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}
