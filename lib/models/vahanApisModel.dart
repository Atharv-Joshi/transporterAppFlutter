import 'package:xml/xml.dart';

class VehicleDetails {
  String? statusMessage;
  String? registrationNumber;
  String? registrationDate;
  String? registrationValidUpto;
  String? ownerName;
  String? vehicleModel;
  String? vehicleMaker;
  String? vehicleFinancer;
  String? vehicleClass;
  String? bodyType;
  String? rcStatus;
  String? ownership;
  String? rcValidUpto;
  String? rcIssueDate;
  String? pollutionCertValidUpto;
  String? pollutionCertNo;
  String? insuranceValidUpto;
  String? insurancePolicyNo;
  String? permitType;
  String? permitNumber;
  String? permitValidUpto;
  String? permitIssueDate;
  String? seatCapacity;
  String? engineCapacity;
  String? fuelType;
  String? fuelNorms;
  String? vehicleColor;
  String? unloadedWeight;
  String? engineNumber;
  String? chassisNumber;
  String? registeredAuthority;
  String? taxValidUpto;

  VehicleDetails.fromXml(XmlElement element) {
    statusMessage = _getTextOrNA(element, 'stautsMessage');
    registrationNumber = _getTextOrNA(element, 'rc_regn_no');
    registrationDate = _getTextOrNA(element, 'rc_regn_dt');
    registrationValidUpto = _getTextOrNA(element, 'rc_regn_upto');
    ownerName = _getTextOrNA(element, 'rc_owner_name');
    vehicleModel = _getTextOrNA(element, 'rc_maker_model');
    vehicleMaker = _getTextOrNA(element, 'rc_maker_desc');
    vehicleFinancer = _getTextOrNA(element, 'rc_financer');
    vehicleClass = _getTextOrNA(element, 'rc_vh_class_desc');
    bodyType = _getTextOrNA(element, 'rc_body_type_desc');
    rcStatus = _getTextOrNA(element, 'rc_status');
    ownership = _getTextOrNA(element, 'rc_owner_cd');
    rcValidUpto = _getTextOrNA(element, 'rc_tax_upto');
    rcIssueDate = _getTextOrNA(element, 'rc_regn_dt');
    pollutionCertValidUpto = _getTextOrNA(element, 'rc_pucc_upto');
    pollutionCertNo = _getTextOrNA(element, 'rc_pucc_no');
    insuranceValidUpto = _getTextOrNA(element, 'rc_insurance_upto');
    insurancePolicyNo = _getTextOrNA(element, 'rc_insurance_policy_no');
    permitType = _getTextOrNA(element, 'rc_permit_type');
    permitNumber = _getTextOrNA(element, 'rc_permit_no');
    permitValidUpto = _getTextOrNA(element, 'rc_permit_valid_upto');
    permitIssueDate = _getTextOrNA(element, 'rc_permit_issue_dt');
    seatCapacity = _getTextOrNA(element, 'rc_seat_cap');
    engineCapacity = _getTextOrNA(element, 'rc_cubic_cap');
    fuelType = _getTextOrNA(element, 'rc_fuel_desc');
    fuelNorms = _getTextOrNA(element, 'rc_norms_desc');
    vehicleColor = _getTextOrNA(element, 'rc_color');
    unloadedWeight = _getTextOrNA(element, 'rc_unld_wt');
    engineNumber = _getTextOrNA(element, 'rc_eng_no');
    chassisNumber = _getTextOrNA(element, 'rc_chasi_no');
    registeredAuthority = _getTextOrNA(element, 'rc_registered_at');
    taxValidUpto = _getTextOrNA(element, 'rc_tax_upto');
  }

  String? _getTextOrNA(XmlElement element, String tagName) {
    final foundElement = element.findElements(tagName).first;
    return foundElement.text.isNotEmpty ? foundElement.text : 'NA';
  }
}
