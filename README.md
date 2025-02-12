# Converted verion of Autobase

## Console Directory

Dockernized Frontend of Autobase. Main user interface for provisioning and managing high availability postgres database cluster. It's a command center with some bare bone basic time series monitoring capabilities. It's also unfinished and brittle. Not reccommed for production usage.

Server-side component for autobase console. This REST service implements the API for UI integration.

The project is written in Go and uses Swagger for server-side code generation. The server receives requests from the web to create and manage clusters. Under the hood, the server uses Docker to run autobase/automation image with Ansible playbooks for cluster deployment logic.

This project uses [Goose](https://github.com/pressly/goose) for versioning and managing database schema changes. Goose is a database migration tool that enables database version control, much like Git does for source code. It allows defining and tracking changes in the database schema over time, ensuring consistency and reproducibility. The backend service is responsible for applying migrations.

For more information on using Goose, see the [Goose documentation](https://github.com/pressly/goose).

### console\Dockerfile

Main image for Autobase frontend. This script install and setup a simple container for basic control and monitor postgres database cluster. It also shows how much of a cash grab autobase is. Tutorial level app aiming at clueless businesses and developer. It is little more than a wrapper for the basic Patroni; HAProxy; etcd HA cluster specifically coded for postgres.

### [supervisord](https://supervisord.org/)

Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.

It shares some of the same goals of programs like launchd, daemontools, and runit. Unlike some of these programs, it is not meant to be run as a substitute for init as “process id 1”. Instead it is meant to be used to control processes related to a project or a customer, and is meant to start like any other program at boot time.

supervisord.conf file is its config file used in controlling predefined processes running in console ui's containers.

---

## Automation Directory

This is the meat of autobase. Ansible and Yml files for configuration and provisioning of Postgres HA cluster on local host. The server cluster is used as infrastructure where dockernized nodes will run as services for Postgres HA database cluster.

Nodes for consul; HAProxy; etcd; patroni.

This direcory holds Dockerfile defining image use for each node in Postgres HA which is all equal since they could be voted in as cluster leader at any point. Thus there also ansible scripts (.yml) for various tasks of both worker and leader node.

### automation\Dockerfile

Base docker image for other infrastructure node containers to build on.
