FROM python:3-alpine

COPY requirements.txt /tmp/requirements.txt

RUN apk add --no-cache --virtual .build-deps build-base libffi-dev python3-dev py3-pip \
    && \
    pip3 install --no-cache-dir --upgrade setuptools \
    && \
    pip3 install --no-cache-dir --upgrade -r /tmp/requirements.txt \
    && \
    pip3 uninstall -y setuptools \
    && \
    apk del .build-deps

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
