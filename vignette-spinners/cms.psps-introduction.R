#'---
#'title: "Introduction to the cms.PSPS Package"
#'author: Peter DeWitt
#'output: rmarkdown::html_vignette
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE)

#'
#' The purpose of this package is to provide quick and easy coding for
#' downloading and importing the
#' (Physician/Suppler Procedure Summary)[https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Physician-Supplier-Procedure-Summary]
#' data provided by the Centers for Medicare and Medicaid.
#'
#'>The Physician/Supplier Procedure Summary (PSPS) file is a summary of calendar year Medicare Part B carrier and durable medical equipment fee-for-service claims. The file is organized by carrier, pricing locality, Healthcare Common Procedure Coding System (HCPCS) code, HCPCS modifier, provider specialty, type of service, and place of service. The summarized fields are total submitted services and charges, total allowed services and charges, total denied services and charges, and total payment amounts.
#'>
#'>Note: As of November 2020, the following suppression logic will apply:
#'>
#'> Submitted Service Count and Submitted Charge Amount will be suppressed for rows where Submitted Service Count is less than 11; Denied Service Count and Denied Charge Amount will be suppressed for rows where Denied Service Count is less than 11; Assigned Service Count and Allowed Charge Amount will be suppressed for rows where Assigned Service Count is less than 11
#'
#' As will be shown in the following, the size of the data sets is non-trivial.
#' It is recommended that you load and use the data.table package to work with
#' the data.  The import functions provide the data as data.tables.
#'
#+ label = "namespaces"
# /*
if (TRUE) {
  devtools::load_all()
} else {
# */
library(cms.psps)
# /*
}
# */
library(data.table)

#'
#' # Initial Steps
#'
#' Two steps are needed, download and unzip.  Below are some details.  A
#' function for checking the md5sums of the download files has been provided
#' too.
#'
#' ## Downloading PSPS
#'
#' For version 0.1.0 of the package there are tools for downloading and
#' importing the PSPS data from years 2010 through 2019.  The data files are
#' large.  On disk size is not bad, but the size in RAM could be restrictive.
#'
#' You can download the PSPS as .zip file from CMS by calling psps_download().
#' The default is to download all the data sets, but you can specify the years
#' you want.  By default the data is stored on your system in the location
#' defined by
#'
rappdirs::user_data_dir(appname = "cms.psps")
#'
#'
#+ label = "psps_download", eval = FALSE
# /*
while (FALSE) {
# */
psps_download()
# /*
}
# */

#'
#' ## Checking download
#'
#' Calling psps_md5sum will check the md5sum of the downloaded .zip files.
#'
psps_md5sum()

#'
#' ## Unziping the Downloaded Files
#'
#' Simply calling psps_will unzip the files.
#+ eval = FALSE
# /*
while (FALSE) {
# */
psps_unzip()
# /*
}
# */

#'
#' # Importing Data
#'
#' To start to work with the PSPS data you need only call psps_import().  The
#' import is as if you read in the csv with one additional column YEAR.
#'
#+ label = "import 2017 data"
psps2017 <- psps_import(years = 2017)
str(psps2017)

#'
#' There are
{{ formatC(nrow(psps2017), format = "d", big.mark = ",") }}
#' rows in that file.  The approximate size in memory is:
#'
format(utils::object.size(psps2017), units = "GB")

#'
#' Reading in multiple years will result in one data.table.
psps_14_15 <- psps_import(years = 2014:2015)
str(psps_14_15)

table(psps_14_15$YEAR)

format(utils::object.size(psps_14_15), units = "GB")

