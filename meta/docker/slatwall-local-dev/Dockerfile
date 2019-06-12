# Based on the Lucee4-Nginx Container
FROM lucee/lucee4-nginx:latest
MAINTAINER Greg Moser, greg.moser@ten24web.com

RUN apt-get update && apt-get install -y uuid-runtime

COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml
COPY lucee-web.xml.cfm /opt/lucee/web/lucee-web.xml.cfm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
