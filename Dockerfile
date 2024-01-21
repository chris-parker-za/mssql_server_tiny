FROM debian:bookworm-slim AS build0
WORKDIR /root

RUN apt-get update && apt-get install -y binutils gcc

ADD wrapper.c /root/
RUN gcc -shared  -ldl -fPIC -o wrapper.so wrapper.c


FROM mcr.microsoft.com/mssql/server:2022-latest
USER root
COPY --from=build0 /root/wrapper.so /root/
COPY start.sh /root/start.sh
RUN  chmod +x /root/start.sh

CMD /root/start.sh
