# Converted verion of Autobase

## Console Directory

Dockernized Frontend of Autobase. Main user interface for provisioning and managing high availability postgres database cluster. It's a command center with some bare bone basic time series monitoring capabilities. It's also unfinished and brittle. Not reccommed for production usage.

### Dockerfile

Main image for Autobase frontend. This script install and setup a simple container for basic control and monitor postgres database cluster. It also shows how much of a cash grab autobase is. Tutorial level app aiming at clueless businesses and developer. It is little more than a wrapper for the basic Patroni; HAProxy; etcd HA cluster specifically coded for postgres.
