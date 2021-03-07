FROM alpine:3.12

RUN apk update && apk add --no-cache python3 build-base libffi-dev python3-dev py3-pip

# Fix pip & install needed dependencies
RUN pip3 install --no-cache-dir --upgrade pip setuptools
#RUN pip3 install --no-cache-dir --upgrade RPI.gpio spidev smbus smbus2 paho-mqtt enviroplus
RUN pip3 install --no-cache-dir --upgrade RPI.gpio smbus paho-mqtt enviroplus

# Clean up build tools
RUN pip3 uninstall -y setuptools
RUN apk del build-base libffi-dev python3-dev py3-pip

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
