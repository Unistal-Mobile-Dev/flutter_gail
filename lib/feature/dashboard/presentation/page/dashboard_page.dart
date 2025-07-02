
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/bloc/dashboard_bloc.dart';
import 'package:flutter_gail/utils/commonWidgets/center_loader_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {


  @override
  void initState() {
    BlocProvider.of<DashboardBloc>(context,).add(DashboardPageLoadEvent(context: context));
    super.initState();
  }

  final List<Color> colorList = [
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.blueGrey,
  ];


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

  Widget _buildLayout({required FetchDashboardDataState dataState}) {

    int totalCpUnderProtection = 0;
    int totalShortedCasingElectrical = 0;
    int totalAcInterference = 0;
    int totalCpOverProtection = 0;
    int totalShortedIJ = 0;

    int iliNd = 0, iliDue = 0, iliOverdue = 0;
    int daNd = 0, daDue = 0, daOverdue = 0;
    int cpNd = 0, cpDue = 0, cpOverdue = 0;
    int cipsNd = 0, cipsDue = 0, cipsOverdue = 0;
    int catNd = 0, catDue = 0, catOverdue = 0;
    int acvgNd = 0, acvgDue = 0, acvgOverdue = 0;

    for (var data in dataState.listOfPipelineSection) {
      iliNd += data.iliNd;
      iliDue += data.iliDue;
      iliOverdue += data.iliOverdue;

      daNd += data.daNd + data.iaOtherNd;
      daDue += data.daDue + data.iaOtherDue;
      daOverdue += data.daOverdue + data.iaOtherOverdue;

      cpNd += data.cpProtected;
      cpDue += data.cpUnderProtection;
      cpOverdue += data.cpOverProtection;

      cipsNd += data.cipsNd;
      cipsDue += data.cipsDue;
      cipsOverdue += data.cipsOverdue;

      catNd += data.catNd;
      catDue += data.catDue;
      catOverdue += data.catOverdue;

      acvgNd += data.dcvgAcvgNd;
      acvgDue += data.dcvgAcvgDue;
      acvgOverdue += data.dcvgAcvgOverdue;

      totalCpUnderProtection += data.cpUnderProtection;
      totalShortedCasingElectrical += data.shortedCasingElectrical;
      totalAcInterference += data.acInterference;
      totalCpOverProtection += data.cpOverProtection;
      totalShortedIJ += data.shortedIj;

    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: PageView.builder(
                  itemCount: dataState.pieChartList.length,
                  controller: PageController(viewportFraction: 0.9),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final chartTitle = dataState.pieChartList[index].key;
                    final dataMap = dataState.pieChartList[index].value;
                    final total = dataMap.values.fold(0.0, (a, b) => a + b);
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                chartTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final chartRadius = constraints.maxWidth * 0.30;
                                  return PieChart(
                                    PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: chartRadius * 0.1,
                                      sections: dataMap.entries.toList().asMap().entries.map((entry) {
                                        final i = entry.key;
                                        final label = entry.value.key;
                                        final value = entry.value.value;

                                        return PieChartSectionData(
                                          color: colorList[i % colorList.length],
                                          value: value,
                                          title: '${value.toStringAsFixed(0)} km',
                                          titleStyle: const TextStyle(fontSize: 8), // Ensure it's hidden
                                          radius: chartRadius,
                                          showTitle: true,
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: dataMap.entries.toList().asMap().entries.map((entry) {
                                final i = entry.key;
                                final label = entry.value.key;
                                final value = entry.value.value;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorList[i % colorList.length],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    chartTitle == "Piggability" ? Flexible(child: TextWidget('$label: ${value.toStringAsFixed(0)}, Length: ${dataState.lengthPiggabilty[label]} km')):
                                    Flexible(child: TextWidget('$label: ${value.toStringAsFixed(0)} km')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              _summaryCard("Survey", [
                _summaryStatusTile("ILI", iliNd, iliDue, iliOverdue),
                _summaryStatusTile("DA / Other", daNd, daDue, daOverdue),
              ]),
              _summaryCard("Protection", [
                _summaryStatusTile("CIPS", cipsNd, cipsDue, cipsOverdue),
                _summaryStatusTile("CAT", catNd, catDue, catOverdue),
                _summaryStatusTile("ACVG / DCVG", acvgNd, acvgDue, acvgOverdue),
              ]),
              _interferenceSummary(
                totalCpUnderProtection: totalCpUnderProtection,
                totalShortedCasingElectrical: totalShortedCasingElectrical,
                totalAcInterference: totalAcInterference,
                totalCpOverProtection: totalCpOverProtection,
                totalShortedIJ: totalShortedIJ,
              ),
            ],
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _summaryCard(String title, List<Widget> statusTiles) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...statusTiles,
          ],
        ),
      ),
    );
  }

  Widget _summaryStatusTile(String title, int nd, int due, int overdue) {
    int total = nd + due + overdue;
    total = total == 0 ? 1 : total;

    double ndPercent = nd / total;
    double duePercent = due / total;
    double overduePercent = overdue / total;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  _progressSegment(color: Colors.green, percent: ndPercent),
                  _progressSegment(color: Colors.orange, percent: duePercent),
                  _progressSegment(color: Colors.red, percent: overduePercent),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _legendDot(
                  color: Colors.green,
                  labelWidget: _animatedLabel("ND", nd),
                ),
                const SizedBox(width: 10),
                _legendDot(
                  color: Colors.orange,
                  labelWidget: _animatedLabel("Due", due),
                ),
                const SizedBox(width: 10),
                _legendDot(
                  color: Colors.red,
                  labelWidget: _animatedLabel("Overdue", overdue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressSegment({required Color color, required double percent}) {
    final flex = (percent.isNaN ? 0.0 : percent) * 100;
    return Flexible(
      flex: flex.round(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        height: 10,
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  Widget _animatedLabel(String label, int value) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      builder: (_, val, __) {
        return Text('$label ($val)', style: const TextStyle(fontSize: 12));
      },
    );
  }

  Widget _legendDot({required Color color, required Widget labelWidget}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        labelWidget,
      ],
    );
  }

  Widget _kmLabel(String label, double km, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ${km.toStringAsFixed(2)} KM',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _interferenceSummary({
    required int totalCpUnderProtection,
    required int totalCpOverProtection,
    required int totalShortedCasingElectrical,
    required int totalShortedIJ,
    required int totalAcInterference,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CP Hot Spot Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _infoRow("Under Protection", totalCpUnderProtection, Colors.green),
            _infoRow("Over Protection", totalCpOverProtection, Colors.red),
            _infoRow("Shorted U", totalShortedCasingElectrical, Colors.orange),
            _infoRow("Shorted Casing", totalShortedIJ, Colors.purple),
            _infoRow("AC Interference", totalAcInterference, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
