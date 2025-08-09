FROM lovasoa/sqlpage:latest

WORKDIR /app

COPY index.sql /app/index.sql


RUN echo "Listing /app contents:" && ls -l /app


EXPOSE 8080

CMD ["sqlpage"]
