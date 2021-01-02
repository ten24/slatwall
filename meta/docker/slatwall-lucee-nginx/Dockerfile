# Based on the Lucee Container
FROM lucee/lucee:5.3-nginx
LABEL maintainer="Slatwall Inc."

RUN apt-get update && apt-get install -y uuid-runtime

# Install Slatwall
RUN wget -nv https://s3.amazonaws.com/slatwall-releases/slatwall-latest.zip -O /root/slatwall.zip && \
	unzip /root/slatwall.zip -d /root/slatwall && \
	cp -a /root/slatwall/. /var/www && \
	rm -rf /root/slatwall.zip && \
	rm -rf /root/slatwall

COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml
COPY lucee-web.xml.cfm /opt/lucee/web/lucee-web.xml.cfm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]
