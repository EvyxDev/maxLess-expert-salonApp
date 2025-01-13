import 'package:get_it/get_it.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/network/local_network.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  // sl.registerLazySingleton(() => Dio());
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  // sl.registerLazySingleton(() => DioConsumer(sl<Dio>(), sl<NetworkInfoImpl>()));
}
