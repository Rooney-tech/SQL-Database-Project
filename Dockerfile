FROM lovasoa/sqlpage:latest

USER root
WORKDIR /app
COPY . /app

RUN chmod +x /app/sqlpage && \
    echo "📁 Contents of /app:" && ls -l /app

EXPOSE 8080
CMD ["/bin/sh", "-c", \
     "if [ -f index.sql ]; then echo '✅ index.sql found'; else echo '❌ index.sql missing'