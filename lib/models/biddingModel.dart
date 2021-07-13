class BiddingModel{
  //parameters
  String? bidId;
  String? transporterId;
  String? currentBid;
  String? previousBid;
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
        this.currentBid,
        this.previousBid,
        this.biddingDate,
        this.bidId,
        this.shipperApproval,
        this.transporterApproval,
        this.truckIdList
      }
      );

//constructor
}