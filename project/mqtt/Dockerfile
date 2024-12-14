FROM python:3.10.12-slim

WORKDIR /app

RUN pip install --no-cache-dir paho-mqtt

COPY subscriber.py .


CMD ["python", "subscriber.py"]
