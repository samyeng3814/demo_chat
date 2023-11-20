class MessageModel {
  String type;
  String message;
  String sendName;
  String userID;
  MessageModel(
      {required this.message,
      required this.type,
      required this.sendName,
      required this.userID});
}
