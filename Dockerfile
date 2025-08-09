FROM lovasoa/sqlpage:latest

WORKDIR /app

COPY . /app

# Make sure your binary is executable
RUN chmod +x /app/sqlpage && \
    echo "📁 Contents of /app:" && ls -l /app

EXPOSE 8080

# ✅ Run your local binary instead of the global one
CMD ["/bin/sh", "-c", "if [ -f index.sql ]; then echo '✅ index.sql found'; else echo '❌ index.sql missing'; fi && ./sqlpage"]