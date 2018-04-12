FROM centos
RUN yum install -y gcc-gfortran libgfortran gcc-c++ make cmake perl readline-devel 
RUN yum install -y xorg-x11-server-devel libX11-devel libXt-devel

# Install 2.15.2
# Other version: https://cran.r-project.org/src/base/R-2/
RUN cd; curl -O https://cran.r-project.org/src/base/R-2/R-2.15.2.tar.gz
RUN cd; tar -zxvf R-2.15.2.tar.gz
RUN cd ~/R-2.15.2; ./configure --prefix=/opt/R/2.15.2 --enable-R-shlib
RUN cd ~/R-2.15.2; make -j 4 # -j 4は並列してmakeしたいだけなのでなくても
RUN cd ~/R-2.15.2; make install

# [2.11.0 or higher] Use this script.
# [2.11.0 or lower] check document: https://support.rstudio.com/hc/en-us/articles/200552306-Getting-Started
RUN cd; curl -O https://download2.rstudio.org/rstudio-server-rhel-0.99.903-x86_64.rpm
RUN cd; yum install -y rstudio-server-rhel-0.99.903-x86_64.rpm 
RUN rpm -ihv http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y groupinstall "Japanese Support"
RUN yum install -y initscripts 
RUN ln -sF /opt/R /usr/local/lib64/R
RUN ln -sF /usr/local/lib64/R/2.15.2/bin/R /usr/local/bin
RUN adduser rstudio
RUN echo "rstudio:{password}" | chpasswd

WORKDIR /r
ADD . /r/
