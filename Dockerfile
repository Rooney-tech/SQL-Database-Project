FROM lovasoa/sqlpage:latest

USER root
WORKDIR /app
COPY . /app

EXPOSE 8080

# ✅ Build-time verification
RUN echo "📁 Verifying /app contents:" && ls -l /app && \
    echo "📄 index.sql preview:" && head -n 10 /app/index.sql || echo "❌ index.sql not found"

# ✅ Runtime diagnostics + launch
ENTRYPOINT ["/bin/sh", "-c", "\
  echo '📁 Contents of /app:' && ls -l /app && \
  if [ -f index.sql ]; then \
    echo '✅ index.sql found'; \
  else \
    echo '❌ index.sql missing'; \
  fi && \
  exec sqlpage"]