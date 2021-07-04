FROM ghcr.io/openfaas/classic-watchdog:0.1.5 as watchdog

FROM selenium/standalone-chrome:91.0

USER root

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

# Install python
RUN apt-get update \
    && apt-get install -y ca-certificates python3-pip vim \
    && rm -rf /var/lib/apt/lists/

WORKDIR /home/app/

COPY index.py           .

RUN mkdir -p function
RUN touch ./function/__init__.py

COPY screenshot/requirements.txt	/home/app/function/

RUN pip3 install -r /home/app/function/requirements.txt

WORKDIR /home/app/

USER root

COPY screenshot           function

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENV fprocess="python3 index.py"
EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["./entrypoint.sh"]

