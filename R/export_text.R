export_text <- function(list_of_tables, paths, table_collapse_pattern = "# {time_start} -- {time_end}\n> {speaker}\n{speech}\n\n", outer_collapse_pattern = "Audio file: {audio_path}\nWord autotranscript: {word_path}\n\nTranscript:\n{transcript}") {
  stopifnot(length(list_of_tables) == length(paths))
  audio_paths = purrr::map_chr(
    list_of_tables,
    ~ unique(.x[["audio_path"]])
  )
  word_paths = purrr::map_chr(
    list_of_tables,
    ~ unique(.x[["word_path"]])
  )
  transcripts <- purrr::map(
    list_of_tables,
    ~glue::glue_data_safe(.x, table_collapse_pattern, .trim = FALSE)
  )
  strings <- purrr::pmap(
    list(
      audio_paths,
      word_paths,
      transcripts
    ),
      function(...){
        glue::glue_data_safe(
        tibble::tibble(
          audio_path = ..1,
          word_path = ..2,
          transcript = paste0(..3, collapse = "")
          ),
        outer_collapse_pattern,
        .trim = FALSE)
      }
  )
  purrr::map2(
    strings,
    paths,
    function(text, path){
      con <- file(path)
      writeLines(text, con)
      close(con)
    }
  )
  invisible()
}
