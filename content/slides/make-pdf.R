# Makes pdf slides for all lectures

## OPTION 1: pagedown::chrome_print ----

pagedown::chrome_print("content/slides/xx-slides.html")
pagedown::chrome_print("content/slides/xx-slides.html", timeout = 120)

stopifnot(FALSE)

lapply(list.files(pattern = "*slides*.html", recursive = T),
       function(file) {
         pagedown::chrome_print(file)
       }
)



stopifnot(FALSE)

## OPTION 2: xaringan::decktape ----
lapply(list.files(pattern = "*slides*.html", recursive = T),
       function(file) {
         xaringan::decktape(
           file,
           output = paste0(tools::file_path_sans_ext(file), ".pdf")
         )
       }
)

