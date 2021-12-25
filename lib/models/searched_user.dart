class SearchedUser {
  final String id;
  final String name;
  final String profilePicture;
  final bool hasCriminalRecords;
  final bool isFriend;

  const SearchedUser({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.hasCriminalRecords,
    required this.isFriend,
  });

  factory SearchedUser.fromJSON(Map<String, dynamic> data) => SearchedUser(
        id: data["_id"] as String,
        name: data["name"] as String,
        profilePicture: data["displayPicture"] as String,
        hasCriminalRecords: data["hasCriminalRecords"] as bool,
        isFriend: data["isFriend"] as bool,
      );
}
