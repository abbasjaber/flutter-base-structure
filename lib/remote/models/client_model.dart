class ClientModel {
  int? id;
  String? shopCode;
  String? boardName;
  int? vatNumber;
  String? neighborhood;
  String? ownerName;
  String? ownerPhone;
  String? managerName;
  String? managerPhone;
  String? shopDecoration;
  String? shopSalesClassification;
  String? latitude;
  String? longitude;
  String? regionName;
  String? cityName;
  String? subcityName;
  String? chainName;
  List<String>? crImage;
  List<String>? boardImage;

  ClientModel({
    this.id,
    this.shopCode,
    this.boardName,
    this.vatNumber,
    this.neighborhood,
    this.ownerName,
    this.ownerPhone,
    this.managerName,
    this.managerPhone,
    this.shopDecoration,
    this.shopSalesClassification,
    this.latitude,
    this.longitude,
    this.regionName,
    this.cityName,
    this.subcityName,
    this.chainName,
    this.crImage,
    this.boardImage,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      shopCode: json['shop_code'],
      boardName: json['board_name'],
      vatNumber: json['vat_number'],
      neighborhood: json['neighborhood'],
      ownerName: json['owner_name'],
      ownerPhone: json['owner_phone'],
      managerName: json['manager_name'],
      managerPhone: json['manager_phone'],
      shopDecoration: json['shop_decoration'],
      shopSalesClassification: json['shop_sales_classification'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      regionName: json['region_name'],
      cityName: json['city_name'],
      subcityName: json['subcity_name'],
      chainName: json['chain_name'],
      crImage:
          json['cr_image'] != null ? List<String>.from(json['cr_image']) : null,
      boardImage: json['board_image'] != null
          ? List<String>.from(json['board_image'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_code': shopCode,
      'board_name': boardName,
      'vat_number': vatNumber,
      'neighborhood': neighborhood,
      'owner_name': ownerName,
      'owner_phone': ownerPhone,
      'manager_name': managerName,
      'manager_phone': managerPhone,
      'shop_decoration': shopDecoration,
      'shop_sales_classification': shopSalesClassification,
      'latitude': latitude,
      'longitude': longitude,
      'region_name': regionName,
      'city_name': cityName,
      'subcity_name': subcityName,
      'chain_name': chainName,
      'cr_image': crImage,
      'board_image': boardImage,
    };
  }
}
