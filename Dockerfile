FROM ghcr.io/openfaas/classic-watchdog:0.1.5 as watchdog
FROM selenium/standalone-chrome:91.0

USER root

# Get watchdog binary
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

# Install python
RUN apt-get update \
    && apt-get install -y ca-certificates python3-pip vim \
    && rm -rf /var/lib/apt/lists/

# Set home directory
WORKDIR /home/app/

# Configure entrypoint
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# Copy script
COPY index.py .
RUN mkdir -p function
COPY screenshot function

# Install selenium & other requierements
RUN pip3 install -r /home/app/function/requirements.txt

# Set watchdog process
ENV fprocess="python3 index.py"
EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["./entrypoint.sh"]

