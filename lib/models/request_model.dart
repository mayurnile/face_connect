class RequestModel {
  final String requestID;
  final String senderID;
  final String senderName;
  final String senderProfilePicture;
  final String referenceImage;

  RequestModel({
    required this.requestID,
    required this.senderID,
    required this.senderName,
    required this.senderProfilePicture,
    required this.referenceImage,
  });

  factory RequestModel.fromJSON(Map<String, dynamic> data) => RequestModel(
        requestID: data["_id"] as String,
        senderID: data["sender"]["_id"] as String,
        senderName: data["sender"]["name"] as String,
        senderProfilePicture: data["sender"]["displayPicture"] as String,
        referenceImage: data["referenceImageURL"] as String,
      );
}
