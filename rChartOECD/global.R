get_gdoc <- function(url){
  require(RCurl)
  s = getURLContent(url)
  read.csv(textConnection(s))
}

durl <- "https://docs.google.com/spreadsheets/d/1sNeW0-CuhtnXrgHxaxFgXNZhNGw0aR0SZX07fHmZbts/pub?single=true&gid=0&output=csv"

dat <- get_gdoc(durl)
dat2 <- reshape(dat, varying = names(dat)[2:35], direction = 'long', timevar = "year")
dat2m <- reshape2::melt(dat2, id = c(1:3, 6))
dat2m <- na.omit(transform(dat2m, value = as.numeric(as.character(value))))
names(dat2m) <- c('country', 'countrycode', 'year', 'id', 'gender', 'value')
