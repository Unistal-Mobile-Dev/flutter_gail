import 'package:intl/intl.dart';

class TlpTaskPeriodModel {
  dynamic id;
  String? name;
  String? startDate;
  String? endData;

  TlpTaskPeriodModel({this.id, this.name, this.startDate, this.endData});

  List<TlpTaskPeriodModel> getData(int year) {
    List<TlpTaskPeriodModel> tlpTaskPeriodList = [];
    DateFormat nameFormat = DateFormat('MMM yyyy');
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    DateTime current = DateTime(year, 1); // Start from Jan of the given year

    for (int i = 0; i < 6; i++) {
      DateTime next = DateTime(current.year, current.month + 2);

      TlpTaskPeriodModel period = TlpTaskPeriodModel(
        id: i + 1,
        name: '${nameFormat.format(current)} - ${nameFormat.format(next.subtract(const Duration(days: 1)))}',
        startDate: dateFormat.format(current),
        endData: dateFormat.format(next.subtract(const Duration(days: 1))),
      );

      tlpTaskPeriodList.add(period);
      current = next;
    }

    return tlpTaskPeriodList;
  }

}
