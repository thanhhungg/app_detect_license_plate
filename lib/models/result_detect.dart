class LicensePlateResult {
  String? label;
  double? confidence;
  String? timestamp;
  String? frame;

  LicensePlateResult({this.label, this.confidence, this.timestamp, this.frame});

  LicensePlateResult.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    confidence = json['confidence'];
    timestamp = json['timestamp'];
    frame = json['frame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['confidence'] = this.confidence;
    data['timestamp'] = this.timestamp;
    data['frame'] = this.frame;
    return data;
  }
}
