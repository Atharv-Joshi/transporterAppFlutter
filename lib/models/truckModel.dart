class TruckModel {
  int? passingWeight;
  String? passingWeightString;
  int? tyres;
  String? tyresString;
  int? truckLength;
  String? truckLengthString;
  String? truckId;
  String? transporterId;
  String? truckNo;
  String? imei;
  String? driverId;
  String? truckType;
  String? driverName;
  String? driverNum;
  bool? truckApproved;

  TruckModel(
      {
        this.truckId,
        this.transporterId,
        this.truckNo,
        this.truckApproved,
        this.imei,
        this.passingWeight,
        this.truckLengthString,
        this.passingWeightString,
        this.tyresString,
        this.truckType,
        this.driverId,
        this.tyres,
        this.driverName,
        this.driverNum});
}
