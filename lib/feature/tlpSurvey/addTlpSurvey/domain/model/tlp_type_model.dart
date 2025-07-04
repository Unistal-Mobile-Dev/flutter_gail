class TlpTypeModel {

  dynamic id;
  String? name;

  TlpTypeModel({this.id, this.name});

  getData() {
    List<TlpTypeModel> tlpTypeList = [];
     List<String> list = ['A','B','C','D','E','F','H','I','J','K','L','M','N','O','P','Q'];
     int id = 1;
     for(var data in list){
       tlpTypeList.add(
         TlpTypeModel(
           id: id.toString(),
           name: data.toString()
         )
       );
       id++;
     }
    return tlpTypeList;
  }
}