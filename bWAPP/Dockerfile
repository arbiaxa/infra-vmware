FROM php:5.6-apache
COPY  ./bWAPP /var/www/bWAPP
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until \
    && docker-php-ext-install mysqli  
RUN apt-get update \
    && cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/bWAPP.conf \
    && sed -i 's|80|84|' /etc/apache2/sites-available/bWAPP.conf  \
    && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/bWAPP|' /etc/apache2/sites-available/bWAPP.conf \
    && a2ensite bWAPP.conf 
RUN echo "Listen 84" >> /etc/apache2/ports.conf


