# Use an official Python runtime as a parent image
FROM registry.hub.docker.com/library/python:3.6-slim AS builder

# Set the timezone
ENV TZ=Asia/Taipei

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./ ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Use a smaller base image for the final stage
FROM registry.hub.docker.com/library/python:3.6-alpine3.12

# Set the timezone
ENV TZ=Asia/Taipei

# Install curl for the healthcheck
RUN apk update && apk add curl && rm -rf /var/cache/apk/*

# Set the working directory
WORKDIR /app

# Add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the installed packages and application code from the builder stage
COPY --from=builder /app /app

# Change ownership of the application files
RUN chown -R appuser:appgroup /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Define the health check
HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
    CMD curl -fs http://localhost:3000/ || exit 1

# Run the application
CMD ["python", "src/main.py"]