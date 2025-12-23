# 1. Use Ubuntu 24.04 to match GitHub Actions
FROM ubuntu:24.04

# 2. Install essential Linux libraries for Flutter and rendering
# libglu1-mesa and fonts-droid-fallback are critical for Golden Tests
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip xz-utils libglu1-mesa ca-certificates \
    fonts-droid-fallback libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

# 3. Create non-root user to run Flutter and tests
RUN groupadd --system flutter && \
    useradd --system --create-home --gid flutter flutter

# 4. Install Flutter (Set to 3.29.2 to match your GitHub Workflow)
ENV FLUTTER_VERSION="3.29.2"
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \
    tar -xf flutter.tar.xz -C /opt && \
    rm flutter.tar.xz

# 5. Set Path
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# 6. Prepare Flutter environment
RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter precache

# 7. Set working directory
WORKDIR /app

# 8. Copy pubspec files first for better caching and install dependencies
COPY pubspec.yaml pubspec.lock ./
RUN chown flutter:flutter pubspec.yaml pubspec.lock /app
USER flutter
RUN flutter pub get

# 9. Copy the rest of the application as non-root
COPY --chown=flutter:flutter . .