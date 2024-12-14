import paho.mqtt.client as mqtt
import time

BROKER = "emqx.romaksystem.com"
PORT = 1883
TOPIC = "server/#"
USER = "hirkan01"
PASSWORD = "qazwsx"

def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect, return code {reason_code}\n", flush=True)
    else:

        print("Connected to MQTT Broker!", flush=True)
        client.subscribe(TOPIC)

def on_message(client, userdata, msg):
    print(f"Received message: {msg.topic} -> {msg.payload.decode()}", flush=True)

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2,protocol=mqtt.MQTTv5)
client.on_connect = on_connect
client.on_message = on_message

while True:
    try:
        client.username_pw_set(USER, PASSWORD)
        client.connect(BROKER, PORT, 60)
        client.loop_forever()
    except Exception as e:
        print(f"Connection error: {e}, retrying in 5 seconds...", flush=True)
        time.sleep(5)

