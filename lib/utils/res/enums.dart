enum FieldStyle { underline, box }

enum RoleType { patrollingMan } // CRIC

enum TaskStatus { notStarted, started, pause, completed, resume }

enum DeviceType { phone, tablet }

enum Client { hpoil , hpcl}

enum OtpType { login, loginEmail, loginMobile, registration }

enum RouteObservation {
  crossing(1),
  encroachment(2),
  marker(3),
  deviation(4),
  incident(5);
  final int value;
  const RouteObservation(this.value);
}

enum AppPermissionStatus { granted, denied, permanentlyDenied }


enum AppModule {mdpLinePatrolling, steelLinePatrolling}