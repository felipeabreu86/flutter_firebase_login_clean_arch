import 'package:dio/dio.dart';
import 'package:flutter_delivery_app_clean_arch/src/core/utils/constants.dart';
import 'package:flutter_delivery_app_clean_arch/src/data/models/via_cep_response_model.dart';
import 'package:retrofit/retrofit.dart';

// run: flutter packages pub run build_runner build --delete-conflicting-outputs
// watch: flutter packages pub run build_runner watch
part 'via_cep_service.g.dart';

@RestApi(baseUrl: kViaCepUrl)
abstract class ViaCepService {
  factory ViaCepService(Dio dio, {String baseUrl}) = _ViaCepService;

  @GET('/{cep}/json')
  Future<HttpResponse<ViaCepResponseModel>> getAddress(@Path("cep") String cep);
}
