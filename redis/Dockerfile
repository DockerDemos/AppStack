FROM ubuntu:14.04
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN apt-get update && apt-get install -y redis-server
ADD run.sh /run.sh

EXPOSE 6379

ENTRYPOINT ["/run.sh"]
CMD ["redis-server"]
