class Message {
  int id;
  String message;
  DateTime timeStamp;

  Message({
    required this.id,
    required this.message,
    required this.timeStamp,
  });
}

class CloudMessage {
  String id;
  String from;
  String to;
  DateTime timeStamp;
  String message;
  String? fileName;
  String? filePath;
  String? fileType;
  bool buffered;
  bool loading;

  CloudMessage({
    required this.id,
    required this.from,
    required this.to,
    required this.timeStamp,
    required this.message,
    this.fileName,
    this.filePath,
    this.fileType,
    this.buffered = false,
    this.loading = false,
  });

  factory CloudMessage.fromJson(Map<String, dynamic> json) {
    return CloudMessage(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(json['timeStamp']),
      message: json['message'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileType: json['fileType'],
    );
  }

  toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['to'] = to;
    data['from'] = from;
    data['timeStamp'] = timeStamp.millisecondsSinceEpoch;
    data['message'] = message;
    data['fileName'] = fileName;
    data['filePath'] = filePath;
    data['fileType'] = fileType;
    return data;
  }
}
