import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    BlocProvider.of<DashboardBloc>(context)
        .add(DashboardPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is FetchDashboardDataState) {
          return _buildLayout(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }

  _buildLayout({required FetchDashboardDataState dataState}) {
    return  ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: dataState.listOfPipelineSection.length,
      itemBuilder: (context, index) {
        final data = dataState.listOfPipelineSection[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text("Section: ${data.section}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Piggable: ${data.piggingNd}, Non-operating: ${data.piggingOverdue > 0 ? 'Yes' : 'No'}"),
            children: [
              _statusTile("ILI", data.iliDue, data.iliOverdue, nd: data.iliNd),
              _statusTile("DA / Other", data.daDue + data.iaOtherDue, data.daOverdue + data.iaOtherOverdue,
                  nd: data.daNd + data.iaOtherNd),
              _statusTile("Cathodic Protection", data.cpUnderProtection, data.cpOverProtection, nd: data.cpProtected),
              _statusTile("CIPS", data.cipsDue, data.cipsOverdue, nd: data.cipsNd),
              _statusTile("CAT", data.catDue, data.catOverdue, nd: data.catNd),
              _statusTile("ACVG / DCVG", data.dcvgAcvgDue, data.dcvgAcvgOverdue, nd: data.dcvgAcvgNd),
              _hotspotSection(data),
              _interferenceSection(data),
            ],
          ),
        );
      },

    );
  }

  Widget _hotspotSection(PipelineSection data) {
    return ListTile(
      leading: const Icon(Icons.warning, color: Colors.orange),
      title: const Text("CP Hot Spots"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Under Protection: ${data.cpUnderProtection > 0 ? 'Yes' : 'No'}"),
          Text("Over Protection: ${data.cpOverProtection > 0 ? 'Yes' : 'No'}"),
          Text("Shorted IJ: ${data.shortedIj > 0 ? 'Yes' : 'No'}"),
        ],
      ),
    );
  }

  Widget _interferenceSection(PipelineSection data) {
    return ListTile(
      leading: const Icon(Icons.bolt, color: Colors.red),
      title: const Text("Interference"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Shorted Casing: ${(data.shortedCasingElectrical + data.shortedCasingElectrolytic) > 0 ? 'Yes' : 'No'}"),
          Text("AC Interference: ${data.acInterference > 0 ? 'Present' : 'None'}"),
        ],
      ),
    );
  }
}
Widget _statusTile(String label, int due, int overdue, {int nd = 0}) {
  int total = nd + due + overdue;
  total = total == 0 ? 1 : total; // prevent divide-by-zero
  double ndPercent = nd / total;
  double duePercent = due / total;
  double overduePercent = overdue / total;

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _legendDot(color: Colors.green, label: "ND ($nd)"),
                    const SizedBox(width: 10),
                    _legendDot(color: Colors.orange, label: "Due ($due)"),
                    const SizedBox(width: 10),
                    _legendDot(color: Colors.red, label: "Overdue ($overdue)"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _progressSegment(color: Colors.green, percent: ndPercent),
                    _progressSegment(color: Colors.orange, percent: duePercent),
                    _progressSegment(color: Colors.red, percent: overduePercent),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _legendDot({required Color color, required String label}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 10, height: 10, color: color),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

Widget _progressSegment({required Color color, required double percent}) {
  return Expanded(
    flex: (percent * 100).round(),
    child: Container(
      height: 8,
      color: color,
    ),
  );
}
