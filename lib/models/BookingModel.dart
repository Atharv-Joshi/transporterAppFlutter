class BookingModel {
  //parameters
  String? bookingId;
  String? loadId;
  String? transporterId;
  String? postLoadId;
  List? truckId;
  String? rate;
  String? rateString;
  String? unitValue;
  bool? cancel;
  bool? completed;
  String? bookingDate;
  String? completedDate;

  BookingModel(
      {this.bookingId,
      this.loadId,
      this.transporterId,
      this.postLoadId,
      this.truckId,
      this.rate,
      this.unitValue,
      this.cancel,
      this.completed,
      this.bookingDate,
      this.completedDate,
      this.rateString
      });
}
