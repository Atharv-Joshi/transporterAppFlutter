class LoadApiModel {
  String? loadId;
  String? loadingPoint;
  String? loadingPointCity;
  String? loadingPointState;
  String? postLoadId;
  String? unloadingPoint;
  String? unloadingPointCity;
  String? unloadingPointState;
  String? productType;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  String? comment;
  String? status;
  int? rate;
  String? unitValue;
  String? loadDate;

  // int? tyres;

  LoadApiModel({
    this.loadId,
    this.loadingPoint,
    this.loadingPointCity,
    this.loadingPointState,
    this.postLoadId,
    this.unloadingPoint,
    this.unloadingPointCity,
    this.unloadingPointState,
    this.productType,
    this.truckType,
    this.noOfTrucks,
    this.weight,
    this.comment,
    this.status,
    // this.tyres,
    this.loadDate,
    this.rate,
    this.unitValue,
  });
}
