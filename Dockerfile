#this Dockerfile uses for DIND(docker in Docker) to run docker commands inside the container

Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and Docker packages
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    iptables \
    iproute2 \
    sudo \
    gnupg2 \
    software-properties-common \
    uidmap \
    bash && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create Docker data dir (optional)
RUN mkdir /var/lib/docker

# Entrypoint: start dockerd in background, then keep container alive
CMD ["sh", "-c", "dockerd & while true; do sleep 30; done"]
