List<SubCategoryModel> subCategoryListResponse(var json) {
   return List<SubCategoryModel>.from(json.map((x) => SubCategoryModel.fromJson(x)));
}

class SubCategoryModel {

  String? code;
  String? name;

  SubCategoryModel({this.name, this.code});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
     return SubCategoryModel(
       name: json['sub_category_name'] ?? "",
       code: json['sub_category_code'] ?? "",
     );
  }

}