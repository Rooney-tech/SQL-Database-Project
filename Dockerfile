FROM lovasoa/sqlpage:latest

USER root
WORKDIR /app
COPY . /app

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "\
  echo '📁 Contents of /app:' && ls -l /app && \
  if [ -f index.sql ]; then \
    echo '✅ index.sql found'; \
  else \
    echo '❌ index.sql missing'; \
  fi && \
  exec sqlpage"]