# Build stage - using dart image for more stability
FROM dart:stable AS build
WORKDIR /app

# Install Flutter manually for better control
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:${PATH}"

# Configure Flutter
RUN flutter doctor -v
RUN flutter config --enable-web --no-analytics

# Copy pubspec files first for dependency caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source and build
COPY lib ./lib
COPY web ./web
COPY analysis_options.yaml ./
RUN flutter build web --release

# Runtime stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]