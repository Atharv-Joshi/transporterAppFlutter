class BiddingModel{
  //parameters
  String? bidId;
  String? transporterId;
  int? rate;
  String? unitValue;
  String? loadId;
  String? biddingDate;
  List? truckIdList;
  bool? transporterApproval;
  bool? shipperApproval;


  BiddingModel(
      {
        this.loadId,
        this.transporterId,
        this.unitValue,
        this.rate,
        this.biddingDate,
        this.bidId,
        this.shipperApproval,
        this.transporterApproval,
        this.truckIdList
      }
      );

//constructor
}