FROM lovasoa/sqlpage:latest

WORKDIR /SQL-Database-Project

COPY . /app

RUN echo "Listing /app contents:" && ls -l /app


EXPOSE 8080

CMD ["sqlpage"]