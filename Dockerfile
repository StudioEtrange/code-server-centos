# Build code-server and vscode from scratch

# clone of https://github.com/cdr/code-server/blob/master/Dockerfile
# More information into https://github.com/cdr/code-server/tree/master/scripts

# You can use this built binary inside another Dockerfile with
#	FROM studioetrange/code-server-centos
#	FROM ubuntu
#	COPY --from=0 /code-server /opt/code-server

FROM centos:7

USER root

ENV VSCODE_VERSION "1.33.1"
ENV CODE_SERVER_VERSION "1.1156-vsc1.33.1"

# Install VS Code's deps. These are the only two it seems we need.
RUN yum install -y libxkbfile-devel libsecret-devel \
                git gcc gcc-c++ make

# nodejs 10.x
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash
RUN yum install -y nodejs

RUN npm install -g yarn@1.13

WORKDIR /src

RUN git clone https://github.com/cdr/code-server /src \
        && git checkout ${CODE_SERVER_VERSION}

# build vscode
RUN scripts/vstar.sh

RUN mkdir -p /src/lib \
        && cp /tmp/vstar-${VSCODE_VERSION}.tar.gz /src/lib/ \
        && cd /src/lib \
        && tar xvzf vstar-${VSCODE_VERSION}.tar.gz

RUN yarn
RUN NODE_ENV=production yarn task build:server:binary

RUN mv /src/packages/server/cli-linux-x64 /code-server \
         && chmod +x /code-server
