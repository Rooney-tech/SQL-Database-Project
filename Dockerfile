FROM Rooney-tech/sqlpage:latest

WORKDIR /app

COPY . /app

RUN echo "Listing /app contents:" && ls -l /app


EXPOSE 8080

CMD ["sqlpage"]