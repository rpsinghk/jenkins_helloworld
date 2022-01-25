# Base Alpine Linux based image with OpenJDK JRE only
FROM adoptopenjdk/openjdk8:latest

# copy application JAR (with libraries inside)
COPY build/libs/jenkins_helloworld1-1.0.0.jar.jar /jenkins_helloworld.jar

# Copy image specific configs and scripts
COPY test/init.sh /usr/bin/init.sh

#chmod for proper executables and security of files
RUN chmod 766 /usr/bin/init.sh

CMD ["/usr/bin/init.sh"]