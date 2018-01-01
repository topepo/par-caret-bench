library(dplyr)
library(ggplot2)
theme_set(theme_bw())

files <- list.files(pattern = "RData$", recursive = TRUE, full.names = TRUE)
files2 <- list.files(pattern = "RData$", recursive = TRUE, full.names = TRUE,
										 path = "/Volumes/max/github/par-caret-bench/macOS/2015 MacBookPro11,4 2.5 GHz Intel Core i7 4core")
files <- c(files, files2)

for (i in seq_along(files)) {
	load(files[i])
	
	if (i == 1)
		times <- res
	else
		times <- bind_rows(times, res)
	rm(res)
}

medians <- times %>%
	group_by(workers, setting, method, task, setting) %>%
	dplyr::summarize(time = median(time),
									 n = length(time)) 


medians <- medians %>%
	filter(workers == 1) %>%
	dplyr::rename(baseline = time) %>%
	ungroup %>%
	dplyr::select(-workers) %>%
	full_join(medians) %>%
	mutate(speedup = baseline/time,
				 computer = ifelse(grepl("iMac", setting), "Desktop (10)", "Laptop (4)"))



ggplot(medians, aes(x = workers, y = time,  col = computer)) + 
	geom_point() + 
	geom_line()  + 
	theme(legend.position = "top") + 
	ylab("Execution Time") + 
	xlab("# Workers") + 
	facet_wrap(~method)

ggplot(medians, aes(x = workers, y = speedup, col = computer)) + 
	geom_point(cex = 2) + 
	geom_line() + 
	geom_abline(col = "green") + 
	theme(legend.position = "none")  + 
	ylab("Speed-Up") + 
	xlab("# Workers") + 
	facet_wrap(~method)

