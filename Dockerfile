from ubuntu:14.04
maintainer mukki
RUN apt-get update
RUN apt-get -y install wget git
RUN apt-get install -y  apache2 libapache2-mod-php5 php5 php5-cli php5-common php5-curl php5-gd php5-json php5-ldap php5-mcrypt php5-mysqlnd php5-pgsql unzip
RUN apt-get -y  install mysql-client-5.6
RUN php5enmod mcrypt && sudo service apache2 restart
#WORKDIR /opt
RUN git clone https://github.com/mukendra/idoit.git /opt/
RUN cp /opt/i-doit.ini /etc/php5/mods-available/
RUN php5enmod i-doit
RUN service apache2 restart
RUN ln -s /etc/php5/mods-available/i-doit.ini/etc/php5/conf.d/
RUN apt-get -y install php5-memcache memcached
RUN php5enmod memcache
RUN apt-get -y  install php5-APCU
RUN apt-get install -y  php5-xcache
RUN php5enmod xcache
RUN cp /opt/xcache.ini /etc/php5/mods-available/xcache.ini 
RUN cp /opt/000-default.conf /etc/apache2/sites-available/000-default.conf 
RUN cp /opt/i-doit.conf /etc/apache2/conf-available/i-doit.conf
RUN a2enconf i-doit
RUN sudo a2enmod rewrite
ADD i-doit.cnf /etc/mysql/conf.d/i-doit.cnf
RUN mkdir /var/www/html/i-doit
ADD idoit-open-1.4.4.zip /var/www/html/i-doit/ 
WORKDIR /var/www/html/i-doit/
RUN unzip idoit-open-1.4.4.zip
RUN rm idoit-open-1.4.4.zip
WORKDIR cd /var/www/html/i-doit/
RUN chown www-data:www-data -R .
EXPOSE 80
ENTRYPOINT service apache2 restart && sleep 3600 
