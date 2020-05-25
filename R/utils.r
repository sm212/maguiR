
#' Setup folder structure for analysis
#'
#' setup(path) checks if the following folders exist at path. If not, setup
#' makes them:
#'
#' * data - for any raw data files
#' * tmp - for any temporary files (e.g. processed data, models, ...)
#' * out - for any outputs (e.g. images, tables for sharing, ...)
#'
#' @param path charater string, specifies where to make folders. Defaults to current directory
#'
#' @return
#' @export
#'
#' @examples
#' setup()
setup = function(path = '.'){
  folders = c('/data', '/tmp', '/out')

  for (folder in folders){
    folder_path = paste0(path, folder)
    if (!dir.exists(folder_path)) dir.create(folder_path)
  }
}

