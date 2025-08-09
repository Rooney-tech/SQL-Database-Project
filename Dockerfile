# Use the official SQLPage image as base
FROM lovasoa/sqlpage:latest

# Set working directory
WORKDIR /app

# Copy your SQLPage content (all files except Dockerfile)
COPY ./sqlpage/ ./

# Verify copied files (debugging step)
RUN echo "Listing /app contents:" && \
    ls -la /app && \
    echo "Checking sqlpage version:" && \
    sqlpage --version

# Expose the default SQLPage port
EXPOSE 8080

# Health check (recommended for Railway)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1

# Start SQLPage with production settings
CMD ["sqlpage"]