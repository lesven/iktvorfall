FROM nginx:alpine

# Add build timestamp to prevent caching
RUN echo "Build timestamp: $(date)" > /build_timestamp

# Disable Nginx cache
RUN sed -i 's/open_file_cache.*/open_file_cache off;/' /etc/nginx/nginx.conf \
    && sed -i '/gzip/d' /etc/nginx/nginx.conf \
    && sed -i 's/client_max_body_size.*/client_max_body_size 100M;/' /etc/nginx/nginx.conf

# Copy our custom Nginx configuration first
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the application files to the Nginx web root
COPY . /usr/share/nginx/html/

# Create a unique version ID for this build
RUN echo "const BUILD_TIMESTAMP = '$(date +%Y%m%d%H%M%S)_$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)';" > /usr/share/nginx/html/build_id.js \
    && echo "<script>console.log('Build ID: ' + BUILD_TIMESTAMP);</script>" >> /usr/share/nginx/html/build_id.js

# Create a cache-busting HTML fragment to load in the main HTML
RUN echo "<script src=\"build_id.js?v=$(date +%s)\"></script>" > /usr/share/nginx/html/cache_buster.html

# Update app version in HTML
RUN sed -i -e 's|</head>|<script src="build_id.js?v=$(date +%s)"></script></head>|g' /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx in foreground with extra caching configuration
CMD ["nginx", "-g", "daemon off; proxy_buffering off;"]
