
#DimCarePatientDemographic
CREATE TABLE `pawait-ccai-test.EHR.DimCarePatientDemographic` (
  Pin INT64 OPTIONS(description="Medical Record Number, Primary key of the table and patient"),
  Pat_Sex STRING OPTIONS(description="Gender of the patient, F = Female, M= Male, U = unknown"),
  Pat_Marital_STS STRING OPTIONS(description="Marital status code"),
  Mat_Desc STRING OPTIONS(description="Marital status of the patient, U=Single, D=Divorced, W=Widow, R=Widower, N=NotApplicable, M=Married, E=Separated, C=Ms"),
  Pat_DOB DATETIME OPTIONS(description="Date of birth of the patient"),
  Eth_Code STRING OPTIONS(description="Ethnicity code"),
  Eth_Desc STRING OPTIONS(description="Ethnicity code description, MUS= Muslim, CHR= Christian"),
  Pat_RegIn_CD STRING OPTIONS(description="Religion code"),
  Pat_Rec_Add_DT DATETIME OPTIONS(description="Date of the record when entered in the system"),
  Pat_City STRING OPTIONS(description="Registered city of the patient"),
  Pat_Type STRING OPTIONS(description="Billing/payment mode of the patient CSH= Cash, CRD=Credit, CSE=CashEntitlement"),
  Pat_Age_Type STRING OPTIONS(description="Age group of the patient, D=Day, Y=Year"),
  Pat_Perm_State STRING OPTIONS(description="Permanent state of the patient"),
  Pat_Perm_City STRING OPTIONS(description="Permanent city of the patient"),
  Pat_Perm_Cntry STRING OPTIONS(description="Permanent country of the patient"),
  Hspt_Station STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  PRIMARY KEY (Pin) NOT ENFORCED
);

#DimCarePatientDetails
CREATE TABLE `pawait-ccai-test.EHR.DimCarePatientDetails` (
  PD_PRF_NUM INT64 OPTIONS(description="Unique number of specific patient encounter"),
  PD_OI_SEQ_NO INT64 OPTIONS(description="Specific lab/procedure code, associated with patient-specific hospital encounter"),
  PD_PACK_CD STRING OPTIONS(description="Specific lab package code, associated with patient-specific hospital encounter, e.g. 77 = Lipid profile, 569 = CBC"),
  PD_SAMPLE_FLG STRING OPTIONS(description="Sample drawn status flag, Y = Yes, N = No"),
  PH_ADMIN INT64 OPTIONS(description="Unique patient admission number"),
  PH_PIN_NO INT64 OPTIONS(description="Unique patient medical record number"),
  PH_AGE INT64 OPTIONS(description="Age of the patient"),
  PH_AGE_TYPE STRING OPTIONS(description="Diagnosis age classification, D = Day, Y = Year, M = Month"),
  PH_SEX STRING OPTIONS(description="Gender of the patient"),
  PH_REG_TYPE STRING OPTIONS(description="Registration Type e.g. AK = AKUH, EX = External"),
  PD_LOG_DTTM DATETIME OPTIONS(description="Datetime when the patient record is logged"),
  PD_SERVICE_DATE DATETIME OPTIONS(description="Datetime of the specific encounter of the patient"),
  PD_LABRAD_TARGET INT64 OPTIONS(description="Main hospital location code"),
  PD_LABRAD_SOURCE INT64 OPTIONS(description="Specific location code, main, secondary or outreach"),
  PD_SAMPLE_TYPE STRING OPTIONS(description="Sample type drawn from patient e.g. HEPARINE BLOOD, AUTOPSY"),
  HSPT_STATION STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  PRIMARY KEY (PD_PRF_NUM) NOT ENFORCED
);

#DimCareDiagnosisMaster
CREATE TABLE `pawait-ccai-test.EHR.DimCareDiagnosisMaster` (
  IcdCode STRING OPTIONS(description="WHO Icd Code of the Inpatient and Outpatient diagnosis"),
  IcdDesc STRING OPTIONS(description="Icd code description"),
  HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  PRIMARY KEY (IcdCode) NOT ENFORCED
);

