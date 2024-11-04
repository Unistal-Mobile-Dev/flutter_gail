List<VendorModel> vendorListResponse(var json) {
  return List<VendorModel>.from(json.map((x) => VendorModel.fromJson(x)));
}

class VendorModel {

  dynamic id;
  String? name;
  String? code;

  VendorModel({
   this.name,
   this.id,
   this.code,
});

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      name: json['vendor_name'] ?? "",
      id: json ['id'] ?? "",
      code: json ['vendor_code'] ?? "",
    );
  }
}