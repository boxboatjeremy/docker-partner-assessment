FROM nginx

COPY 80.conf /etc/nginx/conf.d/default.conf
COPY 100.conf /etc/nginx/conf.d/
COPY 200.conf /etc/nginx/conf.d/

COPY  80.html /var/www/80/index.html
COPY 100.html /var/www/100/index.html
COPY 200.html /var/www/200/index.html
