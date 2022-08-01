import 'package:flutter_test/flutter_test.dart';
import 'package:my_dog_app_final/models/favorite_image.dart' hide Image,imageFromJson ;
import 'package:my_dog_app_final/models/image_model.dart' hide Breeds;
import 'package:my_dog_app_final/models/breed_model.dart' hide Image,imageFromJson;
import 'package:my_dog_app_final/models/vote_model.dart';
import 'package:my_dog_app_final/services/network_service.dart';
void main() {
  // API_LIST_BREADS
  group("Test: Breed Category in Server", () {
    String? response;
    test("test1: check network: one element", () async {
      response = await NetworkService.GET(
          "${NetworkService.API_LIST_BREADS}/1", NetworkService.paramsEmpty());
      expect(response, isNotNull);
    });

    test("test2: check model", () {
      Breed breed = breedFromJson(response!);
      expect(breed.id, 1);
    });

    test("test3: check network: list", () async {
      response = await NetworkService.GET(
          NetworkService.API_LIST_BREADS, NetworkService.paramsEmpty());
      expect(response, isNotNull);
    });

    test("test4: check model list", () async {
      List<Breed> breedList = breedListFromJson(response!);
      expect(breedList, isList);
    });
  });

  // API_LIST_VOTES
  group("Test: Votes", () {
    String? response;
    test("test1: get all votes", () async {
      response = await NetworkService.GET(
          NetworkService.API_LIST_VOTES, NetworkService.paramsVotesList());
      expect(response, isNotNull);
    });

    List<Vote> votes;
    late String id;
    test("test2: parsing votes", () {
      votes = voteListFromJson(response!);
      id = votes.first.id.toString();
      expect(votes, isList);
    });

    String? responseOne;
    test("test3: get one vote", () async {
      responseOne = await NetworkService.GET(
          NetworkService.API_ONE_VOTE + id, NetworkService.paramsEmpty());
      expect(responseOne, isNotNull);
    });

    Vote? vote;
    test("test4: parsing one vote", () {
      vote = voteFromJson(responseOne!);
      expect(vote is Vote, true);
    });

    String? responseCreate;
    test("test5: create new vote", () async {
      responseCreate = await NetworkService.POST(
          NetworkService.API_LIST_VOTES,
          NetworkService.paramsEmpty(),
          NetworkService.bodyVotes("LmGFTdAev", "subIdOne", 1));
      expect(responseCreate, isNotNull);
    });

    String? responseDelete;
    test("test6: delete my old vote", () async {
      responseDelete = await NetworkService.DELETE(
          "${NetworkService.API_ONE_VOTE}104077", NetworkService.paramsEmpty());
      expect(responseDelete is String, true);
    });
  });

  // API_IMAGE
  group("Test: Images", () {
    // String? resAllImages;
    // test("test1: get all images", () async {
    //   resAllImages = await NetworkService.GET(NetworkService.API_IMAGE_LIST, NetworkService.paramsImageSearch(size: "small"));
    //   expect(resAllImages, isNotNull);
    // });
    //
    // List<Image>? imageList;
    // test("test2: parsing images", () {
    //   imageList = imageListFromJson(resAllImages!);
    //   expect(imageList!.isNotEmpty, isTrue);
    // });
    //
    // String? resUploadImg;
    // test("test3: upload images", () async {
    //   resUploadImg = await NetworkService.MULTIPART(NetworkService.API_IMAGE_UPLOAD, "assets/images/alabay.jpeg", NetworkService.bodyImageUpload("this-alabay"));
    //   expect(resUploadImg, isNotNull);
    // });
    //
    // String? resGetMyImage;
    // test("test4: get my image", () async {
    //   resGetMyImage = await NetworkService.GET(NetworkService.API_MY_IMAGES, NetworkService.paramsMyImage());
    //   expect(resGetMyImage, isNotNull);
    // });

    String? oneImageResponse;
    test("test5: get one image", () async {
      oneImageResponse = await NetworkService.GET(
          "${NetworkService.API_ONE_IMAGE}SJZIJgqEX",
          NetworkService.paramsEmpty());
      expect(oneImageResponse, isNotNull);
    });

    test("test6: parse one image", () {
      Image image = imageFromJson(oneImageResponse!);
      expect(image.url, isNotNull);
    });
  });

  // API_FAVORITE
  group("Test: Favorite", () {
    // String? responseFavorite;
    // test("test1: create favorite", () async {
    //   responseFavorite = await NetworkService.POST(NetworkService.API_MY_FAVORITE, NetworkService.paramsEmpty(), NetworkService.bodyFavourite("4yghDUdnE"));
    //   if (kDebugMode) {
    //     print(responseFavorite);
    //   }
    //   expect(responseFavorite, isNotNull);
    // });
    //
    // test("test2: delete favorite", () async {
    //   responseFavorite = await NetworkService.DELETE("${NetworkService.API_FAVORITE_DELETE}49913", NetworkService.paramsEmpty());
    //   if (kDebugMode) {
    //     print(responseFavorite);
    //   }
    //   expect(responseFavorite, isNotNull);
    // });

    String? allFavorite;
    test("test3: get my favorite", () async {
      allFavorite = await NetworkService.GET(
          NetworkService.API_MY_FAVORITE, NetworkService.paramsVotesList());
      expect(allFavorite, isNotNull);
    });

    test("test4", () async {
      List<Favorite> list = favoriteListFromJson(allFavorite!);
      expect(list, isNotEmpty);
    });
  });
}
