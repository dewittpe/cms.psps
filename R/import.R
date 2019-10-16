#' Import Functions for the PSPS data
#'
#' @param path path to the directory where the downloaded data is stored.
#' @param ... additional arguments passed to \code{data.table::fread}
#'
#' @return A \code{\link[data.table]{data.table}}
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
#' psps_2010 <- psps_import_2010()
#' psps_2010
#'
#' }
#'
#' @name import
NULL

#' @rdname import
#' @export
psps_import_2010 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2010"), full.names = TRUE, pattern = "082611$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2010L)
}

#' @rdname import
#' @export
psps_import_2011 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2011"), full.names = TRUE, pattern = "091112$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2011L)
}

#' @rdname import
#' @export
psps_import_2012 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2012"), full.names = TRUE, pattern = "PSPS\\d{2}$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2012L)
}

#' @rdname import
#' @export
psps_import_2013 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2013"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2013L)
}

#' @rdname import
#' @export
psps_import_2014 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2014"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2014L)
}

#' @rdname import
#' @export
psps_import_2015 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2015"), full.names = TRUE, pattern = "PSPS\\d{2}\\.txt$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2015L)
}

#' @rdname import
#' @export
psps_import_2016 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    lapply(list.files(paste0(path, "/psps2016"), full.names = TRUE, pattern = "PSPS\\d{2}\\.(txt|TXT)$"),
           data.table::fread,
           sep = "\n",
           header = FALSE,
           showProgress = FALSE,
           ...)

  data.table::set(psps_import_parse(data.table::rbindlist(import)), j = "YEAR", value = 2016L)
}

#' @rdname import
#' @export
psps_import_2017 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    data.table::fread(file = paste0(path, "/psps2017/PSPS_2017.csv"),
                      showProgress = FALSE,
                      colClasses = c(rep(character(), 8),
                                     rep(numeric(), 7),
                                     rep(character(), 3)),
                      ...)

  data.table::set(import, j = "YEAR", value = 2017L)
}

#' @rdname import
#' @export
psps_import_2018 <- function(path = NULL, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  import <-
    data.table::fread(file = paste0(path, "/psps2018/PSPS2018.csv"),
                      showProgress = FALSE,
                      colClasses = c(rep(character(), 8),
                                     rep(numeric(), 7),
                                     rep(character(), 3)),
                      ...)

  data.table::set(import, j = "YEAR", value = 2018L)
}


psps_import_parse <- function(x) {
  data.table::set(x, j = "HCPCS_CD",                    value =            substring(x[["V1"]], first =   1L, last =   5L))
  data.table::set(x, j = "HCPCS_INITIAL_MODIFIER_CD",   value =            substring(x[["V1"]], first =   6L, last =   7L))
  data.table::set(x, j = "PROVIDER_SPEC_CD",            value =            substring(x[["V1"]], first =   8L, last =   9L))
  data.table::set(x, j = "CARRIER_NUM",                 value =            substring(x[["V1"]], first =  10L, last =  14L))
  data.table::set(x, j = "PRICING_LOCALITY_CD",         value =            substring(x[["V1"]], first =  15L, last =  16L))
  data.table::set(x, j = "TYPE_OF_SERVICE_CD",          value =            substring(x[["V1"]], first =  17L, last =  17L))
  data.table::set(x, j = "PLACE_OF_SERVICE_CD",         value =            substring(x[["V1"]], first =  18L, last =  19L))
  data.table::set(x, j = "HCPCS_SECOND_MODIFIER_CD",    value =            substring(x[["V1"]], first =  20L, last =  21L))
  data.table::set(x, j = "PSPS_SUBMITTED_SERVICE_CNT",  value = as.numeric(substring(x[["V1"]], first =  22L, last =  35L)))
  data.table::set(x, j = "PSPS_SUBMITTED_CHARGE_AMT",   value = as.numeric(substring(x[["V1"]], first =  36L, last =  48L)))
  data.table::set(x, j = "PSPS_ALLOWED_CHARGE_AMT",     value = as.numeric(substring(x[["V1"]], first =  49L, last =  61L)))
  data.table::set(x, j = "PSPS_DENIED_SERVICES_CNT",    value = as.numeric(substring(x[["V1"]], first =  62L, last =  75L)))
  data.table::set(x, j = "PSPS_DENIED_CHARGE_AMT",      value = as.numeric(substring(x[["V1"]], first =  76L, last =  88L)))
  data.table::set(x, j = "PSPS_ASSIGNED_SERVICES_CNT",  value = as.numeric(substring(x[["V1"]], first =  89L, last = 102L)))
  data.table::set(x, j = "PSPS_NCH_PAYMENT_AMT",        value = as.numeric(substring(x[["V1"]], first = 103L, last = 115L)))
  data.table::set(x, j = "PSPS_HCPCS_ASC_IND_CD",       value =            substring(x[["V1"]], first = 116L, last = 116L))
  data.table::set(x, j = "PSPS_ERROR_IND_CD",           value =            substring(x[["V1"]], first = 117L, last = 118L))
  data.table::set(x, j = "HCPCS_BETOS_CD",              value =            substring(x[["V1"]], first = 119L, last = 121L))
  data.table::set(x, j = "V1",                          value = NULL)
  x
}

