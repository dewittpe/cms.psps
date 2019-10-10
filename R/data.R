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

#' Verify PSPS .zip files via MD5SUM
#'
#' @param path directory to the dowloaded PSPS files.
#' @param ... not currently used.
#'
#' @export
psps_md5sum <- function(path = NULL, ...) {

  # MD5SUMS as of 10 October 2019
  expected <- list("psps2010.zip" = "6ddd464247da5e419b43a14b5bfeda75",
                   "psps2011.zip" = "bbfeaa9b9e1580c2f307efbbdee83a98",
                   "psps2012.zip" = "dbb8546845ac57a11b02fd6f47b01696",
                   "psps2013.zip" = "dfc05e337caa5e658a03b0de5c91303b",
                   "psps2014.zip" = "08e0a8c22dbefebac182b2f920e2b274",
                   "psps2015.zip" = "b774c332e62440bc6173fb68784a3ef8",
                   "psps2016.zip" = "a34aa471e33fa0feb7426a8dbbfbfb97",
                   "psps2017.zip" = "7c543ffba37543c55e51f378b8c3a8ec",
                   "psps2018.zip" = "725f198cb3a080c5e91cb411c1547b24")

  observed <- tools::md5sum(files = paste(path, names(expected), sep = "/"))
  names(observed) <- basename(names(observed))

  check <-
    merge(data.frame(file = names(observed), md5sum = observed,             row.names = NULL, stringsAsFactors = FALSE),
          data.frame(file = names(expected), md5sum = do.call(c, expected), row.names = NULL, stringsAsFactors = FALSE),
          by = "file",
          suffixes = c(".observed", ".expected"))
  check$check <- sapply(check$md5sum.observed == check$md5sum.expected, isTRUE)
  check
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
