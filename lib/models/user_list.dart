class UserList {
  List<Users>? users;
  UserList({this.users});
  UserList.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? fullname;
  String? avatar;
  int? category;
  Users({this.id, this.fullname, this.avatar, this.category});
  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    avatar = json['avatar'];
    category = json['category'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullname'] = fullname;
    data['avatar'] = avatar;
    data['category'] = category;
    return data;
  }
}
