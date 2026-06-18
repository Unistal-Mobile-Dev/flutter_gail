import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/hpoil_dashboard/domain/bloc/hpOil_dashboard_bloc.dart';
import 'package:flutter_gail/feature/hpoil_dashboard/domain/bloc/hpOil_dashboard_event.dart';
import 'package:flutter_gail/feature/hpoil_dashboard/domain/bloc/hpOil_dashboard_state.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/page/task_page.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class HpOilDashboardPage extends StatefulWidget {
  const HpOilDashboardPage({super.key});

  @override
  State<HpOilDashboardPage> createState() => _HpOilDashboardPageState();
}

class _HpOilDashboardPageState extends State<HpOilDashboardPage> {
  @override
  void initState() {
    BlocProvider.of<HpOilDashboardBloc>(
      context,
    ).add(HpOilDashboardPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HpOilDashboardBloc, HpOilDashboardState>(
        builder: (context, state) {
          if (state is FetchHpOilDashboardDataState) {
            return _buildLayout(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _buildLayout({required FetchHpOilDashboardDataState dataState}) {
    final roles = dataState.userData.groupRoles ?? [];

    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return  role.moduleName == "Mobile App" ? SizedBox.shrink(): GestureDetector(
            onTap: () async {
              if (role.moduleName != null && role.moduleName!.isNotEmpty ) {
                bool isAssignTask = false;
                for (var permissionData in role.permissions!) {
                  if (permissionData.name.toString().toLowerCase() == "write") {
                    isAssignTask = permissionData.value ?? false;
                  }
                }
               await AppConfig.instanceInit()?.setGroupRoles(newVal: role);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskPage(isAssignTask: isAssignTask),
                  ),
                );

              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: <Color>[EnvironmentConfig.of(context)!.secondaryTheme, EnvironmentConfig.of(context)!.primaryTheme,],
                  /*colors: [Color(0xFF1FA34A), // green
                Color(0xFF143E7A),],*/
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    /// 🔹 ICON / IMAGE
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: role.moduleIconUrl != null &&
                          role.moduleIconUrl!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          role.moduleIconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.dashboard, color: Colors.white),
                        ),
                      )
                          : const Icon(Icons.dashboard, color: Colors.white),
                    ),

                    const SizedBox(width: 16),

                    /// 🔹 TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.moduleName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.moduleAlias ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 ARROW
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
