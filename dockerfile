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

# 4. Install Flutter 3.32.0 to match GitHub Actions
ENV FLUTTER_VERSION="3.32.0"
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz && \
    tar -xf flutter.tar.xz -C /opt && \
    rm flutter.tar.xz && \
    # IMPORTANT: Give the flutter user ownership of the SDK
    chown -R flutter:flutter /opt/flutter

# 5. Set Path
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# 6. Switch to non-root user for the rest of the setup
USER flutter
WORKDIR /app

# 7. Prepare Flutter environment
RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter precache

# 8. Copy pubspec files and get dependencies
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./
RUN flutter pub get

# 9. Copy the rest of the application
COPY --chown=flutter:flutter . .