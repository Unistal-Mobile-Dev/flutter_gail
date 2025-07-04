class TlpConnectionModel {

  dynamic id;
  String? name;

  TlpConnectionModel({this.id, this.name});

  getFullData() {
    List<TlpConnectionModel> tlpConnectionList = [];
    List<String> list = ['A','B','C','D','E','F','H','I','J','K','L','M','N','O','P','Q'];
    int id = 1;
    for(var data in list){
      tlpConnectionList.add(
          TlpConnectionModel(
              id: id.toString(),
              name: data.toString()
          )
      );
      id++;
    }
    return tlpConnectionList;
  }

  getShortData() {
    List<TlpConnectionModel> tlpConnectionList = [];
    List<String> list = ['A','B','C','D','E','F','H','I','J','K','L','M','N','O'];
    int id = 1;
    for(var data in list){
      tlpConnectionList.add(
          TlpConnectionModel(
              id: id.toString(),
              name: data.toString()
          )
      );
      id++;
    }
    return tlpConnectionList;
  }
}