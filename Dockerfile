FROM centos:7
MAINTAINER RightStack <support@rightstack.net>

# set locale ko_KR
RUN localedef -f UTF-8 -i ko_KR ko_KR.UTF-8

ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8
ENV ASSETS_DIR /opt/subversion/assets

ADD assets/wandisco-svn.repo /etc/yum.repos.d

RUN yum -y update && yum clean all
RUN yum -y install logrotate && \
    yum -y install which && \
    yum -y install unzip && \
    yum -y install gcc* make && \
    yum clean all
RUN yum -y install httpd httpd-devel && \
    yum -y install subversion mod_dav_svn && \
    yum clean all

# Install mod_jk
ADD assets/tomcat-connectors-1.2.42-src.tar.gz .
RUN cd tomcat-connectors-1.2.42-src/native/ \
    && ./configure --with-apxs=/usr/bin/apxs \
    && make \
    && cp apache-2.0/mod_jk.so /usr/lib64/httpd/modules/ \
    && ./libtool --finish /usr/lib64/httpd/modules/ \
    && cd / \
    && rm -rf tomcat-connectors-1.2.42-src/ \
    && rm -f tomcat-connectors-1.2.42-src.tar.gz

EXPOSE 80

RUN mkdir -p $ASSETS_DIR

ADD assets/bootstrap.tar.gz $ASSETS_DIR
ADD assets/*.conf $ASSETS_DIR/
ADD assets/static $ASSETS_DIR/static
ADD assets/logrotate $ASSETS_DIR/logrotate
ADD assets/workers.properties $ASSETS_DIR/logrotate
ADD entrypoint.sh $ASSETS_DIR
RUN chmod +x $ASSETS_DIR/entrypoint.sh
