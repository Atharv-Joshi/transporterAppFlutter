class TollPlazaData {
  final String readerReadTime;
  final String tollPlazaGeocode;
  final String tollPlazaName;
  final String vehicleRegNo;

  TollPlazaData({
    required this.readerReadTime,
    required this.tollPlazaGeocode,
    required this.tollPlazaName,
    required this.vehicleRegNo,
  });

  factory TollPlazaData.fromJson(Map<String, dynamic> json) {
    return TollPlazaData(
      readerReadTime: json['readerReadTime'],
      tollPlazaGeocode: json['tollPlazaGeocode'],
      tollPlazaName: json['tollPlazaName'],
      vehicleRegNo: json['vehicleRegNo'],
    );
  }
}
