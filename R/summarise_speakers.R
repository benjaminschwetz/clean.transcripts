summarise_speakers <- function(list_of_tables, time_stamps = c("seconds", "period")){
  time_stamps <- match.arg(time_stamps)
  sum_tabs <- purrr::map(
    list_of_tables,
    ~.x %>%
    dplyr::mutate(.id = dplyr::row_number(),
                  .speaker_changed = speaker != dplyr::lag(speaker, default = speaker[1]),
                  .to_grp = cumsum(.speaker_changed),
                  time_sec = lubridate::period_to_seconds(time)) %>%
    dplyr::group_by(.to_grp) %>%
    dplyr::summarise(
      audio_path = unique(audio_path),
      word_path = unique(word_path),
      speaker = unique(speaker),
      time_start = min(time_sec),
      time_end = max(time_sec),
      speech = stringr::str_flatten(speech, collapse = " ") %>% stringr::str_squish()
    ) %>%
      dplyr::ungroup() %>%
      dplyr::select(-dplyr::starts_with("."))
  )
  if(time_stamps == "period") {
  purrr::map(
    sum_tabs,
    ~ .x %>%
      dplyr::mutate_at(dplyr::vars(dplyr::starts_with("time_")), lubridate::seconds_to_period)
  )
  } else sum_tabs
}

