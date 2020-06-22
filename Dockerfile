FROM caliahub/jre:1.8.0_101

MAINTAINER Calia "cnboycalia@gmail.com"

ENV NACOS_VERSION=1.3.0 \
	MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    FUNCTION_MODE="all" \
    JVM_XMS="2g" \
    JVM_XMX="2g" \
    JVM_XMN="1g" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false"

RUN addgroup -S nacos --gid=1000 \
    && adduser -S -g nacos --uid=1000 nacos \
	&& wget https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.tar.gz -P /home \
    && tar -xzf /home/nacos-server-${NACOS_VERSION}.tar.gz -C /home \
    && rm -rf /home/nacos-server-${NACOS_VERSION}.tar.gz /home/nacos/bin /home/nacos/conf/*.properties /home/nacos/conf/*.example /home/nacos/conf/*.sql /home/nacos/LICENSE /home/nacos/NOTICE \
    && mkdir -p /home/nacos/logs \
    && touch /home/nacos/logs/start.out \
    && ln -sf /dev/stdout /home/nacos/logs/start.out \
    && ln -sf /dev/stderr /home/nacos/logs/start.out \
	&& chown -R nacos:nacos /home/nacos/

COPY docker-entrypoint.sh /usr/local/bin/
COPY application.properties /home/nacos/conf/

WORKDIR /home/nacos

USER nacos

EXPOSE 8848

ENTRYPOINT ["docker-entrypoint.sh"]

