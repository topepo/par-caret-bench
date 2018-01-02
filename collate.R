library(dplyr)
library(ggplot2)
theme_set(theme_bw())

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
	group_by(workers, setting, method, task, setting, os) %>%
	dplyr::summarize(time = median(time),
									 n = length(time)) 


medians <- medians %>%
	filter(workers == 1) %>%
	dplyr::rename(baseline = time) %>%
	ungroup %>%
	dplyr::select(-workers) %>%
	full_join(medians) %>%
	mutate(speedup = baseline/time,
				 computer = case_when(
				 	grepl("iMac", setting) ~ "Desktop (10, 3.0GHz)",
				 	grepl("MacBookPro", setting) ~ "Laptop (4, 2.5GHz)",	
				 	grepl("DIY", setting) ~ "Desktop (6, 3.4GHz)"
				 ),
				 method = ifelse(method == "domc", "fork (doMC)", method),
				 method = ifelse(method == "fork", "fork (doParallel)", method)
	)

ggplot(medians, aes(x = workers, y = time,  col = computer, shape = os)) + 
	geom_point() + 
	geom_line()  + 
	theme(legend.position = "top") + 
	ylab("Execution Time") + 
	xlab("# Workers") + 
	facet_wrap(~method)

ggplot(medians, aes(x = workers, y = speedup, col = computer, shape = os)) + 
	geom_point(cex = 2) + 
	geom_line() + 
	geom_abline(col = "black") + 
	theme(legend.position = "top")  + 
	ylab("Speed-Up") + 
	xlab("# Workers") + 
	facet_wrap(~method)

