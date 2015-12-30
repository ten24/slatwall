# Slatwall Version 4.1.011
FROM lucee/lucee-tomcat:latest
MAINTAINER Greg Moser, greg.moser@ten24web.com

RUN apt-get update && apt-get install -y uuid-runtime

COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml
COPY lucee-web.xml.cfm /opt/lucee/web/lucee-web.xml.cfm

# Expose Ports
EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]