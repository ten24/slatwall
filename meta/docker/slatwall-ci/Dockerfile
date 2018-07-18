# Slatwall CI Build
FROM 314297265345.dkr.ecr.us-east-1.amazonaws.com/lucee5:latest-dev
MAINTAINER Sumit Verma, sumit.verma@ten24web.com

RUN apt-get clean
RUN apt-get update
RUN apt-get install -y uuid-runtime
RUN apt-get install -y ant

COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml
COPY lucee-web.xml.cfm /opt/lucee/web/lucee-web.xml.cfm

# Expose Ports
EXPOSE 8888

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]
