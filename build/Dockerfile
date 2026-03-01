FROM rakuri255/ultrasinger@sha256:03c9b84d24ff42e6f058de846edf9854b9f3c6149cbe8ce58d2ea654b5fc2627


# fix existing broken user
USER root
RUN groupadd -g 1000 appgroup && \
    useradd -u 1000 -g appgroup -m -s /bin/bash appuser
USER 1000:1000

# install musicscore
USER root
ENV QT_QPA_PLATFORM=offscreen
RUN apt-get update && \
    apt-get install -y musescore && \
    rm -rf /var/lib/apt/lists/*
USER 1000:1000

# install deno, required for yt-dlp
USER root
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh -s -- --no-modify-path -y
USER 1000:1000

# upgrade yt-dlp
RUN pip install -U "yt-dlp[default]"
