#' Import Functions for the PSPS data
#'
#' @param path path to the directory where the downloaded data is stored.
#' @param years which years to import
#' @param ... additional arguments passed to \code{data.table::fread}
#'
#' @return A \code{\link[data.table]{data.table}}
#'
#' @examples
#' \dontrun{
#'
#' library(cms.psps)
#'
#' # Check that the data is as expected
#' check <- psps_md5sum()
#' if (!all(check$check)) {
#'   psps_download()
#'   psps_unzip()
#' }
#'
#' psps_2010 <- psps_import(year = 2010)
#' psps_2010
#'
#' psps_2018_2019 <- psps_import(years = 2018:2019)
#' psps_2018_2019
#'
#' }
#'
#' @name import
NULL

#' @rdname import
#' @export
psps_import <- function(path = NULL, years = 2010:2019, ...) {
  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  DT <-
    lapply(years,
           function(yr) {
               data.table::fread(
                                 file = paste0(path, "/psps", yr, "/PSPS_", yr, "_SUPPRESS.csv")
                                 , colClasses = c(rep(character(), 8), rep(numeric(), 7), rep(character(), 3))
             )
           })

  DT <- stats::setNames(DT, years)
  DT <- data.table::rbindlist(DT, idcol = "YEAR")
  data.table::set(DT, j = "YEAR", value = as.integer(DT[["YEAR"]]))
  DT
}

