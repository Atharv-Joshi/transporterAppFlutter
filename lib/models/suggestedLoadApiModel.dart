class SuggestLoadApiDataModel {
  String id;
  dynamic ownerId;
  String loadingPointCity;
  String loadingPointState;
  String unloadingPointCity;
  String unloadingPointState;
  String productType;
  String truckType;
  String noOfTrucks;
  String weight;
  String comment;
  String status;

  SuggestLoadApiDataModel({
    required this.id,
    required this.ownerId,
    required this.loadingPointCity,
    required this.loadingPointState,
    required this.unloadingPointState,
    required this.unloadingPointCity,
    required this.productType,
    required this.truckType,
    required this.noOfTrucks,
    required this.weight,
    required this.comment,
    required this.status,
  });
}