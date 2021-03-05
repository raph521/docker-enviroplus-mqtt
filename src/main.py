import argparse, time, sys, os

from logger import EnvLogger


def parse_args():
    ap = argparse.ArgumentParser(add_help=False)
    ap.add_argument("-h", "--host", required=True, help="the MQTT host to connect to")
    ap.add_argument("-p", "--port", type=int, default=1883, help="the port on the MQTT host to connect to")
    ap.add_argument("-U", "--username", default=None, help="the MQTT username to connect with")
    ap.add_argument("-P", "--password", default=None, help="the password to connect with")
    ap.add_argument("--prefix", default="", help="the topic prefix to use when publishing readings, i.e. 'lounge/enviroplus'")
    ap.add_argument("--client-id", default="", help="the MQTT client identifier to use when connecting")
    ap.add_argument("--interval", type=int, default=5, help="the duration in seconds between updates")
    ap.add_argument("--delay", type=int, default=15, help="the duration in seconds to allow the sensors to stabilise before starting to publish readings")
    ap.add_argument("--use-pms5003", action="store_true", help="if set, PM readings will be taken from the PMS5003 sensor")
    ap.add_argument("--help", action="help", help="print this help message and exit")
    return vars(ap.parse_args())

def print_usage():
    print('Error in configuration:')
    print('    MQTT_HOST      - [required] the MQTT host to connect to')
    print('    MQTT_PORT      - [optional] the port on the MQTT host to connect to (default: 1883)')
    print('    MQTT_USERNAME  - [optional] the MQTT username to connect with (default: "")')
    print('    MQTT_PASSWORD  - [optional] the password to connect with (default: "")')
    print('    MQTT_PREFIX    - [optional] the topic prefix to use when publishing readings, i.e. \'lounge/enviroplus\' (default "")')
    print('    MQTT_CLIENT_ID - [optional] the MQTT client identifier to use when connecting (default "")')
    print('    INTERVAL       - [optional] the duration in seconds between updates (default: 5)')
    print('    STARTUP_DELAY  - [optional] the duration in seconds to allow the sensors to stabilise before starting to publish readings (default: 15)')
    print('    ENABLE_PMS5003 - [optional] if set, PM readings will be taken from the PMS5003 sensor (default: 0)')
    print('    ENABLE_GAS     - [optional] if set, readings will be taken from the gas sensor, available on enviroplus only (default: 0)')


def main():
    #args = parse_args()

    mqttHost      = os.getenv('MQTT_HOST')
    mqttPort      = os.getenv('MQTT_PORT')
    mqttUser      = os.getenv('MQTT_USERNAME')
    mqttPass      = os.getenv('MQTT_PASSWORD')
    mqttPrefix    = os.getenv('MQTT_PREFIX')
    mqttClientID  = os.getenv('MQTT_CLIENT_ID')
    interval      = os.getenv('INTERVAL')
    startupDelay  = os.getenv('STARTUP_DELAY')
    enablePMS5003 = os.getenv('ENABLE_PMS5003')
    enableGas     = os.getenv('ENABLE_GAS')

    if mqttHost is None:
        # Required
        print_usage()
        sys.exit()

    if mqttPort == "":
        # Default to 1883
        mqttPort = 1883

    if mqttPrefix is None:
        # Default to empty string ("")
        mqttPrefix = ""

    if mqttClientID is None:
        # Default to empty string ("")
        mqttClientID = ""

    if interval == "":
        # Default to 5 seconds
        interval = 5

    if startupDelay == "":
        # Default to 15 seconds
        startupDelay = 15

    if enablePMS5003 == "":
        # Default to 0 (not enabled)
        enablePMS5003 = 0

    if enableGas == "":
        # Default to 0 (not enabled)
        enableGas = 0

    # Initialise the logger
    #logger = EnvLogger(
    #    client_id=args["client_id"],
    #    host=args["host"],
    #    port=args["port"],
    #    username=args["username"],
    #    password=args["password"],
    #    prefix=args["prefix"],
    #    use_pms5003=args["use_pms5003"],
    #    num_samples=args["interval"]
    #)

    logger = EnvLogger(
        client_id=mqttClientID,
        host=mqttHost,
        port=int(mqttPort),
        username=mqttUser,
        password=mqttPass,
        prefix=mqttPrefix,
        use_pms5003=int(enablePMS5003),
        num_samples=int(interval),
        use_gas=int(enableGas)
    )

    # Take readings without publishing them for the specified delay period,
    # to allow the sensors time to warm up and stabilise
    publish_start_time = time.time() + startupDelay
    while time.time() < publish_start_time:
        logger.update(publish_readings=False)
        time.sleep(1)

    # Start taking readings and publishing them at the specified interval
    next_sample_time = time.time()
    next_publish_time = time.time() + interval

    while True:
        if logger.connection_error is not None:
            sys.exit(f"Connecting to the MQTT server failed: {logger.connection_error}")
        
        should_publish = time.time() >= next_publish_time
        if should_publish:
            next_publish_time += interval
        
        logger.update(publish_readings=should_publish)

        next_sample_time += 1
        sleep_duration = max(next_sample_time - time.time(), 0)
        time.sleep(sleep_duration)

    logger.destroy()


if __name__ == "__main__":
    main()
