# InfluxDB and Grafana

##InfluxDB

Pulling the image and checking if it is in place
```
docker pull influxdb
docker image ls
```

Creating the database
```
docker run \
  -d \
  --name influxdb \
  -p 8086:8086 \
  -e INFLUXDB_DB=telemetry \
  -e INFLUXDB_ADMIN_USER=root \
  -e INFLUXDB_ADMIN_PASSWORD=pass \
  -e INFLUXDB_HTTP_AUTH_ENABLED=true \
  influxdb
```

Checking if the port is listening
```
netstat -an | grep LIST | grep -v LISTENING
```

Verify if the database is actually there: execute the client in another container
```
docker exec -it influxdb influx -username root -password pass
Connected to http://localhost:8086 version 1.8.0
InfluxDB shell version: 1.8.0
>
> show databases
name: databases
name
----
telemetry
_internal
```

Below command shows what data is added (if any)
```
> show measurements
```

Prepare environment to run some scripts
```
env | grep influx
cat > loadEnvLocal.sh
export influxDBHost="192.168.1.100"
export influxDBPort="8086"
export influxDBUser="root"
export influxDBPass="pass"
export influxDBName="telemetry"
```

## Grafana

Install
```
docker pull grafana/grafana
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Connect to web-interface

Add data source (InfluxDB, Prometheus, Graphite, OpenTSDB)
