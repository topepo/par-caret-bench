workers <- 13
prefix <- "iMacPro1,1 3 GHz Intel Xeon W 10core"

if (workers > 1) {
	library(doParallel)
	cl <- makePSOCKcluster(workers)
	registerDoParallel(cl)
}


library(caret)
library(xgboost)
library(lubridate)
library(sessioninfo)

rand_int <- sample.int(10000, 1)

set.seed(598)
dat <- twoClassSim(2000, noiseVars = 100)

ctrl <- trainControl(method = "repeatedcv",
                     repeats = 5,
                     search = "random")


set.seed(7257)
len <- 25
grid <-
	data.frame(
		nrounds = sample(1:1000, size = len, replace = TRUE),
		max_depth = sample(1:10, replace = TRUE, size = len),
		eta = runif(len, min = .001, max = .6),
		gamma = runif(len, min = 0, max = 10),
		colsample_bytree = runif(len, min = .3, max = .7),
		min_child_weight = sample(0:20, size = len, replace = TRUE),
		subsample = runif(len, min = .25, max = 1)
	)

set.seed(2098)
mod <- train(
	Class ~ .,
	data = dat,
	method = "xgbTree",
	trControl = ctrl,
	tuneGrid = grid,
	nthread = 1
)

stopCluster(cl)

res <-
	data.frame(
		time = as.vector(mod$times$everything[3]) / 60,
		os = Sys.info()[['sysname']],
		R = R.version.string,
		when = now(),
		workers = workers,
		setting = prefix,
		method = "psock",
		task = "xgbTree"
	)

file <- paste(prefix, workers, rand_int, sep = "_")

save(res, file = paste0(file, ".RData"))


session_info()

q("no")
