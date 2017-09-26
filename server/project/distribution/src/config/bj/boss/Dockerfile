FROM java:openjdk-8-jdk

WORKDIR /usr/src/myapp

COPY classes classes
COPY lib lib
COPY startup.sh startup.sh

EXPOSE 11000
EXPOSE 11001
EXPOSE 11002
CMD ["./startup.sh"]


