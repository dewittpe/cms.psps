#' Download the PSPS Data
#'
#' Download the public files provided by CMS.
#'
#' @param path directory to save the downloaded files too.
#' @param years years to download
#' @param ... not currently used.
#'
#' @export
psps_download <- function(path = NULL, years = 2010:2019, ...) {

  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  stopifnot(all(years %in% 2010:2019))

  # create needed directories, if needed
  dir.create(path = path, showWarnings = FALSE, recursive = TRUE)

  Map(f =
      function(n, u) {
        message(sprintf("Downloading %s:\n", n))
        utils::download.file(url = u, destfile = paste(path, n, sep = "/"))
      },
      n = names(psps_urls())[which(2010:2019 %in% years)],
      u = psps_urls()[which(2019:2019 %in% years)])
}

#' Verify PSPS .zip files via MD5SUM
#'
#' @param path directory to the downloaded PSPS files.
#' @param years data sets to verify
#' @param ... not currently used.
#'
#' @export
psps_md5sum <- function(path = NULL, years = 2010:2019, ...) {

  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  stopifnot(all(years %in% 2010:2019))

  # updated 6 May 2021 for v0.1.0
  expected <- list(
                     "psps2010.zip" = "ceef3a0f080eab632082340477a53d11"
                   , "psps2011.zip" = "a080b5f6ba4aafe350d5c03bb0298cab"
                   , "psps2012.zip" = "b6e6855d58d5cee5469a1c2c57c8f10b"
                   , "psps2013.zip" = "ebd6eff8594b474387b77bc025a305b5"
                   , "psps2014.zip" = "e5f7850e63dd1ef7d68f8c0cfb30f1ec"
                   , "psps2015.zip" = "ed85399041533aad50a6b0f441c2ac76"
                   , "psps2016.zip" = "8ea9b0656002b92bcd94226154f02d17"
                   , "psps2017.zip" = "114852c334e4a5c255f82ec48379748e"
                   , "psps2018.zip" = "5d3e55669ea9523250fe49ae2f41bf0f"
                   , "psps2019.zip" = "80ca784297c18c30acfe9edbf2e4be8d"
                   )
  expected <- expected[which(2010:2019 %in% years)]

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

#' Unzip Downloaded Data Sets
#'
#' @param path directory to the downloaded PSPS files.
#' @param ... not currently used.
#'
#' @export
psps_unzip <- function(path = NULL, ...) {

  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

  zips <- list.files(path, pattern = "*\\.zip$", full.names = TRUE)
  zips <- stats::setNames(zips, basename(list.files(path, pattern = "*\\.zip$", full.names = TRUE)))

  for (i in seq_along(zips)) {
    message(paste0("Unzipping ", names(zips)[i]))
    utils::unzip(zips[i],
                 exdir = paste0(path, "/", sub(".zip", "", names(zips)[i])))
  }
  invisible(TRUE)
}

psps_urls <- function() {
  # urls aquired from https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Physician-Supplier-Procedure-Summary/index.html

  # v0.1.0
  list(
         "psps2010.zip" = "https://downloads.cms.gov/files/PSPS2010.zip"
       , "psps2011.zip" = "https://www.cms.gov/files/zip/psps2011suppress.zip"
       , "psps2012.zip" = "https://www.cms.gov/files/zip/psps2012suppress.zip"
       , "psps2013.zip" = "https://www.cms.gov/files/zip/psps2013suppress.zip"
       , "psps2014.zip" = "https://www.cms.gov/files/zip/psps2014suppress.zip"
       , "psps2015.zip" = "https://www.cms.gov/files/zip/2015-physician-supplier-procedure-summary.zip"
       , "psps2016.zip" = "https://www.cms.gov/files/zip/2016-physician-supplier-procedure-summary.zip"
       , "psps2017.zip" = "https://www.cms.gov/files/zip/2017-physician-supplier-procedure-summary.zip"
       , "psps2018.zip" = "https://www.cms.gov/files/zip/2018-physician-supplier-procedure-summary.zip"
       , "psps2019.zip" = "https://www.cms.gov/files/zip/2019-physician-supplier-procedure-summary.zip"
       )
}









