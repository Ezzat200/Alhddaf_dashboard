




sealed class PortofolioState {}

final class PortofolioInitial extends PortofolioState {}
class PortofolioLoading extends PortofolioState {}
class PortofolioLoaded extends PortofolioState {}



// class PortofolioVisibilityVisible extends PortofolioState {}

// class PortofolioVisibilityHidden extends PortofolioState {}
class PortofolioError extends PortofolioState {
  final String error;
  PortofolioError(this.error);

}