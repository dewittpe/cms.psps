#' Spark Import Functions for the PSPS data
#'
#' Importing the PSPS data into spark via sparklyr
#'
#' @param sc a sparklyr cluster
#' @param path path to the directory where the downloaded data is stored.
#' @param envir the envir to assign the \code{tbl_spark} object too, defatuls to
#' the global environment.
#' @param ... arguments passed to \code{\link[sparklyr]{spark_read_csv}} (for
#' the import of 2017 data) or to \code{\link[sparklyr]{spark_read_text}} for
#' the years 2004 through 2016.
#'
#' @return A \code{tbl_spark} object of the name psps_<year> will be in the
#' \code{envir}.
#'
#' @examples
#' \donttest{
#'
#' library(cms.psps)
#'
#' # Check that the data is as expected
#' check <- psps_md5sum()
#' if (!all(check$check)) {
#'   psps_download()
#' }
#'
#' # Set up spark if needed
#' # sparklyr::spark_install()
#'
#' sc <- sparklyr::spark_connect("local")
#'
#' ls()
#'
#' spark_psps_import_2010(sc, memory = FALSE)
#' psps_2010
#'
#' #spark_psps_import_2011(sc, memory = FALSE)
#' psps_2011
#' #spark_psps_import_2012(sc, memory = FALSE)
#' #spark_psps_import_2013(sc, memory = FALSE)
#' #spark_psps_import_2014(sc, memory = FALSE)
#' #spark_psps_import_2015(sc, memory = FALSE)
#' #spark_psps_import_2016(sc, memory = FALSE)
#' #spark_psps_import_2017(sc, memory = FALSE)
#' #spark_psps_import_2018(sc, memory = FALSE)
#'
#' ls()
#'
#' sparklyr::spark_disconnect(sc)
#'
#' }
#'
#'
#' @name spark_import
NULL

#' @rdname spark_import
#' @export
spark_psps_import_2010 <- function(sc, path = NULL, envir = .GlobalEnv, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  files <- list.files(path = paste(path, "psps2010", sep = "/"),
                      full.names = TRUE,
                      pattern = "PSPS\\d{2}")

  object <-
    sparklyr::sdf_bind_rows(lapply(files, function(x, ...) {
                                     sparklyr::spark_read_text(sc, name = x, path = x, ...)
                                   }))

  assign(x     = "psps_2010",
         value = psps_mutate_v2(object, YEAR = 2010L),
         envir = envir)

  invisible(TRUE)
}

# #' @rdname import
# #' @export
# spark_psps_import_2011 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2011"), full.names = TRUE, pattern = "091112$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2011L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2012 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2012"), full.names = TRUE, pattern = "PSPS\\d{2}$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2012L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2013 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2013"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2013L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2014 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2014"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2014L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2015 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2015"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2015L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2016 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     lapply(list.files(paste0(path, "/psps2016"), full.names = TRUE, pattern = "PSPS\\d{2}\\.(txt|TXT)$"),
#            data.table::fread,
#            sep = "\n",
#            header = FALSE,
#            showProgress = FALSE,
#            ...)
#
#   data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2016L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2017 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     data.table::fread(file = paste0(path, "/psps2017/PSPS_2017.csv"),
#                       showProgress = FALSE,
#                       colClasses = c(rep(character(), 8),
#                                      rep(numeric(), 7),
#                                      rep(character(), 3)),
#                       ...)
#
#   data.table::set(import, j = "YEAR", value = 2017L)
# }
#
# #' @rdname import
# #' @export
# spark_psps_import_2018 <- function(path = NULL, ...) {
#   if (is.null(path)) {
#     path <- rappdirs::user_data_dir(appname = "cms.psps")
#   }
#
#   import <-
#     data.table::fread(file = paste0(path, "/psps2018/PSPS2018.csv"),
#                       showProgress = FALSE,
#                       colClasses = c(rep(character(), 8),
#                                      rep(numeric(), 7),
#                                      rep(character(), 3)),
#                       ...)
#
#   data.table::set(import, j = "YEAR", value = 2018L)
# }


# colClasses
psps_colClasses <-
  c(
    "HCPCS_CD"                   = "character",
    "HCPCS_INITIAL_MODIFIER_CD"  = "character",
    "PROVIDER_SPEC_CD"           = "character",
    "CARRIER_NUM"                = "character",
    "PRICING_LOCALITY_CD"        = "character",
    "TYPE_OF_SERVICE_CD"         = "character",
    "PLACE_OF_SERVICE_CD"        = "character",
    "HCPCS_SECOND_MODIFIER_CD"   = "character",
    "REGION"                     = "character",
    "PSPS_SUBMITTED_SERVICE_CNT" = "numeric",
    "MTUS"                       = "character",
    "ANESTHESIA_UNITS"           = "character",
    "MTUIND"                     = "character",
    "PSPS_SUBMITTED_CHARGE_AMT"  = "numeric",
    "PSPS_ALLOWED_CHARGE_AMT"    = "numeric",
    "PSPS_DENIED_SERVICES_CNT"   = "numeric",
    "PSPS_DENIED_CHARGE_AMT"     = "numeric",
    "PSPS_ASSIGNED_SERVICES_CNT" = "numeric",
    "PSPS_NCH_PAYMENT_AMT"       = "numeric",
    "PSPS_HCPCS_ASC_IND_CD"      = "character",
    "PSPS_ERROR_IND_CD"          = "character",
    "HCPCS_BETOS_CD"             = "character"
    )

