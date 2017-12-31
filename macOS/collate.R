library(dplyr)
library(ggplot2)

files <- list.files(pattern = "RData$", recursive = TRUE, full.names = TRUE)


for (i in seq_along(files)) {
	load(files[i])
	
	if (i == 1)
		times <- res
	else
		times <- bind_rows(times, res)
	rm(res)
}

medians <- times %>%
	group_by(workers, setting, method, task) %>%
	dplyr::summarize(time = median(time),
									 n = length(time)) 


medians <- medians %>%
	filter(workers == 1) %>%
	dplyr::rename(baseline = time) %>%
	ungroup %>%
	dplyr::select(-workers) %>%
	inner_join(medians) %>%
	mutate(speedup = baseline/time)


ggplot(medians, aes(x = workers, y = time, col = method)) + 
	geom_point() + 
	geom_line()  + 
	theme(legend.position = "top") + 
	ylab("Execution Time") + 
	xlab("# Workers")

ggplot(medians, aes(x = workers, y = speedup, col = method)) + 
	geom_point(cex = 2) + 
	geom_line() + 
	geom_abline(col = "green", lty = 3) + 
	theme(legend.position = "none")  + 
	ylab("Speed-Up") + 
	xlab("# Workers")

