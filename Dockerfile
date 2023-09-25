#actual production container
FROM ubuntu:20.04

USER root

#ubuntu TZ fix - issue with APT
ENV TZ=America/Los_Angeles

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y

RUN apt-get install -y python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools nginx gettext-base wget unzip curl jq

RUN pip3 install wheel awscli
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

COPY ./netsuite-sdk-py-master /tmp/netsuite-sdk-py-master/
RUN pip3 install /tmp/netsuite-sdk-py-master/


RUN rm /etc/nginx/sites-enabled/*


COPY . /opt/service
COPY ./run.sh /opt/run.sh
RUN mkdir /opt/certs

RUN rm -rf /usr/share/nginx/html/*

# RUN chmod +x /opt/entrypoint.sh
RUN chmod +x /opt/run.sh

EXPOSE 80
EXPOSE 443
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/opt/run.sh"]
