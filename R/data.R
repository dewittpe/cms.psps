#' Download the PSPS Data
#'
#' Download the public files provided by CMS.
#'
#' @param path directory to save the downloaded files too.
#' @param ... not currently used.
#'
#' @export
psps_download <- function(path = NULL, ...) {

  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  # create needed directories
  dir.create(path = path, showWarnings = FALSE, recursive = TRUE)

  # message("Downloading 2010 data:\n")
  # download.file(url = "https://downloads.cms.gov/files/PSPS2010.zip",
  # destfile = paste(path, "psps2010.zip", sep = "/"))

  Map(f =
      function(n, u) {
        message(sprintf("Downloading %s:\n", n))
        utils::download.file(url = u, destfile = paste(path, n, sep = "/"))
      },
      n = names(psps_urls()),
      u = psps_urls())
}

psps_urls <- function() {
  # urls aquired from https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Physician-Supplier-Procedure-Summary/index.html
  # last verification of urls: 10 October 2019
  list("psps2010.zip" = "https://downloads.cms.gov/files/PSPS2010.zip",
       "psps2011.zip" = "https://downloads.cms.gov/files/PSPS2011.zip",
       "psps2012.zip" = "https://downloads.cms.gov/files/PSPS2012.zip",
       "psps2013.zip" = "https://downloads.cms.gov/files/PSPS2013.zip",
       "psps2014.zip" = "https://downloads.cms.gov/files/PSPS2014.zip",
       "psps2015.zip" = "https://downloads.cms.gov/files/PSPS2015.zip",
       "psps2016.zip" = "https://downloads.cms.gov/files/PSPS2016.zip",
       "psps2017.zip" = "http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Physician-Supplier-Procedure-Summary/psps_2017.zip",
       "psps2018.zip" = "http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Physician-Supplier-Procedure-Summary/PSPS_2018.zip")
}
