FROM nginx:1.25-alpine

# Set metadata
LABEL maintainer="ARZ Haan AG"
LABEL description="IKT-Vorfall Bewertungsanwendung"
LABEL version="1.0.0"

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy our custom Nginx configuration first (for better caching)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the health check script
COPY healthcheck.sh /usr/share/nginx/html/healthcheck.sh
RUN chmod +x /usr/share/nginx/html/healthcheck.sh

# Copy the application files to the Nginx web root
COPY . /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Set environment variables
ENV NGINX_HOST=localhost \
    NGINX_PORT=80

# Set up a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD sh /usr/share/nginx/html/healthcheck.sh || exit 1

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
