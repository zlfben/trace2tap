Trace2TAP: Synthesizing Trigger-Action Programs From Traces of Behavior
===
# Introduction
This repository reproduces the result from our paper "Trace2TAP: Synthesizing Trigger-Action Programs From Traces of Behavior" based on anonymized data collected from our user study.

You can build the fullstack web-application we used in our user study which are executed in several docker containers.

# Pre-requisites
You need to install docker, docker-compose and git-lhs on your local machine.
 - [Setting up docker](https://docs.docker.com/engine/install/)
 - [Setting up docker-compose](https://docs.docker.com/compose/install/)
 - [Setting up git-lhs](https://git-lfs.github.com/)

The following building process does not support Windows or Windows Subsystem Linux. We tested it on native Ubuntu 18.04 and 20.04.

# Download Trace2TAP
```console
git clone https://github.com/zlfben/trace2tap.git
```

# Build Trace2TAP
```console
./start_server_dev.sh --data data/data-anonymous.sql data/iotcore.sql
```
This will build all our images and run the containers. It will start a local web-application at port 80.

# Test our interface
Goto "localhost/" in the browser and use the following credentials to log in with our participants trace (anonymized).
 - Username: superifttt-p* (p=1-7)
 - Password: anything (We disabled the authentication process for local run).

# See the results in our user study
## Interview coding
The coding of the interview can be found at data/Trace2TAP-Coding.xlsx.
## Rules synthesized in the interview
In the terminal, run:
```console
docker-compose -f docker-compose.dev.yml exec backend python3 manage.py review list
```
This shows a list of pages participants saw in their interviews. To check one of them in detail, run:
```console
docker-compose -f docker-compose.dev.yml exec backend python3 manage.py review show -i <id>
```
