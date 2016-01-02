#!/bin/bash

cd data/primate_jobs/

PREFIX=http://pin.primate.wisc.edu/jobs/listings/

for i in $( seq 1 9999 ); do
    echo "--- Processing index $i --------------------------------"
    wget ${PREFIX}${i} -O ${i}.html
    sleep 3
done
