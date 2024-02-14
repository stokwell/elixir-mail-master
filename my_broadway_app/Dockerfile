# Use the official Elixir image from Docker Hub
FROM elixir:1.16

# Set environment variables for the build
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Install hex package manager and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create a directory for the application code
WORKDIR /app

# Copy the mix.exs and mix.lock files to the container
COPY mix.* ./

# Install dependencies
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile the application
RUN mix compile

# Expose any ports your application may need
EXPOSE 4000

# Command to run the application
CMD ["mix", "run", "--no-halt"]
