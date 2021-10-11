class TruckFilterVariables {
  List truckTypeTextList = [
    'Open Body',
    'Flatbed',
    'Body Trailer',
    'Standard Container',
    'High Cube Container'
  ];

  List truckTypeValueList = [
    'OPEN_BODY',
    'FLATBED',
    'BODY_TRAILER',
    'STANDARD_CONTAINER',
    'HIGH_CUBE_CONTAINER'
  ];

  Map<String, List<int>> passingWeightList = {
    'OPEN_BODY': [7, 8, 9, 15, 16, 18, 19, 20, 21, 24, 25, 30],
    'FLATBED': [16, 21, 24, 30, 32, 33, 34, 40],
    'BODY_TRAILER': [
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42
    ],
    'STANDARD_CONTAINER': [6, 7, 9, 15, 18],
    'HIGH_CUBE_CONTAINER': [6, 7, 9, 15, 18],
  };

  Map<String, List<int>> totalTyresList = {
    'OPEN_BODY': [6, 8, 10, 12, 14, 16, 18, 20, 22],
    'FLATBED': [6, 8, 10, 12, 14, 16, 18, 20, 22],
    'BODY_TRAILER': [6, 8, 10, 12, 14, 16, 18, 20, 22],
    'STANDARD_CONTAINER': [6, 8, 10, 12, 14, 16, 18, 20, 22],
    'HIGH_CUBE_CONTAINER': [6, 8, 10, 12, 14, 16, 18, 20, 22],
  };

  Map<String, List<int>> truckLengthList = {
    'OPEN_BODY': [40, 10],
    'FLATBED': [10, 20, 50],
    'BODY_TRAILER': [20, 40],
    'STANDARD_CONTAINER': [10, 60],
    'HIGH_CUBE_CONTAINER': [40, 50, 60],
  };
}
