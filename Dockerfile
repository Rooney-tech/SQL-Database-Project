FROM lovasoa/sqlpage:latest

WORKDIR /app

COPY . .

EXPOSE 8080

CMD ["sqlpage"]