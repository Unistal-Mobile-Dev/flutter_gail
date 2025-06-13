List<CategoryModel> categoryListResponse(var json) {
   return List<CategoryModel>.from(json.map((x) => CategoryModel.fromJson(x)));
}

class CategoryModel {
   String? code;
   String? name;

   CategoryModel({this.name, this.code});

   factory CategoryModel.fromJson(Map<String, dynamic> json) {
      return CategoryModel(
        code: json['category_code'] ?? "",
        name: json['category_name'] ?? "",
      );
   }
}