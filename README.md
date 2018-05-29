
# Setup for Cache Line Utilization Pin Tool

1. Setup an Intel Pin Tool installation according to your system type
2. In that installation, create a symlink from source/tools/CacheLineUtilization to source/tools/CacheLineUtilization in this repo
3. cd source/tools/CacheLineUtilization
4. make clutil.wrap
5. ../../../pin -t obj-intel64/clutil.so -- [[Your Program]]
6. Find results in clutil.out

# Simple Example

As an example, you can look into SimpleExample.cpp which simulates sequential and random (here: strided) accesses, refered to in "A Case for Hardware-Supported Sub-Cache Line Accesses" as a first sanity check:

7. g++ -O3 SimpleExample.cpp -o SimpleExample
8. cd source/tools/CacheLineUtilization
9. ../../../pin -t obj-intel64/clutil.so -- ./SimpleExample s

You can start SimpleExample with either "s" as a parameter (for sequential read) or "r" for random reads

# Reproducing Results from "A Case for Hardware-Supported Sub-Cache Line Accesses"

In the following we describe the instrumentation we used to conduct the measurements, as shown in our work.

# Measuring Hyrise
Follow the install instructions to install [Hyrise](https://github.com/hyrise/hyrise/wiki/Step-by-Step-Guide).

Note: Please use cmake -DCMAKE_BUILD_TYPE=Release ..

For our work and the following instructions, please use the commit tag: d02c405

Once you have build Hyrise and the hyriseBenchmarkTPCH executable you can start it for the TPC-H Queries (1,3,5,6,7,9,10) stated in our work in the following way (example shows Query 7):

./hyriseBenchmarkTPCH --mode PermutedQuerySets --queries 7 -r 1 -s 1

Once the data has been generated and tables are loaded, you will be prompted the following:

"Enter to start Process ID xxxxx"

At this point in time you have to attach the Cache Line Utilization Pin Tool using:

./pin -pid xxxxx -t ./source/tools/CacheLineUtilization/obj-intel64/clutil.so -c 16384 -o ~/clutil-hyrise-Q7


Once the Pin Tool is attached, please press any key for hyrise to start the processing the query.

If the query is executed and all cache behaviour simulated, hyrise will prompt the following:

"Enter to finalize"

Please stop (e.g., kill xxxxx) the hyrise process, to allow the Pin Tool to finalize data collection and output the results to ~/clutil-hyrise-Q7


# Measuring Peloton
Follow the install instructions to install [Peloton](https://github.com/cmu-db/peloton/wiki/Installation).

For our work and the following instructions, please use the commit tag: 5878dc7

Please set Peloton to work in a single threaded mode by adjusting the file src/common/init.cpp 

Once you have a run a version of peloton using

./bin/peloton -codegen=false -port=15795

you can connect to it via

psql "sslmode=disable" -U postgres -p 15795 -d tpch -h localhost

At this point you can execute the following the commands from the following files: 

sql-commands/create-tpch-peloton.sql    (creates the database and tables)

sql-commands/insert.sql    (inserts the data generated for the TPC-H benchmark, we limit the size uploaded to this repository, please generate data with a scale factor of 1 according to the TPC-H benchmark, e.g. using [tpch-dbgen](https://github.com/electrum/tpch-dbgen))

Once this is done, attach the Cache Line Utilization Pin Tool using

sudo ./pin -pid ProcessIDPeloton -t ./source/tools/CacheLineUtilization/obj-intel64/clutil.so -c 16384 -o ~/clutil-peloton-Q1
To retrieve Peloton's process id you could use: ps aux | grep peloton 

Once the Pin Tool is attached, execute one of the sql queries provided in 

sql-commands/tpch-queries-peloton.sql

Note some of them have been slightly modified to fully work with the given setup



# Measuring Quickstep
Follow the install instructions to install [Quickstep](https://github.com/apache/incubator-quickstep).

Once installed please use the following to set the number of workers to 1

./quickstep_cli_shell --num_workers=1

Use the commands in sql-commands/create-tpch-quickstep.sql to create the tables, either in row or column format (both are included)

Afterwards load data using the commands in sql-commands/insert-quickstep.sql (example data is given in sql-commands/tpch-data/quickstep but limited in size, please generate data with a scale factor of 1 according to the TPC-H benchmark, e.g. using [tpch-dbgen](https://github.com/electrum/tpch-dbgen))


Once this is done, attach the Cache Line Utilization Pin Tool using

sudo ./pin -pid ProcessIDQuickstep -t ./source/tools/CacheLineUtilization/obj-intel64/clutil.so -c 16384 -o ~/clutil-quickstep-Q1
To retrieve Quicksteps's process id you could use: ps aux | grep quickstep

Once the Pin Tool is attached, execute one of the sql queries provided in 

sql-commands/tpch-queries-quickstep.sql
