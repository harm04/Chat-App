class Message {
  Message({
    required this.fromId,
    required this.read,
    required this.toId,
    required this.type,
    required this.message,
    required this.sent,
  });
  late final String fromId;
  late final String read;
  late final String toId;
  late final Type type;
  late final String message;
  late final String sent;
  
  Message.fromJson(Map<String, dynamic> json){
    fromId = json['from_Id'].toString();
    read = json['read'].toString();
    toId = json['to_Id'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
    message = json['message'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['from_Id'] = fromId;
    _data['read'] = read;
    _data['to_Id'] = toId;
    _data['type'] = type.name;
    _data['message'] = message;
    _data['sent'] = sent;
    return _data;
  }


}
  enum Type {text,image}