# Database Dockerfile

#FROM mariadb:10
# Use a specific version of the base image for better security and predictability
FROM mariadb:10.5.8

#COPY mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf
COPY mysqld.cnf  /mysql/mysql.conf.d/mysqld.cnf


# Create a non-root user for running the service
RUN groupadd -r mariadb && useradd -r -g mariadb mariadb

# Change ownership of the mariadb directories
RUN chown -R mariadb:mariadb /var/lib/mysql /var/run/mysqld

# Run as non-root user
USER mariadb

EXPOSE 3306

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD mysqladmin ping -h localhost || exit 1
