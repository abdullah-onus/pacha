class ChallengeDetails {
  int? id;
  String? name;
  String? role;
  String? startDate;
  String? endDate;
  int? timezone;
  String? city;
  String? country;
  String? bannerImage;
  String? appbarImage;
  int? appbarLogoColor;
  int? appbarMenuColor;
  String? homepageUrl;
  int? mapDefaultZoom;
  int? mapMaxZoom;
  int? mapMinZoom;
  double? mapCenterLongitude;
  double? mapCenterLatitude;
  double? mapNorthwestLongitude;
  double? mapNorthwestLatitude;
  double? mapSoutheastLongitude;
  double? mapSoutheastLatitude;
  String? overlayImage;
  double? overlayNorthwestLongitude;
  double? overlayNorthwestLatitude;
  double? overlaySoutheastLongitude;
  double? overlaySoutheastLatitude;
  String? status;
  String? createdAt;
  ChallengeDetails(
      {this.id,
      this.name,
      this.role,
      this.startDate,
      this.endDate,
      this.timezone,
      this.city,
      this.country,
      this.bannerImage,
      this.appbarImage,
      this.appbarLogoColor,
      this.appbarMenuColor,
      this.homepageUrl,
      this.mapDefaultZoom,
      this.mapMaxZoom,
      this.mapMinZoom,
      this.mapCenterLongitude,
      this.mapCenterLatitude,
      this.mapNorthwestLongitude,
      this.mapNorthwestLatitude,
      this.mapSoutheastLongitude,
      this.mapSoutheastLatitude,
      this.overlayImage,
      this.overlayNorthwestLongitude,
      this.overlayNorthwestLatitude,
      this.overlaySoutheastLongitude,
      this.overlaySoutheastLatitude,
      this.status,
      this.createdAt});
  ChallengeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    timezone = json['timezone'];
    city = json['city'];
    country = json['country'];
    bannerImage = json['banner_image'];
    appbarImage = json['appbar_image'];
    appbarLogoColor = json['appbar_logo_color'];
    appbarMenuColor = json['appbar_menu_color'];
    homepageUrl = json['homepage_url'];
    mapDefaultZoom = json['map_default_zoom'];
    mapMaxZoom = json['map_max_zoom'];
    mapMinZoom = json['map_min_zoom'];
    mapCenterLongitude = json['map_center_longitude'];
    mapCenterLatitude = json['map_center_latitude'];
    mapNorthwestLongitude = json['map_northwest_longitude'];
    mapNorthwestLatitude = json['map_northwest_latitude'];
    mapSoutheastLongitude = json['map_southeast_longitude'];
    mapSoutheastLatitude = json['map_southeast_latitude'];
    overlayImage = json['overlay_image'];
    overlayNorthwestLongitude = json['overlay_northwest_longitude'];
    overlayNorthwestLatitude = json['overlay_northwest_latitude'];
    overlaySoutheastLongitude = json['overlay_southeast_longitude'];
    overlaySoutheastLatitude = json['overlay_southeast_latitude'];
    status = json['status'];
    createdAt = json['created_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['role'] = role;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['timezone'] = timezone;
    data['city'] = city;
    data['country'] = country;
    data['banner_image'] = bannerImage;
    data['appbar_image'] = appbarImage;
    data['appbar_logo_color'] = appbarLogoColor;
    data['appbar_menu_color'] = appbarMenuColor;
    data['homepage_url'] = homepageUrl;
    data['map_default_zoom'] = mapDefaultZoom;
    data['map_max_zoom'] = mapMaxZoom;
    data['map_min_zoom'] = mapMinZoom;
    data['map_center_longitude'] = mapCenterLongitude;
    data['map_center_latitude'] = mapCenterLatitude;
    data['map_northwest_longitude'] = mapNorthwestLongitude;
    data['map_northwest_latitude'] = mapNorthwestLatitude;
    data['map_southeast_longitude'] = mapSoutheastLongitude;
    data['map_southeast_latitude'] = mapSoutheastLatitude;
    data['overlay_image'] = overlayImage;
    data['overlay_northwest_longitude'] = overlayNorthwestLongitude;
    data['overlay_northwest_latitude'] = overlayNorthwestLatitude;
    data['overlay_southeast_longitude'] = overlaySoutheastLongitude;
    data['overlay_southeast_latitude'] = overlaySoutheastLatitude;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
