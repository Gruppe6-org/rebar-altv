FROM node:20-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Clone Rebar repository
RUN git clone https://github.com/Stuyk/rebar-altv/ .

# Install dependencies
RUN pnpm install

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