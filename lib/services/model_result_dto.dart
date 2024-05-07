class ModelResultDto {
  String? label;
  double? acc;
  String? modelPath;
  double? recall;
  int? isTrain;
  String? name;
  int? id;
  double? pre;
  double? f1score;

  ModelResultDto(
      {this.label,
      this.acc,
      this.modelPath,
      this.recall,
      this.isTrain,
      this.name,
      this.id,
      this.pre,
      this.f1score});

  ModelResultDto.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    acc = json['acc'];
    modelPath = json['modelPath'];
    recall = json['recall'];
    isTrain = json['isTrain'];
    name = json['name'];
    id = json['id'];
    pre = json['pre'];
    f1score = json['f1score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['acc'] = this.acc;
    data['modelPath'] = this.modelPath;
    data['recall'] = this.recall;
    data['isTrain'] = this.isTrain;
    data['name'] = this.name;
    data['id'] = this.id;
    data['pre'] = this.pre;
    data['f1score'] = this.f1score;
    return data;
  }
}
