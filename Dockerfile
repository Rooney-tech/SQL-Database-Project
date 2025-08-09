FROM lovasoa/sqlpage:latest

WORKDIR /app

COPY . /app

# Optional: List contents for debugging
RUN echo "📁 Contents of /app:" && ls -l /app

EXPOSE 8080

# ✅ Check for index.sql before running sqlpage
CMD ["/bin/sh", "-c", "if [ -f index.sql ]; then echo '✅ index.sql found'; else echo '❌ index.sql missing'; fi && sqlpage"]