#DimCareChargingDetails
CREATE TABLE `pawait-ccai-test.EHR.DimCareChargingDetails` (
  AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
  ChargingDatetime DATETIME OPTIONS(description="Datetime when the lab/procedure/pharmacy is charged"),
  InpatientOutPatient STRING OPTIONS(description="Type of patient, I = Inpatient, O = Outpatient"),
  ChargedItemDescription STRING OPTIONS(description="Description of lab/procedure/pharmacy conducted on specific patient under specific hospital encounter"),
  HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED
);

#DimCarePatientAdmission
CREATE TABLE `pawait-ccai-test.EHR.DimCarePatientAdmission` (
  AdmissionNo INT64 OPTIONS(description="Unique admission number of the inpatient"),
  AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
  AdmissionDate DATETIME OPTIONS(description="Date of the patient's admission"),
  AdmissionDatetime DATETIME OPTIONS(description="Datetime of the patient's admission"),
  AdmissionType STRING OPTIONS(description="Type of admission, E = Emergency, W = Walkin"),
  SuggestedDischargeDatetime DATETIME OPTIONS(description="Suggested discharge datetime"),
  DischargeDatetime DATETIME OPTIONS(description="Discharge datetime"),
  PatientRegistrationCity STRING OPTIONS(description="Registered city of the patient"),
  PatientRegistrationState STRING OPTIONS(description="Registered state of the patient"),
  CaseType STRING OPTIONS(description="Case type of the patient, M = Medical, S = Surgical"),
  DischargeReason STRING OPTIONS(description="Discharge reason"),
  CategoryType STRING OPTIONS(description="Category of the patient, GP = General Patient, PP = Private Patient"),
  HospitalLocation STRING OPTIONS(description="Location of the hospital"),
  PRIMARY KEY (AdmissionNo) NOT ENFORCED
  FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED
);

#FactCarePatientDiagnosis
CREATE TABLE `pawait-ccai-test.EHR.FactCarePatientDiagnosis` (
  AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
  IcdCode STRING OPTIONS(description="WHO Icd Code of the Inpatient and Outpatient diagnosis"),
  DiagnosisType STRING OPTIONS(description="Type of diagnosis, Primary or Secondary"),
  DiagnosisDateTime DATETIME OPTIONS(description="Datetime of the diagnosis"),
  DiagnosisAge INT64 OPTIONS(description="Diagnosis age"),
  DiagnosisAgeType STRING OPTIONS(description="Diagnosis age classification, D = Day, Y = Year, M = Month"),
  InPatientOutPatient STRING OPTIONS(description="Patient type flag, I = Inpatient, O = Outpatient"),
  AppointmentNoOrAdmissionNo STRING OPTIONS(description="Patient type schedule flag, AppointmentNo or AdmissionNo"),
  AppointmentNo INT64 OPTIONS(description="Unique appointment number of the outpatient"),
  AdmissionNo INT64 OPTIONS(description="Unique admission number of the inpatient"),
  AppointmentDateTime DATETIME OPTIONS(description="Datetime of the appointment"),
  Sex STRING OPTIONS(description="Gender of the patient, M = Male, F = Female"),
  HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED,
  FOREIGN KEY (IcdCode) REFERENCES EHR.DimCareDiagnosisMaster(IcdCode) NOT ENFORCED,
);

#DimCareOutpatientPharmacyDdetails
CREATE TABLE `pawait-ccai-test.EHR.DimCareOutpatientPharmacyDetails` (
  AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
  AppointmentNo INT64 OPTIONS(description="Unique appointment number on which specific drug order is made"),
  PrescribedItemCode STRING OPTIONS(description="Unique code of the specific item"),
  PrescribedItemQuantity STRING OPTIONS(description="Ordered quantity of the item"),
  PrescribedItemType STRING OPTIONS(description="Type of prescribed item, S=, D=, Y="),
  PrescriptionServeFlag STRING OPTIONS(description="Serve flag for prescription, A=, B=, P=, C="),
  AlternateDrugCode STRING OPTIONS(description="Alternate drug item code"),
  Remarks STRING OPTIONS(description="Remarks"),
  PrescribedDateTime DATETIME OPTIONS(description="Datetime when the drug order is made"),
  DrugUsageInstruction STRING OPTIONS(description="Instructions for consuming prescribed drugs"),
  PrescribedDrugDescription STRING OPTIONS(description="Prescribed item names"),
  MainLocationCode INT64 OPTIONS(description="Main hospital location code"),
  Age STRING OPTIONS(description="Age of the patient against whom drugs are prescribed"),
  SourceLocationCode INT64 OPTIONS(description="Specific location code, main, secondary or outreach"),
  ReceiptNo STRING OPTIONS(description="Billing receipt number of the drugs"),
  DrugType STRING OPTIONS(description="Type of drug, N=, A="),
  HospitalLocationtalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED
);

