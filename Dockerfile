# 🐳 Base image
FROM lovasoa/sqlpage:latest

# 👤 Optional: switch to root if needed for permissions
# USER root

# 📁 Set working directory
WORKDIR /var/www

# 📦 Copy all project files into container
COPY . /var/www/

# 🌐 Expose SQLPage default port
EXPOSE 8080

# ✅ Build-time verification
RUN echo "📁 Verifying /var/www contents:" && ls -l /var/www && \
    echo "📄 index.sql preview:" && head -n 10 /var/www/index.sql || echo "❌ index.sql not found"

# 🚀 Runtime diagnostics + SQLPage launch
ENTRYPOINT ["/bin/sh", "-c", "\
  echo '📁 Contents of /var/www:' && ls -l /var/www && \
  if [ -f /var/www/index.sql ]; then \
    echo '✅ index.sql found'; \
  else \
    echo '❌ index.sql missing'; \
  fi && \
  exec sqlpage"]