FROM python:3.10-slim-bullseye

RUN \
    adduser --disabled-password --disabled-login --gecos "" app && \
    mkdir -p /opt/data_engineer && \
    apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR "/opt/data_engineer"

COPY ./requirements.txt ./requirements.txt

RUN pip install --progress-bar off --no-cache-dir -r ./requirements.txt

COPY . .
RUN chown -R app:app /opt/data_engineer
RUN chmod +x ./entrypoint.sh

WORKDIR "/opt/data_engineer/dbt"

USER app

CMD tail -f /dev/null