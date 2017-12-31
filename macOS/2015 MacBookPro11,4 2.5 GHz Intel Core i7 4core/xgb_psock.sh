#/bin/bash

R CMD BATCH --vanilla xgb_psock_07.R
sleep 120
R CMD BATCH --vanilla xgb_psock_06.R
sleep 120
R CMD BATCH --vanilla xgb_psock_08.R
sleep 120
R CMD BATCH --vanilla xgb_psock_03.R
sleep 120
R CMD BATCH --vanilla xgb_psock_09.R
sleep 120
R CMD BATCH --vanilla xgb_psock_04.R
sleep 120
R CMD BATCH --vanilla xgb_psock_02.R
sleep 120
R CMD BATCH --vanilla xgb_psock_01.R
sleep 120
R CMD BATCH --vanilla xgb_psock_05.R
sleep 120
R CMD BATCH --vanilla xgb_psock_10.R
sleep 120
