import 'license_plate_dto.dart';

class SampleDto {
  String? name;
  String? imagePath;
  String? create;
  int? id;
  List<LicensePlateDto>? licensePlate;

  SampleDto(
      {this.name, this.imagePath, this.create, this.id, this.licensePlate});

  SampleDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imagePath = json['imagePath'];
    create = json['create'];
    id = json['id'];
    if (json['licensePlate'] != null) {
      licensePlate = <LicensePlateDto>[];
      json['licensePlate'].forEach((v) {
        licensePlate!.add(new LicensePlateDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    data['create'] = this.create;
    data['id'] = this.id;
    if (this.licensePlate != null) {
      data['licensePlate'] = this.licensePlate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
