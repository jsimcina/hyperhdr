FROM debian:bookworm-slim as build

RUN groupadd -f hyperhdr || true && \
    useradd --uid ${UID:-1000} --gid ${GID:-1000} --no-create-home --disabled-password hyperhdr || true && \
    mkdir -p /config \
    chown ${UID:-1000}:${GID:-1000} /config 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends git cmake build-essential \
    libasound2-dev qtbase5-dev libqt5serialport5-dev libqt5sql5-sqlite libqt5svg5-dev libqt5x11extras5-dev libusb-1.0-0-dev \
    python3-minimal rpm libcec-dev libxcb-image0-dev libxcb-util0-dev libxcb-shm0-dev libglvnd-dev \
    libxcb-render0-dev libxcb-randr0-dev libxrandr-dev libxrender-dev libavahi-core-dev libavahi-compat-libdnssd-dev \
    libjpeg-dev libturbojpeg0-dev libssl-dev zlib1g-dev ca-certificates curl wget dialog apt-utils lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN curl -fsSL https://awawa-dev.github.io/hyperhdr.public.apt.gpg.key | dd of=/usr/share/keyrings/hyperhdr.public.apt.gpg.key \
    && chmod go+r /usr/share/keyrings/hyperhdr.public.apt.gpg.key \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hyperhdr.public.apt.gpg.key] https://awawa-dev.github.io $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hyperhdr.list > /dev/null \
    && apt update \
    && apt install hyperhdr -y \
    && apt-get clean

EXPOSE 8090 19444 19445

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]