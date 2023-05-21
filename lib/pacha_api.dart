    import 'dart:convert';
    import 'package:flutter/widgets.dart';
    import 'package:http/http.dart' as http;
    import 'package:pacha/globals.dart';

    class PaChaAPI {
      static String? _token;
      final String _domain = 'ur3d6016i4.execute-api.us-east-1.amazonaws.com';
      final int _version = 1;
      static const commErrorResponse = {
        'code': -1,
        'json': {
          'code': -1,
          'json': {
            'error': [
              {'code': 'comm', 'message': 'Communication Error.'}
            ]
          }
        }
      };
      String? get getToken {
        return _token;
      }

      set setToken(String token) {
        _token = token;
      }

      String getAPIURL({List<String>? resources, Map<String, String>? parameters}) {
        resources = resources ?? [];
        parameters = parameters ?? {};
        parameters.updateAll((key, value) => Uri.encodeFull(value));
        String queryStr = parameters.isEmpty ? '' : '?';
        parameters.forEach((key, value) {
          queryStr += (queryStr == '?' ? '' : '&') + '$key=$value';
        });
        return 'https://$_domain/v$_version/${resources.join('/')}$queryStr';
      }

      Uri getAPIURI({List<String>? resources, Map<String, String>? parameters}) {
        debugPrint('${Uri.parse(getAPIURL(resources: resources, parameters: parameters))}');
        return Uri.parse(getAPIURL(resources: resources, parameters: parameters));
      }

      Future<dynamic> get({List<String>? resources, Map<String, String>? parameters, Map<String, String>? headers}) async {
        headers = headers ?? {};
        if (_token != null) headers = {...headers, 'x-amz-security-token': _token!};
        dynamic response;
        await http.get(getAPIURI(resources: resources, parameters: parameters), headers: headers).then((value) => response = value).onError((error, stackTrace) {
          return Future.error(commErrorResponse);
        });
        if (response.statusCode == 200) {
          _token = response.headers['x-amz-security-token'];
          return Future.value({'code': response.statusCode, 'json': jsonDecode(response.body)});
        }
        return Future.error({'code': response.statusCode, 'json': jsonDecode(response.body)});
      }

      Future<dynamic> post({List<String>? resources, Map<String, String>? parameters, Map<String, String>? headers, Object? body}) async {
        headers = headers ?? {};
        if (_token != null) headers = {...headers, 'x-amz-security-token': _token!};
        dynamic response;
        await http
            .post(getAPIURI(resources: resources, parameters: parameters), headers: headers, body: jsonEncode(body))
            .then((value) => response = value)
            .onError((error, stackTrace) {
          return Future.error(commErrorResponse);
        });
        if (response.statusCode == 200) {
          _token = response.headers['x-amz-security-token'];
          return Future.value({'code': response.statusCode, 'json': jsonDecode(response.body)});
        }
        return Future.error({'code': response.statusCode, 'json': jsonDecode(response.body)});
      }

      Future<dynamic> delete({List<String>? resources, Map<String, String>? parameters, Map<String, String>? headers}) async {
        headers = headers ?? {};
        if (_token != null) headers = {...headers, 'x-amz-security-token': _token!};
        dynamic response;
        await http.delete(getAPIURI(resources: resources, parameters: parameters), headers: headers).then((value) => response = value).onError((error, stackTrace) {
          return Future.error(commErrorResponse);
        });
        if (response.statusCode == 200) {
          _token = response.headers['x-amz-security-token'];
          return Future.value({'code': response.statusCode, 'json': jsonDecode(response.body)});
        }
        return Future.error({'code': response.statusCode, 'json': jsonDecode(response.body)});
      }

      Future<dynamic> userLogin(String account, String password) async {
        return get(resources: ['user', 'login'], parameters: {'account': account, 'password': password});
      }

      Future<dynamic> userLogout() async {
        return get(resources: ['user', 'logout']);
      }

      Future<dynamic> userSearch(String email) async {
        return get(resources: ['password', 'user'], parameters: {'email': email});
      }

      Future<dynamic> userGet(int id) async {
        return get(resources: ['user', 'get'], parameters: {'id': '$id'});
      }

      Future<dynamic> userList({required int challenge, String? name, int? category}) async {
        var parameters = {'challenge': '$challenge'};
        if (name != null) parameters['name'] = name;
        if (category != null) parameters['category'] = '$category';
        return get(resources: ['user', 'list'], parameters: parameters);
      }

      Future<dynamic> userSignup(
          {required int category,
          required String fullname,
          required String email,
          required String password1,
          required String password2,
          required String birthday,
          required String language}) async {
        dynamic body = {
          "category": category,
          "fullname": fullname,
          "email": email,
          "password": {"password1": password1, "password2": password2},
          "birthday": birthday,
          "language": language
        };
        return post(resources: ['signup', 'signup'], body: body);
      }

      Future<dynamic> signUpVerificationCheck(int id, String code) async {
        return get(resources: ['signup', 'verification', 'check'], parameters: {'code': code, 'id': '$id'});
      }

      Future<dynamic> signUpVerificationResend(int id) async {
        return get(resources: ['signup', 'verification', 'new'], parameters: {'id': '$id'});
      }

      Future<dynamic> challengeList() async {
        return get(resources: ['challenge', 'list']);
      }

      Future<dynamic> challengeGet(int id) async {
        return get(resources: ['challenge', 'get'], parameters: {'id': '$id'});
      }

      Future<dynamic> userScoreList({String? startDate, String? endDate, int? event, int? category, required int challengeId}) async {
        var parameters = {'challenge': '$challengeId'};
        if (startDate != null) parameters['start'] = startDate;
        if (endDate != null) parameters['end'] = endDate;
        if (event != null) parameters['event'] = '$event';
        if (category != null) parameters['category'] = '$category';
        return get(resources: ['score', 'board'], parameters: parameters);
      }

      Future<dynamic> eventGet(int id) async {
        return get(resources: ['event', 'get'], parameters: {'id': '$id'});
      }

      Future<dynamic> eventList() async {
        return get(resources: ['event', 'list']);
      }

      Future<dynamic> passwordChange(int id, String code, String new1, String new2) async {
        return get(resources: ['password', 'reset'], parameters: {'id': '$id', 'code': code, 'new1': new1, 'new2': new2});
      }

      Future<dynamic> passwordVerificationCheck(int id, String code) async {
        return get(resources: ['password', 'verification', 'check'], parameters: {'id': '$id', 'code': code});
      }

      // forgot password icin
      Future<dynamic> passwordVerificationResend(int id) async {
        return get(resources: ['password', 'verification', 'new'], parameters: {'id': '$id'});
      }

      Future<dynamic> userPasswordChange(String old, String new1, String new2) async {
        return get(resources: ['user', 'password'], parameters: {'old': old, 'new1': new1, 'new2': new2});
      }

      Future<dynamic> photoOrder(int id, int index) async {
        return post(resources: ['photo', 'order'], body: {id: id, index: index});
      }

      Future<dynamic> photoDelete(int id) async {
        return delete(resources: ['photo', 'delete'], parameters: {'id': '$id'});
      }

      Future<dynamic> userSet({String? fullname, String? bio, String? instagram, String? twitter, String? facebook, String? website}) async {
        dynamic body = {
          "fullname": fullname,
          "bio": bio,
          "instagram": instagram,
          "twitter": twitter,
          "facebook": facebook,
          "website": website,
        };
        return post(resources: ['user', 'set'], body: body);
      }

      Future<dynamic> challengeFeed({String? language, String? timestamp, int? limit, String? direction}) async {
        var parameters = {'language': Globals.user!.language!};
        if (timestamp != null) parameters['timestamp'] = timestamp;
        if (limit != null) parameters['limit'] = '$limit';
        if (direction != null) parameters['direction'] = direction;
        return get(resources: ['challenge', 'feed'], parameters: parameters);
      }
    }
