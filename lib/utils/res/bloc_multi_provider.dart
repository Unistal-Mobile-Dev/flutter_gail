import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/imageShare/domain/bloc/image_share_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/otp/domain/domain/bloc/otp_bloc.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/createTask/domain/bloc/create_task_bloc.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/addTask/domain/bloc/add_task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/bloc/add_tlp_survey_bloc.dart';

MultiProvider blocMultiProvider({required Widget child}) {
  return MultiProvider(
    providers: [
      BlocProvider(create: (BuildContext context) => LoginBloc()),
      BlocProvider(create: (BuildContext context) => DashboardBloc()),
      BlocProvider(create: (BuildContext context) => HomeBloc()),
      BlocProvider(create: (BuildContext context) => MapBloc()),
      BlocProvider(create: (BuildContext context) => CreateTaskBloc()),
      BlocProvider(create: (BuildContext context) => TaskBloc()),
      BlocProvider(create: (BuildContext context) => AddMarkerBloc()),
       BlocProvider(create: (BuildContext context) => AddCrossingBloc()),
       BlocProvider(create: (BuildContext context) => AddIncidentBloc()),
       BlocProvider(create: (BuildContext context) => ViewTaskBloc()),
       BlocProvider(create: (BuildContext context) => AddTaskBloc()),
       BlocProvider(create: (BuildContext context) => EncroachmentBloc()),
       BlocProvider(create: (BuildContext context) => DeviationBloc()),
       BlocProvider(create: (BuildContext context) => ImageShareBloc()),
       BlocProvider(create: (BuildContext context) => AddTlpSurveyBloc()),
       BlocProvider(create: (BuildContext context) => OtpBloc()),

    ],
    child: child,
  );
}
