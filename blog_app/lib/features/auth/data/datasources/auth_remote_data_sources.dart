import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSources {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourcesImp implements AuthRemoteDataSources {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourcesImp(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async{
    try{
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email
        );
        if(response.user == null){
          throw const ServerException('User is null');
        }
        return UserModel.fromJson(response.user!.toJson());
    } catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
          },
      );
      if (response.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
