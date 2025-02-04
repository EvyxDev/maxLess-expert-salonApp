import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/network/network_info.dart';
import 'package:maxless/features/auth/data/repository/auth_repo.dart';
import 'package:maxless/features/community/data/repo/community_repo.dart';
import 'package:maxless/features/profile/data/repository/profile_repo.dart';

final sl = GetIt.instance;
void initServiceLocator() {
  //!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  //! Cubits
  sl.registerLazySingleton(() => GlobalCubit());
  //! Repositories
  sl.registerLazySingleton(() => AuthRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => CommunityRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
}
