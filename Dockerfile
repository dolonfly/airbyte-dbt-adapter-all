# Top level build args
ARG build_for=linux/amd64
FROM --platform=$build_for python:3.9-slim-bullseye as base

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

# Set docker basics
WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    python-dev \
    python3-dev \
    libsasl2-dev \
    libssl-dev \
    libffi-dev \
    gcc \
    unixodbc-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# https://docs.getdbt.com/docs/core/connect-data-platform/about-core-connections
RUN python -m pip install dbt-core dbt-redshift dbt-bigquery dbt_snowflake dbt_spark dbt_postgres


# https://github.com/dbeatty10/dbt-mysql
RUN python -m pip install dbt-mysql

# other for airbyte
# RUN python -m pip install mashumaro