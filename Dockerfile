FROM ghcr.io/lovasoa/sqlpage:latest

WORKDIR /var/www

COPY . .

EXPOSE 8080

CMD ["sqlpage"]