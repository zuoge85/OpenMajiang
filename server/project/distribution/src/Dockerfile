FROM java:openjdk-8-jdk

WORKDIR /usr/src/myapp

COPY classes classes
COPY lib lib
COPY startup startup

EXPOSE 8010
EXPOSE 8080
EXPOSE 9090
CMD ["./startup.sh"]


