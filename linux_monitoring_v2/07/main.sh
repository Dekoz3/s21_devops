#!/bin/bash

#install prometheus

#a. Download the latest Prometheus release:
wget https://github.com/prometheus/prometheus/releases/download/v2.32.0/prometheus-2.32.0.linux-amd64.tar.gz
#b. Extract the archive:
tar xvfz prometheus-*.tar.gz
cd prometheus-2.*
#c. Move the Prometheus binary files to /usr/local/bin:
sudo mv prometheus promtool /usr/local/bin/
#d. Create the Prometheus configuration directory and copy the configuration file:
sudo mkdir /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/
#e. Create a Prometheus system user and set directory permissions:
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
#f. Create the Prometheus data directory and set permissions:
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
#Create a Prometheus systemd service file:
sudo vim /etc/systemd/system/prometheus.service

#Add the following content to the file:
cat <<EOF >vim /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, start Prometheus, and enable it to run at boot:
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# To download and set up Node Exporter, follow these steps:
sudo useradd --system --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/


#node_exporter.service:
# sudo vim /etc/systemd/system/node_exporter.service
#Add the following content to the file:
cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
--collector.logind

[Install]
WantedBy=multi-user.target

#Start Node Exporter
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter

#Create a static target for Node Exporter:
sudo vim /etc/prometheus/prometheus.yml
#Add this at the end of file:
- job_name: "node_export"
static_configs:
- targets: ["localhost:9100"]
EOF


#install grafana
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana

#Start Grafana and enable it to run at boot:
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server


#Access Prometheus and Grafana web interfaces:
#a. From your local machine, create an SSH tunnel to the VM for both Prometheus and Grafana:
ssh -L 9090:localhost:9090 -L 3000:localhost:3000 user@your_VM_IP
#b. Access Prometheus at http://localhost:9090
#c. Access Grafana at http://localhost:3000 (default login is admin for both username and password).

#Add Prometheus as a data source in Grafana:
#a. Log in to Grafana and click on the gear icon (Configuration) on the left sidebar.
#b. Click on "Data Sources" and then "Add data source."
#c. Select "Prometheus" as the data source type.
#d. In the URL field, enter http://localhost:9090.
#e. Click on "Save & Test" to verify the connection.

#Create a new dashboard in Grafana with CPU, available RAM, free space, and I/O operations panels:
#a. Click on the "+" icon on the left sidebar and select "Dashboard."
#b. Click on "Add new panel."
#c. Configure each panel with the appropriate PromQL query. Some examples are:
#
#    CPU Usage: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)
#    Available RAM: node_memory_MemAvailable_bytes
#    Free Disk Space: node_filesystem_free_bytes
#    I/O Operations: rate(node_disk_io_time_seconds_total[1m])
#    d. Adjust the visualization settings as desired and save the dashboard.