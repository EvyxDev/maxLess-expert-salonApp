part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

final class RequestsInitial extends RequestsState {}

final class GetRequestsLoadingState extends RequestsState {}

final class GetRequestsErrorState extends RequestsState {
  final String message;

  const GetRequestsErrorState({required this.message});
}

final class GetRequestsSuccessState extends RequestsState {}
