class LoadScreenCardsModel {
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
  String? date;
  // int? tyres;

  LoadScreenCardsModel(
        {this.loadId,
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
        this.date,
        this.rate,
        this.unitValue,
        });
}
