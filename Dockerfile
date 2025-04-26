FROM ubuntu:22.04

ARG RUNNER_VERSION="2.323.0"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && useradd -m docker && \
    apt install -y --no-install-recommends \
    jq curl wget sudo unzip build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

# Create user 'runner' and allow passwordless sudo
RUN useradd -m runner && \
    usermod -aG sudo runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN cd /home/runner && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/runner/actions-runner/bin/installdependencies.sh

# Set working directory
WORKDIR /home/runner

COPY start.sh start.sh

RUN chmod +x start.sh

# Switch to 'runner' user
USER runner

ENTRYPOINT ["./start.sh"]