#'
#' # Data Set Contents
#'
#' This information has been copied from the CMS provided documentation.
#'
#' ## Column 1 : YEAR
#' This was added by the import steps to denote the year the data come from
#'
#' ## Column 2 : HCPCS_CD
#'
#' HCPCS Code -
#'
#' The Health Care Common Procedure Coding System (HCPCS) is a collection of
#' codes that represent procedures, supplies, products and services which may be
#' provided to Medicare beneficiaries and to individuals enrolled in private
#' health insurance programs.  The codes are divided into three levels, or
#' groups as described below:
#'
#' Level I: Codes and descriptors copyrighted by the American Medical
#' Association's Current Procedural Terminology, Fourth Edition (CPT-4).  These
#' are 5 position numeric codes representing physician and nonphysician
#' services.
#'
#' CPT-4 codes including both long and short descriptions shall be used in
#' accordance with the CMS/AMA agreement.  Any other use violates the AMA
#' copyright.
#'
#' Level II Includes codes and descriptors copyrighted by the American Dental
#' Association's Current Dental Terminology, Third Edition (CDT-3).  These are 5
#' position alpha-numeric codes comprising the D series.  All other level II
#' codes and descriptors are approved and maintained jointly by the
#' alpha-numeric editorial panel (consisting of CMS, the Health Insurance
#' Association of America, and the Blue Cross and Blue Shield Association).
#' These are 5 position alpha- numeric codes representing primarily items and
#' nonphysician services that are not represented in the level I codes.
#'
#' Level III Codes and descriptors developed by Medicare carriers for use at the
#' local (carrier) level.  These are 5 position alpha-numeric codes in the W, X,
#' Y or Z series representing physician and nonphysician services that are not
#' represented in the level I or level II codes.
#'
#' ## Column 3 : HCPCS_INITIAL_MODIFIER_CD
#'
#' HCPCS Initial Modifier Code -
#'
#' A first modifier to the HCPCS procedure code to enable a more specific
#' procedure identification for the line item service on the noninstitutional
#' claim.
#'
#' ## Column 4: PROVIDER_SPEC_CD
#'
#' Provider Specialty Code -
#'
#' CMS specialty code used for pricing the line item service on the
#' noninstitutional claim.
#'
#' ## Column 5: CARRIER_NUM
#'
#' Carrier Number -
#'
#' The identification number assigned by CMS to a carrier authorized to process
#' claims from a physician or supplier.
#'
#' ## Column 6: PRICING_LOCALITY_CD
#'
#' Pricing Locality Code -
#'
#' Code denoting the carrier-specific locality used for pricing the service for
#' this line item on the carrier claim (non-DMERC).  For DMERCs, this field
#' contains the beneficiary SSA State Code
#'
#' ## Column 7: TYPE_OF_SERVICE_CD
#'
#' Type of Service Code -
#'
#' Code indicating the type of service, as defined in the CMS Medicare Carrier
#' Manual, for this line item on the non-institutional claim.
#'
#' ## Column 8: PLACE_OF_SERVICE_CD
#'
#' Place of Service Code -
#'
#' The code indicating the place of service, as defined in the Medicare Carrier
#' Manual, for this line item on the noninstitutional claim.
#'
#' ## Column 9: HCPCS_SECOND_MODIFIER_CD
#'
#' HCPCS Second Modifier Code -
#'
#' A second modifier to the HCPCS procedure code to make it more specific than
#' the first modifier code to identify the line item procedures for this claim.
#'
#' ## Column 10: SUBMITTED_SERVICE_CNT
#'
#' Physician/Supplier Procedure Summary (PSPS) Submitted Service Count  -
#'
#' The count of the total number of submitted services.
#'
#' ## Column 11: SUBMITTED_CHARGE_AMT
#'
#' Physician/Supplier Procedure Summary (PSPS) Submitted Charge Amount
#'
#' The amount of charges submitted by the provider to Medicare.
#'
#' ## Column 12: ALLOWED_CHARGE_AMT
#'
#' Physician/Supplier Procedure Summary (PSPS) Allowed Charge Amount -
#'
#' The amount that is approved (allowed) for Medicare.
#'
#' ## Column 13: DENIED_SERVICES_CNT
#'
#' Physician/Supplier Procedure Summary (PSPS) Denied Services Count -
#'
#' The count of the number of submitted services that are denied by Medicare.
#'
#' ## Column 14: DENIED_CHARGE_AMT
#'
#' Physician/Supplier Procedure Summary (PSPS) Denied Charge Amount -
#'
#' The amount of submitted charges for which Medicare payment was denied.
#'
#' ## Column 15: ASSIGNED_SERVICES_CNT
#'
#' Physician/Supplier Procedure Summary (PSPS) Assigned Services Count -
#'
#' The count of the number of services from providers accepting Medicare assignment.
#'
#' ## Column 16: NCH_PAYMENT_AMT
#'
#' Physician/Supplier Procedure Summary (PSPS) NCH Payment Amount -
#'
#' The amount of payment made from the trust fund (after deductible and
#' coinsurance amounts have been paid).
#'
#' ## Column 17: HCPCS_ASC_IND_CD
#'
#' Physician/Supplier Procedure Summary (PSPS) HCPCS ASC Indicator Code -
#'
#' A Y/N code used to indicate whether the procedure is approved to be performed
#' in an Ambulatory Surgical Center (ASC).
#'
#' ## Column 18: ERROR_IND_CD
#'
#' Physician Supplier Procedure Summary (PSPS) Error Indicator Code -
#'
#' The code used to indicate combinations of errors on key fields.
#'
#' ## Column 19: BETOS_CD
#'
#' HCPCS Berenson-Eggers Type of Service Code (BETOS) -
#'
#' This field is valid beginning with 2003 data.  The Berenson-Eggers Type of
#' Service (BETOS) for the procedure code based on generally agreed upon
#' clinically meaningful groupings of procedures and services.

