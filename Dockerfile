FROM debian:buster-slim

#RUN apt-get update && apt-get install -y build-essential zlib1g-dev libjpeg-dev libfreetype6-dev libffi-dev python3 python3-pip
RUN apt-get update && apt-get install -y build-essential libffi-dev python3 python3-pip --no-install-recommends

# Fix pip & install needed dependencies
#RUN pip3 install --upgrade pip
RUN pip3 install --upgrade pip setuptools
#RUN pip3 install --no-cache-dir -U setuptools RPI.gpio numpy spidev Pillow paho-mqtt smbus smbus2 enviroplus
RUN pip3 install --no-cache-dir -U RPI.gpio numpy spidev smbus smbus2 paho-mqtt enviroplus

# Clean up build tools
RUN pip3 uninstall setuptools
#RUN apt-get remove --purge build-essential python3-pip && rm -rf /tmp/*
RUN apt-get purge --auto-remove build-essential python3-pip && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*

COPY src/ src/

ENV MQTT_HOST=
ENV MQTT_PORT=
ENV MQTT_USERNAME=
ENV MQTT_PASSWORD=
ENV MQTT_PREFIX=
ENV MQTT_CLIENT_ID=
ENV INTERVAL=
ENV STARTUP_DELAY=
ENV ENABLE_PMS5003=
ENV ENABLE_GAS=

CMD python3 /src/main.py
