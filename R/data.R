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
#' @param path directory to the downloaded PSPS files.
#' @param ... not currently used.
#'
#' @export
psps_md5sum <- function(path = NULL, ...) {

  if (is.null(path)) {
    path <- rappdirs::user_data_dir(appname = "cms.psps")
  }

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

  message("Unzipping 2010...")
  utils::unzip(paste0(path, "/psps2010.zip"), exdir = paste0(path, "/psps2010"))
  message("Unzipping 2011...")
  utils::unzip(paste0(path, "/psps2011.zip"), exdir = paste0(path, "/psps2011"))
  message("Unzipping 2012...")
  utils::unzip(paste0(path, "/psps2012.zip"), exdir = paste0(path, "/psps2012"))
  message("Unzipping 2013...")
  utils::unzip(paste0(path, "/psps2013.zip"), exdir = paste0(path, "/psps2013"))
  message("Unzipping 2014...")
  utils::unzip(paste0(path, "/psps2014.zip"), exdir = paste0(path, "/psps2014"))
  message("Unzipping 2015...")
  utils::unzip(paste0(path, "/psps2015.zip"), exdir = paste0(path, "/psps2015"))
  message("Unzipping 2016...")
  utils::unzip(paste0(path, "/psps2016.zip"), exdir = paste0(path, "/psps2016"))
  message("Unzipping 2017...")
  utils::unzip(paste0(path, "/psps2017.zip"), exdir = paste0(path, "/psps2017"))
  message("Unzipping 2018...")
  utils::unzip(paste0(path, "/psps2018.zip"), exdir = paste0(path, "/psps2018"))
  message("Unzipping 2019...")
  utils::unzip(paste0(path, "/psps2019.zip"), exdir = paste0(path, "/psps2019"))

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









