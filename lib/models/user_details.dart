class UserDetails {
  int? id;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? phoneVerifiedAt;
  String? dateOfBirth;
  String? avatar;
  int? challenge;
  String? fullname;
  int? category;
  String? bio;
  String? instagram;
  String? twitter;
  String? facebook;
  String? website;
  String? status;
  String? language;
  String? role;
  String? createdAt;
  List<Photos>? photos;
  UserDetails(
      {this.id,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.phoneVerifiedAt,
      this.dateOfBirth,
      this.avatar,
      this.challenge,
      this.fullname,
      this.category,
      this.bio,
      this.instagram,
      this.twitter,
      this.facebook,
      this.website,
      this.status,
      this.language,
      this.role,
      this.createdAt,
      this.photos});
  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    phoneVerifiedAt = json['phone_verified_at'];
    dateOfBirth = json['date_of_birth'];
    avatar = json['avatar'];
    challenge = json['challenge'];
    fullname = json['fullname'];
    category = json['category'];
    bio = json['bio'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    website = json['website'];
    status = json['status'];
    language = json['language'];
    role = json['role'];
    createdAt = json['created_at'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone'] = phone;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['date_of_birth'] = dateOfBirth;
    data['avatar'] = avatar;
    data['challenge'] = challenge;
    data['fullname'] = fullname;
    data['category'] = category;
    data['bio'] = bio;
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    data['facebook'] = facebook;
    data['website'] = website;
    data['status'] = status;
    data['language'] = language;
    data['role'] = role;
    data['created_at'] = createdAt;
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Photos {
  int? id;
  String? url;
  Photos({this.id, this.url});
  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
