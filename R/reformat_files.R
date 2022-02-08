#' Reformat files
#'
#' @param input_paths
#' @export
reformat_files <- function(input_paths=commandArgs(trailingOnly = TRUE)){
  f <- import_transcript(input_paths)
  t <- summarise_speakers(f, "period")
  out_paths <- input_paths %>%
    stringr::str_remove("\\.docx$") %>%
    stringr::str_c("_reformatted.txt")
  export_text(t, out_paths)
}
