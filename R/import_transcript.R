import_transcript <- function(path){
  stopifnot(file.exists(path))
  text_str <- rtika::tika_text(path)
  text_v <- strsplit(text_str, "\\n+")
  #works with vector of paths until here, returns list
  audio_path <- purrr::map(text_v,
                      ~.x[which(.x == "Audio file")+1]
  )
  word_path <- path
  text_p1 <- purrr::map(text_v, ~.x[!.x == ""])
  text_p2 <- purrr::map(text_p1, ~.x[(which(.x == "Transcript") + 1):length(.x)])
  odd_seq <- purrr::map(text_p2, ~seq(1, length(.x),2))
  even_seq <- purrr::map(text_p2, ~seq(2, length(.x),2))
  text_tables <- purrr::pmap(
    list(
      text_p2,
      odd_seq,
      even_seq,
      audio_path,
      word_path
    ),
    ~ tibble::tibble(
      "meta" = ..1[..2],
      "speech"= ..1[..3],
      "audio_path"=..4,
      "word_path"=..5
    )
  )
  purrr::map(text_tables, ~ .x %>%
              tidyr::separate(meta, c("time", "speaker"), sep = " ") %>%
              dplyr::mutate(
                speaker = as.factor(speaker),
                time = lubridate::hms(time)
              ))
  }
