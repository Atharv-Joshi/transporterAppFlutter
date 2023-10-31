// class DLDetails {
//   final List<DLCOV>? dlCovs;
//   final DLObj? dlObj;
//   final BioImgObj? bioImgObj;
//
//   DLDetails({
//     this.dlCovs,
//     this.dlObj,
//     this.bioImgObj,
//   });
//
//   factory DLDetails.fromJson(Map<String, dynamic> json) {
//     return DLDetails(
//       dlCovs: (json['dlcovs'] as List)
//           .map((cov) => DLCOV.fromJson(cov))
//           .toList(),
//       dlObj: DLObj.fromJson(json['dlobj']),
//       bioImgObj: BioImgObj.fromJson(json['bioImgObj']),
//     );
//   }
// }
//
// class DLCOV {
//   final String? covdesc;
//
//   DLCOV({ this.covdesc});
//
//   factory DLCOV.fromJson(Map<String, dynamic> json) {
//     return DLCOV(covdesc: json['covdesc']);
//   }
// }
//
// class DLObj {
//   final String? dlLicno;
//   final String? dlStatus;
//   final String? bioFullName;
//   final String? dlIssuedt;
//   final String? dlNtValdtoDt;
//   final String? dlNtValdfrDt;
//   final String? omRtoFullname;
//   final String? dlRtoCode;
//
//   DLObj({
//     this.dlLicno,
//     this.dlStatus,
//     this.bioFullName,
//     this.dlIssuedt,
//     this.dlNtValdtoDt,
//     this.dlNtValdfrDt,
//     this.omRtoFullname,
//     this.dlRtoCode,
//   });
//
//   factory DLObj.fromJson(Map<String, dynamic> json) {
//     return DLObj(
//       dlLicno: json['dlLicno'],
//       dlStatus: json['dlStatus'],
//       bioFullName: json['bioFullName'],
//       dlIssuedt: json['dlIssuedt'],
//       dlNtValdtoDt: json['dlNtValdtoDt'],
//       dlNtValdfrDt: json['dlNtValdfrDt'],
//       omRtoFullname: json['omRtoFullname'],
//       dlRtoCode: json['dlRtoCode'],
//     );
//   }
// }
//
// class BioImgObj {
//   final String? biPhoto;
//
//   BioImgObj({ this.biPhoto});
//
//   factory BioImgObj.fromJson(Map<String, dynamic> json) {
//     return BioImgObj(biPhoto: json['biPhoto']);
//   }
// }
