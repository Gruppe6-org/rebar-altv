FROM node:20-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Install and setup pnpm
RUN npm install -g pnpm
RUN pnpm setup
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Set working directory
WORKDIR /app

# Clone Rebar repository
RUN git clone https://github.com/Stuyk/rebar-altv/ .

# Enable pnpm store
RUN pnpm config set store-dir /app/.pnpm-store

# Install dependencies with proper environment
SHELL ["/bin/bash", "-c"]
RUN source ~/.bashrc && \
    pnpm install

# Download alt:V binaries
RUN pnpm binaries

# Set execute permissions for alt:V binaries
RUN chmod +x altv-server altv-crash-handler

# Build the application
RUN pnpm build

# Expose alt:V server ports
EXPOSE 7788/udp
EXPOSE 7788/tcp

# Start the server
CMD ["./altv-server"] 