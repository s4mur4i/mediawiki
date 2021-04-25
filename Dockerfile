FROM mediawiki:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev \
        libicu-dev \
        libldap2-dev \
        libldap-2.4-2 \
        netcat \
        git \
        imagemagick \
        unzip \
        vim.tiny \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && docker-php-source extract

RUN git clone --depth 1 https://github.com/HydraWiki/mediawiki-embedvideo.git /var/www/html/extensions/EmbedVideo
RUN git clone --depth 1 https://github.com/wikimedia/mediawiki-extensions-PluggableAuth.git /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 https://github.com/s4mur4i/mediawiki-extensions-OpenIDConnect.git /var/www/html/extensions/OpenIDConnect
RUN git clone --depth 1 https://github.com/wikimedia/mediawiki-extensions-Lockdown.git /var/www/html/extensions/Lockdown
RUN git clone --depth 1 https://github.com/bharley/mw-markdown.git /var/www/html/extensions/Markdown
RUN curl https://raw.githubusercontent.com/erusev/parsedown/master/Parsedown.php --output /var/www/html/extensions/Markdown/Parsedown.php
RUN curl https://raw.githubusercontent.com/erusev/parsedown-extra/master/ParsedownExtra.php --output /var/www/html/extensions/Markdown/ParsedownExtra.php

COPY composer.local.json /var/www/html/composer.local.json
RUN curl -L https://getcomposer.org/installer | php \
    && php composer.phar install --no-dev