FROM emqx:5.7.0


USER root

RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /opt/emqx/entrypoint.sh
RUN chmod +x /opt/emqx/entrypoint.sh

ENTRYPOINT ["/opt/emqx/entrypoint.sh"]

USER emqx

