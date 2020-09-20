FROM ubuntu:20.04

# install WGET and curl
RUN apt-get update && apt-get -y install wget && apt-get install -y curl

# install ActiveTick API
RUN wget https://www.activetick.com/activetick/contents/binaries/atfeedapi/atfeed-httpserver-ubuntu.x86_64.tar.gz; \
	tar -zxvf atfeed-httpserver-ubuntu.x86_64.tar.gz; \
	rm -rf atfeed-httpserver-ubuntu.x86_64.tar.gz; \
	mv atfeed-httpserver/bin/* /usr/local/bin
ENV LD_LIBRARY_PATH=/usr/local/bin/

# get args from build
ARG ACTIVETICK_USER
ARG ACTIVETICK_API_KEY
ARG ACTIVETICK_PASSWORD
ARG ACTIVETICK_PORT

# create directory for scripts
ARG SCRIPTS_DIR=/scripts
RUN mkdir ${SCRIPTS_DIR}

# copy entry point script & health check
COPY start.sh ${SCRIPTS_DIR}/start.sh
COPY healthcheck.sh ${SCRIPTS_DIR}/healthcheck.sh

# create user
ARG APP_USER=active_tick
RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

# replace credentials in entry point script
RUN sed -i 's#ACTIVETICK_USER#'"$ACTIVETICK_USER"'#g' ${SCRIPTS_DIR}/start.sh
RUN sed -i 's#ACTIVETICK_API_KEY#'"$ACTIVETICK_API_KEY"'#g' ${SCRIPTS_DIR}/start.sh
RUN sed -i 's#ACTIVETICK_PASSWORD#'"$ACTIVETICK_PASSWORD"'#g' ${SCRIPTS_DIR}/start.sh
RUN sed -i 's#ACTIVETICK_PORT#'"$ACTIVETICK_PORT"'#g' ${SCRIPTS_DIR}/start.sh

# make files executable
RUN echo "${SCRIPTS_DIR}/start.sh"
RUN ls ${SCRIPTS_DIR}
RUN chmod +x ${SCRIPTS_DIR}/start.sh
RUN chmod +x ${SCRIPTS_DIR}/healthcheck.sh

# change ownership and swithch to new user for security reasons
RUN chown -R ${APP_USER}:${APP_USER} ${SCRIPTS_DIR}
USER ${APP_USER}

# expose port and start
EXPOSE ${ACTIVETICK_PORT}
CMD [ "/scripts/start.sh" ]