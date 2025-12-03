FROM dart:3.10.3-sdk AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

# Ensure packages are still up-to-date if anything has changed.
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/worker

# Build minimal bot image from AOT-compiled '/bot'
# libraries and configuration files stored in '/runtime/'
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/bin/worker worker

CMD ["/worker"]