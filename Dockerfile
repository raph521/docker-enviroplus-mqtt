FROM debian:buster-slim

RUN apt-get update && apt-get install -y build-essential git zlib1g-dev libjpeg-dev libfreetype6-dev libffi-dev libportaudio2 alsa-utils python3 python3-pip

# Fix pip & install needed dependencies
RUN pip3 install --upgrade pip
RUN pip3 install -U setuptools RPI.gpio numpy spidev Pillow paho-mqtt smbus smbus2 sounddevice enviroplus

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
