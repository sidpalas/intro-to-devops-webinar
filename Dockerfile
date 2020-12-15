FROM caddy:2.1.1

COPY Caddyfile /etc/caddy/Caddyfile

COPY ./presentation /srv

EXPOSE 80

EXPOSE 443