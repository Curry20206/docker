
# Webserver Dockerfile

#FROM centos:7
# Use a specific version of the base image for better security and predictability
FROM centos:7.9.2009


RUN yum install epel-release -y && \
	yum update -y && \
	yum install -y \
	nginx \
	php \
	php-mysqlnd \
	php-fpm 

#RUN yum install openssh-server -y
#RUN yum install openssh-clients -y
#RUN sshd-keygen
#RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

	
#RUN useradd -m user
#RUN useradd -m admin && echo "admin:letmein" | chpasswd
# Create a non-root user for running the services
RUN useradd -m webuser

COPY webfiles/ /usr/share/nginx/html

COPY configfiles/nginx.conf     /etc/nginx/nginx.conf
COPY configfiles/php.ini        /etc/php.ini
COPY configfiles/www.conf       /etc/php-fpm.d/www.conf
COPY configfiles/php-fpm.conf   /etc/nginx/conf.d/php-fpm.conf
COPY configfiles/docker-entrypoint.sh /

#RUN rm -f /usr/share/nginx/html/index.html /usr/share/nginx/html/nginx-logo.png /usr/share/nginx/html/poweredby.png
#RUN chmod +x /docker-entrypoint.sh && \
 #   chown apache:apache /usr/share/nginx/html/*.php

# Clean up and set permissions
RUN rm -f /usr/share/nginx/html/index.html /usr/share/nginx/html/nginx-logo.png /usr/share/nginx/html/poweredby.png
RUN chmod +x /docker-entrypoint.sh && \
    chown apache:apache /usr/share/nginx/html/*.php

EXPOSE 80
#EXPOSE 8004
#EXPOSE 2375
#EXPOSE 22

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1

# Run as non-root user
USER webuser


ENTRYPOINT ["/docker-entrypoint.sh"]
