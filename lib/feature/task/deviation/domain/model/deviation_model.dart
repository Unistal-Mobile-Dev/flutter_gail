class DeviationModel {

    dynamic id;
    String? name;

    DeviationModel({this.id, this.name});

    factory DeviationModel.fromJson(Map<String, dynamic> json) {
      return DeviationModel(
        id: json[''] ?? "",
        name: json[''] ?? "",
      );
    }

    getDeviationData() {
      List<DeviationModel> list = [];
      List<String> deviationList = ["Paddy Field", "Water Logging", "River", "Farmers not allowing", "Other"];
      int id  = 1;
      for(var data in deviationList){
        list.add(DeviationModel(
          id: id.toString(),
          name: data.toString(),
        ));
        id++;
      }
      return list;
    }
}