FROM lovasoa/sqlpage:latest

WORKDIR /app

COPY . /app


EXPOSE 8080

CMD ["sqlpage"]