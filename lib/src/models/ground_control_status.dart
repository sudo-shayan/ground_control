/// Represents the current state of the GroundControl system.
enum GroundControlStatus {
  /// The system is currently fetching the remote configuration.
  loading,

  /// The app is in normal working state.
  normal,

  /// No internet connection was detected while fetching config (and no cache exists).
  noInternet,

  /// The app is currently in maintenance mode (Blocking).
  maintenance,

  /// The app version is below the minimum required version (Blocking).
  forceUpdate,

  /// A new version is detected and the changelog should be shown (Dismissible).
  whatsNew,
}
