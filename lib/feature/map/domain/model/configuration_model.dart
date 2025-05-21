class ConfigurationModel {

  dynamic buffer;
  dynamic timeInterval;

  ConfigurationModel({this.buffer, this.timeInterval});

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
     return ConfigurationModel(
        buffer: json['buffer'] ?? "",
        timeInterval: json['time_interval'] ?? "",
     );
  }

}