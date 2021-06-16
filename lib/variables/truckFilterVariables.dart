

class TruckFilterVariables{

  List truckTypeTextList = ['Open Half Body', 'Flatbed', 'Open Full Body',
    'Full Body Trailer', 'Half Body Trailer', 'Standard Container',
    'High-Cube Container'];

  List truckTypeValueList = ['OPEN_HALF_BODY' , 'FLATBED' , 'OPEN_FULL_BODY' , 'FULL_BODY_TRAILER' , 'HALF_BODY_TRAILER' , 'STANDARD_CONTAINER' , 'HIGH_CUBE_CONTAINER'];

  Map<String, List<int>> passingWeightList = {
    'OPEN_HALF_BODY': [6, 8, 12],
    'FLATBED': [12, 16, 30],
    'OPEN_FULL_BODY': [26, 28, 6, 24, 8],
    'FULL_BODY_TRAILER': [8, 12],
    'HALF_BODY_TRAILER': [16, 8, 28],
    'STANDARD_CONTAINER': [28, 30, 8, 16],
    'HIGH_CUBE_CONTAINER': [6, 8, 12, 26, 28],

  };

  Map<String, List<int>> totalTyresList = {
    'OPEN_HALF_BODY': [26,  12],
    'FLATBED': [6,  10],
    'OPEN_FULL_BODY': [10, 24, 16],
    'FULL_BODY_TRAILER': [18],
    'HALF_BODY_TRAILER': [16, 8, 6,],
    'STANDARD_CONTAINER': [8, 10],
    'HIGH_CUBE_CONTAINER': [ 8, 16],

  };

  Map<String, List<int>> truckLengthList = {
    'OPEN_HALF_BODY': [40, 10],
    'FLATBED': [10, 20, 50],
    'OPEN_FULL_BODY': [60],
    'FULL_BODY_TRAILER': [20, 40],
    'HALF_BODY_TRAILER': [20, 40, 50],
    'STANDARD_CONTAINER': [10, 60],
    'HIGH_CUBE_CONTAINER': [40, 50, 60],
  };
}