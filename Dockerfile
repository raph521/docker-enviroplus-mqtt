FROM debian:buster-slim

RUN apt-get update && apt-get install -y build-essential libffi-dev python3 python3-pip python3-dev --no-install-recommends

# Fix pip & install needed dependencies
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir --upgrade RPI.gpio spidev smbus smbus2 paho-mqtt enviroplus

# Clean up build tools
RUN pip3 uninstall -y setuptools
RUN apt-get purge -y --auto-remove build-essential python3-pip python3-dev && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*

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
