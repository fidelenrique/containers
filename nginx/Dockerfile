FROM nginx:1.23-alpine

RUN apk --no-cache add vim bash curl iputils

ADD nginx.conf /etc/nginx/

RUN adduser -D -g '' -G www-data www-data

CMD ["nginx"]

EXPOSE 80