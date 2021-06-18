# Enviro+ MQTT Logger

`ghcr.io/raph521/enviroplus-mqtt` is a Python service that publishes environmental data from an [Enviro+](https://shop.pimoroni.com/products/enviro-plus) (or Enviro) via MQTT.

## Setting Up Your Device

1) Set up your RPi as you normally would.
2) Connect the Enviro+ board, and the PMS5003 sensor if you are using one.
3) Install the Enviro+ library by following the instructions at https://github.com/pimoroni/enviroplus-python/ (make sure the library is installed for Python 3)

## TODO
- Enviro libraries should not be necessary on host OS.  Need to test on base install.
- Need to test how to enable sensor without installing full library onto base OS
- Need to test whether privileged is necessary, or if /dev can be passed in as volume

## Supported Arguments

- The MQTT host, port, username, password and client ID can be specified.
- The update interval can be specified, and defaults to 5 seconds.
- The initial delay before publishing readings can be specified, and defaults to 15 seconds.
- The gas sensor is not available on the enviro, only the Enviro+.  Enabling it on the Enviro will not work.
- If you are using a PMS5003 sensor, enable it by setting the `ENABLE_PMS5003` environment varilable to `1`.

| Variable | Default | Description |
| --- | --- | --- |
| `MQTT_HOST` | | the MQTT host to connect to |
| `MQTT_PORT` | `1883` | the port on the MQTT host to connect to |
| `MQTT_USERNAME` | | the MQTT username to connect with |
| `MQTT_PASSWORD` | | the MQTT password to connect with |
| `MQTT_PREFIX` | | the topic prefix to use when publishing readings, i.e. `lounge/enviroplus` |
| `MQTT_CLIENT_ID` | | the MQTT client identifier to use when connecting |
| `INTERVAL` | `5` | the duration in seconds between updates |
| `STARTUP_DELAY` | `15` |  the duration in seconds to allow the sensors to stabilize before starting to publish readings |
| `ENABLE_PMS5003` | `0` | if set to `1`, the PM readings will be taken from the PMS5003 sensor |
| `ENABLE_GAS` | `0` | if set to `1`, readings will be taken from the gas sensor; should only be enabled on Enviro+, not Enviro |

## Published Topics

Readings will be published to the following topics:

- `<prefix>/proximity`
- `<prefix>/lux`
- `<prefix>/temperature`
- `<prefix>/pressure`
- `<prefix>/humidity`
- `<prefix>/gas/oxidising`
- `<prefix>/gas/reducing`
- `<prefix>/gas/nh3`
- `<prefix>/particulate/1.0`
- `<prefix>/particulate/2.5`
- `<prefix>/particulate/10.0`
