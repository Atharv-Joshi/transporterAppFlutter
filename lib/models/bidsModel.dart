class BidsModel {
  String? bidId;
  String? transporterId;
  String? rate;
  String? unitValue;
  String? loadId;
  String? biddingDate;
  String? truckId;
  bool? shipperApproval;

  BidsModel(
      {this.bidId,
      this.transporterId,
      this.rate,
      this.unitValue,
      this.loadId,
      this.biddingDate,
      this.truckId,
      this.shipperApproval});
}
