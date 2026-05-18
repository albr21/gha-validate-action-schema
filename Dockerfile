FROM ghcr.io/albr21/python-3.13:1.0.0-alpine

RUN pip install --no-cache-dir check-jsonschema

COPY entrypoint.sh /entrypoint.sh
COPY schemas /schemas

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]