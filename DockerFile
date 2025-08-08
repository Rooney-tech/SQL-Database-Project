FROM ghcr.io/lovasoa/sqlpage:latest
COPY . /app
WORKDIR /app
EXPOSE 8080
CMD [ "serve" ]