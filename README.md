
# clean.transcripts

<!-- badges: start -->
<!-- badges: end -->

The goal of clean.transcripts is to help you process the output of the word (online) transcribe feature

## Installation

You can install the released version of clean.transcripts from [Github](https://www.github.com/bschwetz/clean.transcripts) with:

``` r
remotes::install_github("bschwetz/clean.transcripts")
rtika::install_tika()
```

## Example

### Step 1 Install clean.transcripts

see above.

### Step 2 Process some files with word transcribe

[Step by step tutorial](https://support.microsoft.com/en-us/office/transcribe-your-recordings-7fc2efec-245e-45f0-b053-2a97531ecf57)

*Select `Add to document` > `With Speaker and timestamps`!* otherwise the parser will break!

### Step 4 Post process with R

The simplest way (without starting an interactive R session) is to run the following line:

> R -s -e 'clean.transcripts::reformat_files()' --args 'file1.docx' 'file2.docx' ..

This will create `file1_reformatted.txt`, `file2_reformatted.txt`, etc.


The other ways are not documented ;)
