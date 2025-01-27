#!/bin/bash
BASE_DIR="./certs"
CA_DIR="$BASE_DIR/ca"
SERVER_DIR="$BASE_DIR/server"
DEVICES_DIR="$BASE_DIR/devices"

CA_KEY="$CA_DIR/ca.key"
CA_CERT="$CA_DIR/ca.crt"

DAYS_VALID=36500

mkdir -p "$CA_DIR" "$SERVER_DIR" "$DEVICES_DIR"

# Set permissions for directories
chmod -R 777 "$BASE_DIR"
chown -R $(id -u):$(id -g) "$BASE_DIR"

generate_ca() {
    if [ ! -f "$CA_CERT" ]; then
        echo "Generating CA certificate..."
        openssl genrsa -out "$CA_KEY" 2048
        openssl req -x509 -new -nodes -key "$CA_KEY" -sha256 \
            -days $DAYS_VALID \
            -subj "/C=US/ST=State/L=City/O=Organization/OU=Org Unit/CN=Your_CA" \
            -out "$CA_CERT"
        echo "CA certificate generated at $CA_CERT"
        chmod 777 "$CA_KEY" "$CA_CERT"
    else
        echo "CA certificate already exists. Skipping generation."
    fi
}

generate_server_cert() {
    SERVER_KEY="$SERVER_DIR/server.key"
    SERVER_CSR="$SERVER_DIR/server.csr"
    SERVER_CERT="$SERVER_DIR/server.crt"

    if [ ! -f "$SERVER_CERT" ]; then
        echo "Generating server certificate..."
        openssl genrsa -out "$SERVER_KEY" 2048
        openssl req -new -key "$SERVER_KEY" \
            -subj "/C=US/ST=State/L=City/O=Organization/OU=Org Unit/CN=emqx.romaksystem.com" \
            -out "$SERVER_CSR"

        openssl x509 -req -in "$SERVER_CSR" -CA "$CA_CERT" -CAkey "$CA_KEY" \
            -CAcreateserial -out "$SERVER_CERT" -days $DAYS_VALID -sha256
        echo "Server certificate generated at $SERVER_CERT"
        chmod 777 "$SERVER_KEY" "$SERVER_CSR" "$SERVER_CERT"
    else
        echo "Server certificate already exists. Skipping generation."
    fi
}

generate_device_cert() {
    DEVICE_ID=$1
    DEVICE_KEY="$DEVICES_DIR/$DEVICE_ID.key"
    DEVICE_CSR="$DEVICES_DIR/$DEVICE_ID.csr"
    DEVICE_CERT="$DEVICES_DIR/$DEVICE_ID.crt"

    if [ ! -f "$DEVICE_CERT" ]; then
        echo "Generating certificate for device: $DEVICE_ID"
        openssl genrsa -out "$DEVICE_KEY" 2048
        openssl req -new -key "$DEVICE_KEY" \
            -subj "/C=US/ST=State/L=City/O=Organization/OU=IoT Devices/CN=$DEVICE_ID" \
            -out "$DEVICE_CSR"

        openssl x509 -req -in "$DEVICE_CSR" -CA "$CA_CERT" -CAkey "$CA_KEY" \
            -CAcreateserial -out "$DEVICE_CERT" -days $DAYS_VALID -sha256
        echo "Generated device certificate and key for: $DEVICE_ID"
        chmod 777 "$DEVICE_KEY" "$DEVICE_CSR" "$DEVICE_CERT"
    else
        echo "Certificate for device $DEVICE_ID already exists. Skipping generation."
    fi
}

main() {
    echo "Starting certificate generation..."
    generate_ca
    generate_server_cert

    while true; do
        echo -n "Enter device ID (or type 'q' to finish): "
        read DEVICE_ID

        if [ "$DEVICE_ID" = "q" ]; then
            echo "Certificate generation completed."
            break
        fi

        if [ -n "$DEVICE_ID" ]; then
            generate_device_cert "$DEVICE_ID"
        else
            echo "Device ID cannot be empty. Please try again."
        fi
    done

    # Final permissions adjustment
    chmod -R 777 "$BASE_DIR"
    chown -R $(id -u):$(id -g) "$BASE_DIR"

    echo "All certificates have been generated in $BASE_DIR/"
    echo "Done!"
}

main
