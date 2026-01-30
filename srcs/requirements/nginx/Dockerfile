FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/inception

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/inception/inception.key \
	-out /etc/ssl/inception/inception.crt \
	-subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=42/OU=Codam/CN=localhost"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]