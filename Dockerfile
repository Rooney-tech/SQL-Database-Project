# 🐳 Base image
FROM lovasoa/sqlpage:latest

# 📁 Set working directory
WORKDIR /var/www

# 📦 Copy all project files into container
COPY . /var/www/

# 🌐 Expose SQLPage default port
EXPOSE 8080

# 🔐 Set default PostgreSQL connection string
ENV DATABASE_URL=postgres://avnadmin:AVNS_8rpNm2zZ2hK5zp_ov8o@pg-25309505-odagorooney6-1.f.aivencloud.com:25438/portfolio?sslmode=require

# ✅ Build-time verification
RUN echo "📁 Verifying /var/www contents:" && ls -l /var/www && \
    echo "📄 index.sql preview:" && head -n 10 /var/www/index.sql || echo "❌ index.sql not found"

# 🚀 Runtime diagnostics + SQLPage launch
ENTRYPOINT ["/bin/sh", "-c", "\
  echo '📁 Contents of /var/www:' && ls -l /var/www && \
  echo '🔐 DATABASE_URL:' && echo $DATABASE_URL && \
  if [ -f /var/www/index.sql ]; then \
    echo '✅ index.sql found'; \
  else \
    echo '❌ index.sql missing'; \
  fi && \
  exec sqlpage"]