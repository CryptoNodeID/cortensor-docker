FROM ubuntu:24.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    apt-transport-https \
    ca-certificates 

# Clone the Cortensor installer repository
RUN git clone https://github.com/cortensor/installer.git /opt/cortensor-installer

WORKDIR /opt/cortensor-installer

RUN ./install-ipfs-linux.sh && ./kubo/install.sh

RUN mkdir /home/deploy && cp -r dist /home/deploy/.cortensor

WORKDIR /home/deploy/.cortensor

RUN chmod +x cortensord \
  && mkdir logs \
  && mkdir llm-files \
  && cp .env-example .env \
  && cp cortensor.service /etc/systemd/system \
  && touch logs/cortensord.log \
  && touch logs/cortensord-llm.log

CMD ["tail", "-f", "/dev/null"]
