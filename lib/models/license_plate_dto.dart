class LicensePlateDto {
  int? id;
  double? xMin;
  double? yMin;
  double? xMax;
  int? sampleId;
  double? yMax;

  LicensePlateDto(
      {this.id, this.xMin, this.yMin, this.xMax, this.sampleId, this.yMax});

  LicensePlateDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xMin = json['xMin'];
    yMin = json['yMin'];
    xMax = json['xMax'];
    sampleId = json['sample_id'];
    yMax = json['yMax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xMin'] = this.xMin;
    data['yMin'] = this.yMin;
    data['xMax'] = this.xMax;
    data['sample_id'] = this.sampleId;
    data['yMax'] = this.yMax;
    return data;
  }
}
