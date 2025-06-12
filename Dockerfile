FROM nginx:alpine

# Add timestamp to prevent caching during builds
RUN echo "Build timestamp: $(date)" > /build_timestamp

# Copy the application files to the Nginx web root
COPY . /usr/share/nginx/html/

# Copy our custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Add a version.js file with timestamp to force reload
RUN echo "const BUILD_TIMESTAMP = '$(date)'; console.log('App version loaded at: ' + BUILD_TIMESTAMP);" > /usr/share/nginx/html/version.js

# Expose port 80
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
