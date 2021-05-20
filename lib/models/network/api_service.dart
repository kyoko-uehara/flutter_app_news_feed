import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';
// flutter packages pub run build_runner build

@ChopperApi()
abstract class ApiService extends ChopperService{

  static const Base_URL = "https://newsapi.org/v2";
  //fd
  static const API_KEY = "505f1f7f4b784d2d8792d5a0d7bf55";

  static ApiService create(){
    final client = ChopperClient(
      baseUrl: Base_URL,
      services: [
        _$ApiService()
      ],
      converter: JsonConverter(),
    );
    return _$ApiService(client);
  }

  @Get(path: "/top-headlines?")
  Future<Response> getHeadLines(
      {@Query("country") String country = "jp",
      @Query("pageSize") int pageSize = 10,
      @Query("apiKey") String apiKey = ApiService.API_KEY});

  @Get(path: "/top-headlines?")
  Future<Response> getKeywordNews(
      {@Query("country") String country = "jp",
      @Query("pageSize") int pageSize = 30,
      @Query("q") String keyword,
      @Query("apiKey") String apiKey = ApiService.API_KEY});

  @Get(path: "/top-headlines?")
  Future<Response> getCategoryNews(
      {@Query("country") String country = "jp",
        @Query("pageSize") int pageSize = 30,
        @Query("category") String category,
        @Query("apiKey") String apiKey = ApiService.API_KEY});
}
