
#' Setup folder structure for analysis
#'
#' setup(path) checks if the following folders exist at path. If not, setup
#' makes them:
#'
#' * data - for any raw data files
#' * tmp - for any temporary files (e.g. processed data, models, ...)
#' * out - for any outputs (e.g. images, tables for sharing, ...)
#'
#' @param path character string, specifies where to make folders. Defaults to current directory
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


#' Download shapefile for mapping
#'
#' Downloads the highest resolution shapefiles for several common boundaries
#' (see below for list).
#'
#' Two types of shapefile are available for download - 'extent of the realm'
#' and 'clipped to the coastline'. Extent of the realm should be used for any GIS
#' work (computing areas of regions, for example), and clipped to the coastline
#' should be used for mapping & visualisation. Both types look very similar,
#' maps produced using extent of the realm shapefiles will be almost identical
#' to maps produced using clipped to the coastline shapefiles.
#'
#' Extent of the realm shapefiles are downloaded by default.
#' Clipped to the coastline shapefiles are needed if you are overlaying other
#' map visuals (OSM, ordnance survey, etc).
#'
#' @param boundary character string, specifies what boundary you want.
#' Available options are 'ltla' (Lower Tier Local Authorities),
#' 'ccg' (Clinical Commissioning Groups),
#' 'stp' (Sustainability & Transformation Partnerships),
#' 'msoa' (Middle Super Output Areas), and
#' 'lsoa' (Lower Super Output Areas)
#' @param type character string, specifies what type of shapefile you want.
#' Available options are 'extent' (Extent Of The Realm), or
#' 'clipped' (Clipped to the coastline)
#' @param path character string, specifies where the shapefile will be saved.
#' By default shapefiles will be saved in a ./shp directory
#'
#' @return
#' @export
#'
#' @examples
#' # Get extent of the realm LSOAs (large file - may take a while to download)
#' get_shapefile(boundary = 'lsoa')
#'
#' # Get clipped CCGs
#' get_shapefile(boundary = 'ccg', type = 'clipped')
#'
#' # Get clipped MSOAs, save to current directory
#' get_shapefile(boundary = 'msoa', type = 'clipped', path = '.')
get_shapefile = function(boundary, type = 'extent', path = './shp'){

  if(! type %in% c('extent', 'clipped')){
    stop('type must be either "extent" or "clipped"')
  }
  if (! boundary %in% c('ltla', 'ccg', 'stp', 'msoa', 'lsoa')){
    stop('boundary must be either "ltla", "ccg", "stp", "msoa", or "lsoa"')
  }

  urls = c('ltla_e' = 'https://bit.ly/2yCr8k4',
           'ccg_e' = 'https://bit.ly/2zwY7qn',
           'stp_e' = 'https://bit.ly/2AdgYXj',
           'msoa_e' = 'https://bit.ly/3ej4oES',
           'lsoa_e' = 'https://bit.ly/2LX8uGH',
           'ltla_c' = 'https://bit.ly/2ZF6zOP',
           'ccg_c' = 'https://bit.ly/36vv96p',
           'stp_c' = 'https://bit.ly/36w2sWV',
           'msoa_c' = 'https://bit.ly/2X4AS00',
           'lsoa_c' = 'https://bit.ly/3c1Y6bi')

  type_label = substr(type, 1, 1)
  url_key = paste0(boundary, '_', type_label)
  url = urls[url_key]

  message('Downloading shapefile now, please wait...')
  curl::curl_download(url, paste0(url_key, '.zip'))
  unzip(paste0(url_key, '.zip'), exdir = path)
  file.remove(paste0(url_key, '.zip'))

  message(paste('Shapefile successfully downloaded & saved in '), path)
}