psps_mutate_v2 <- function(.data, ...) {
    # This is based on the PSPS File Desc Layout as of 08/29/2010
    dplyr::mutate(.data,
                  HCPCS_CD                   =            substr(.data$line, start =   1L, stop =   5L),  #1
                  HCPCS_INITIAL_MODIFIER_CD  =            substr(.data$line, start =   6L, stop =   7L),  #2
                  PROVIDER_SPEC_CD           =            substr(.data$line, start =   8L, stop =   9L),  #3
                  CARRIER_NUM                =            substr(.data$line, start =  10L, stop =  14L),  #4
                  PRICING_LOCALITY_CD        =            substr(.data$line, start =  15L, stop =  16L),  #5
                  TYPE_OF_SERVICE_CD         =            substr(.data$line, start =  17L, stop =  17L),  #6
                  PLACE_OF_SERVICE_CD        =            substr(.data$line, start =  18L, stop =  19L),  #7
                  HCPCS_SECOND_MODIFIER_CD   =            substr(.data$line, start =  20L, stop =  21L),  #8
                  PSPS_SUBMITTED_SERVICE_CNT = as.numeric(substr(.data$line, start =  22L, stop =  35L)), #9
                  PSPS_SUBMITTED_CHARGE_AMT  = as.numeric(substr(.data$line, start =  36L, stop =  48L)), #10
                  PSPS_ALLOWED_CHARGE_AMT    = as.numeric(substr(.data$line, start =  49L, stop =  61L)), #11
                  PSPS_DENIED_SERVICES_CNT   = as.numeric(substr(.data$line, start =  62L, stop =  75L)), #12
                  PSPS_DENIED_CHARGE_AMT     = as.numeric(substr(.data$line, start =  76L, stop =  88L)), #13
                  PSPS_ASSIGNED_SERVICES_CNT = as.numeric(substr(.data$line, start =  89L, stop = 102L)), #14
                  PSPS_NCH_PAYMENT_AMT       = as.numeric(substr(.data$line, start = 103L, stop = 115L)), #15
                  PSPS_HCPCS_ASC_IND_CD      =            substr(.data$line, start = 116L, stop = 116L),  #16
                  PSPS_ERROR_IND_CD          =            substr(.data$line, start = 117L, stop = 118L),  #17
                  HCPCS_BETOS_CD_CD          =            substr(.data$line, start = 119L, stop = 121L),  #18
                  `line`                     = NULL,
                  ...
                  )
}

psps_mutate_v1 <- function(.data, ...) {
  dplyr::mutate(.data,
                HCPCS_CD                    =            substr(.data$line, start =   1L, stop =   5L),
                HCPCS_INITIAL_MODIFIER_CD   =            substr(.data$line, start =   6L, stop =   7L),
                PROVIDER_SPEC_CD            =            substr(.data$line, start =   8L, stop =   9L),
                CARRIER_NUM                 =            substr(.data$line, start =  10L, stop =  14L),
                PRICING_LOCALITY_CD         =            substr(.data$line, start =  15L, stop =  16L),
                TYPE_OF_SERVICE_CD          =            substr(.data$line, start =  17L, stop =  17L),
                PLACE_OF_SERVICE_CD         =            substr(.data$line, start =  18L, stop =  19L),
                HCPCS_SECOND_MODIFIER_CD    =            substr(.data$line, start =  20L, stop =  21L),
                REGION                      =            substr(.data$line, start =  22L, stop =  23L),
                PSPS_SUBMITTED_SERVICE_CNT  = as.numeric(substr(.data$line, start =  24L, stop =  32L)),
                MTUS                        = as.numeric(substr(.data$line, start =  33L, stop =  41L)),
                ANESTHESIA_UNITS            = as.numeric(substr(.data$line, start =  33L, stop =  41L)),
                MTUIND                      =            substr(.data$line, start =  42L, stop =  42L),
                PSPS_SUBMITTED_CHARGE_AMT   = as.numeric(substr(.data$line, start =  43L, stop =  52L)),
                PSPS_ALLOWED_CHARGE_AMT     = as.numeric(substr(.data$line, start =  53L, stop =  62L)),
                PSPS_DENIED_SERVICES_CNT    = as.numeric(substr(.data$line, start =  63L, stop =  70L)),
                PSPS_DENIED_CHARGE_AMT      = as.numeric(substr(.data$line, start =  71L, stop =  78L)),
                PSPS_ASSIGNED_SERVICES_CNT  = as.numeric(substr(.data$line, start =  79L, stop =  87L)),
                PSPS_NCH_PAYMENT_AMT        = as.numeric(substr(.data$line, start =  88L, stop =  97L)),
                PSPS_HCPCS_ASC_IND_CD       =            substr(.data$line, start =  98L, stop =  98L),
                PSPS_ERROR_IND_CD           =            substr(.data$line, start =  99L, stop =  99L),
                HCPCS_BETOS_CD              =            substr(.data$line, start = 100L, stop = 105L),
                `line`                      = NULL,
                ...
  )
}