#DimCareInpatientPharmacyDdetails
CREATE TABLE `pawait-ccai-test.EHR.DimCareInpatientPharmacyDetails` (
  DateKey DATETIME OPTIONS(description="Date key"),
  AKNumber INT64 OPTIONS(description="Medical Record Number, Primary key of the table and patient"),
  OrderNo INT64 OPTIONS(description="Unique inpatient pharmacy order number"),
  OrderDatetime DATETIME OPTIONS(description="Inpatient pharmacy order datetime"),
  AppointmentNo INT64 OPTIONS(description="Unique appointment number"),
  AdmissionNo INT64 OPTIONS(description="Unique admission number"),
  OrderDescription STRING OPTIONS(description="Description of type of order, e.g. pharmacy"),
  OdPrsnType STRING OPTIONS(description="Order person type, D=, N="),
  DoctorRefernceType STRING OPTIONS(description="Doctor reference type, OT=Others, LO=AdmissionSource, AK=Internal Doctor, EX=External Doctor, SL=Self"),
  PatientRegistrationType STRING OPTIONS(description="Patient registration type, AK, EK"),
  DrugItemCode STRING OPTIONS(description="Unique code of the specific item"),
  DrugOrderedQunatity INT64 OPTIONS(description="Ordered quantity of the item"),
  OrderedPresecription STRING OPTIONS(description="Description of the item"),
  DrugIssueQunatity INT64 OPTIONS(description="Item issue quantity"),
  DrugStatus STRING OPTIONS(description="Drug status, D=, R=, E="),
  InvoiceNo STRING OPTIONS(description="Invoice number of the pharmacy order"),
  OrderedArea STRING OPTIONS(description="Hospital area code from where the order was made"),
  OrderAddDatetime DATETIME OPTIONS(description="Datetime when the order was entered"),
  MainLocationCode INT64 OPTIONS(description="Main hospital location code"),
  SourceLocationCode INT64 OPTIONS(description="Specific location code, main, secondary or outreach"),
  DrugUsageInstruction STRING OPTIONS(description="Instructions of drug usage"),
  HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa"),
  FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED
);

#DimLabMaster
CREATE TABLE `pawait-ccai-test.EHR.DimLabMaster` (
    ProcedureOiCode STRING OPTIONS(description="Procedure billing class code e.g. STN= Standard"),
    ProcedureSequenceNumber INT64 OPTIONS(description="Specific lab identifier, e.g. 45592=MIGORI - XR SKULL 4 VIEWS"),
    ProcedureSequenceDescription STRING OPTIONS(description="Name of the Lab/procedure/radiology, e.g. COXSACKIE 1GG ANTIBODY"),
    ProcedureDepartment STRING OPTIONS(description="Department code of the conducted procedure, e.g. SUR=Surgical, RAD=Radiology"),
    ProcedureType STRING OPTIONS(description="Type of procedure, e.g. P=Profile, K=Package, S=Services etc"),
    ProcedureGroupDescription STRING OPTIONS(description="Small detail of the procedure e.g. Neonatal Services, SKIN INTEGUMENTARY SYSTEM AND BREAST"),
    HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient e.g. NRB = Nairobi, MSA = Mombasa"),
    PRIMARY KEY (ProcedureOiCode) NOT ENFORCED
);

#DimCareObstetricHistory
CREATE TABLE `pawait-ccai-test.EHR.DimCareObstetricHistory` (
    RadiologyOrderNo INT64 OPTIONS(description="Unique identifier of specific lab against specific patient"),
    RadiologyOrderCode INT64 OPTIONS(description="Specific lab/procedure/radiology identifier"),
    Category STRING OPTIONS(description="Derived column to identify the type of radiology report"),
    AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
    DateOfBirth DATETIME OPTIONS(description="Date of birth"),
    AccessionNo INT64 OPTIONS(description="Accession number"),
    ReferralLocation STRING OPTIONS(description="Referral location"),
    Examination STRING OPTIONS(description="Radiology report notes"),
    DateOfExam STRING OPTIONS(description="Date of examination"),
    ClinicalInformation STRING OPTIONS(description="Radiology report notes"),
    Findings STRING OPTIONS(description="Radiology report notes"),
    MoreFindings STRING OPTIONS(description="Radiology report notes"),
    HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient e.g. NRB = Nairobi, MSA = Mombasa"),
    PRIMARY KEY (RadiologyOrderNo) NOT ENFORCED,
    FOREIGN KEY (AKNumber) REFERENCES EHR.DimCarePatientDemographic(AKNumber) NOT ENFORCED
);

#FactCareLabResults
CREATE TABLE `pawait-ccai-test.EHR.FactCareLabResults` (
  LabOrderID INT64 OPTIONS(description="Unique identifier of specific lab against specific patient"),
  DateKey INT64 OPTIONS(description="Foreign key with the date dimension"),
  LabCode INT64 OPTIONS(description="Specific lab identifier, e.g. 77 = HDL Cholesterol"),
  LabParameterCode INT64 OPTIONS(description="Specific lab parameter code, e.g. 69 = WBC Cholesterol"),
  DepartmentCode STRING OPTIONS(description="Lab department code, e.g. CT, MM, PG, HM"),
  LabPackageCode STRING OPTIONS(description="Specific lab package code, e.g. 569 = CBC, 77 = Lipid Profile"),
  LabResult FLOAT64 OPTIONS(description="Result of a specific lab"), 
  LabResultChar STRING OPTIONS(description="Lab result remarks, e.g. Negative, Absent, <3.00, Soft"),
  ResultAddDateTime DATETIME OPTIONS(description="Result datetime of the specific lab"),
  AccountNo INT64 OPTIONS(description="Specific account number for the specific lab"),
  SampleType STRING OPTIONS(description="Type of sample, e.g. Serum SST, EDTA, CSF, Nasal Swab, EDTA+Marrow"),
  ResultComment STRING OPTIONS(description="Any lab result description, e.g. A low bicarbonate level may therefore be attributed to this preanalytical factor and caution should be taken when interpreting the result."),
  NormalRange STRING OPTIONS(description="Normal range scale of a specific lab"),
  ResultStatus STRING OPTIONS(description="Status of the lab result, C = Complete, P = Processing"),
  HospitalLocation STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa")
);


CREATE TABLE `pawait-ccai-test.EHR.DimCareRadiologyHistory` (
  IrPrfNum INT64 OPTIONS(description="Unique identifier of specific lab against specific patient"),
  IrOiSeqNo INT64 OPTIONS(description="Specific lab/procedure/radiology identifier"),
  Category STRING OPTIONS(description="Derived column to identify the type of radiology report"),
  AKNumber INT64 OPTIONS(description="Medical Record Number, Foreign key of the table and patient"),
  DateOfBirth DATETIME OPTIONS(description="Patient's date of birth"),
  AccessionNo INT64 OPTIONS(description="Accession number"),
  ReferralLocation STRING OPTIONS(description="Location name, e.g. ANTENATAL CLINIC"),
  Examination STRING OPTIONS(description="Radiology report notes"),
  DateOfExam DATETIME OPTIONS(description="Date and time when the scan is performed"),
  ClinicalInformation STRING OPTIONS(description="Radiology report notes"),
  Findings STRING OPTIONS(description="Radiology report notes"),
  MoreFindings STRING OPTIONS(description="Radiology report notes"),
  Conclusion STRING OPTIONS(description="Radiology report notes"),
  Reportstatus STRING OPTIONS(description="Status of the report, e.g. Validated"),
  HSPT STRING OPTIONS(description="Registered Hospital Location of the patient, NRB = Nairobi, MSA = Mombasa")
);
