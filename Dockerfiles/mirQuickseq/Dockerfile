FROM ubuntu 

MAINTAINER Nicolas E.W <espinosa_nicolas@hotmail.com>
RUN apt-get update
#(0)
RUN apt-get install -y cutadapt 
RUN apt-get install -y perl
RUN apt-get install -y build-essential 
#RUN apt-get install -y cpan
#(1)

RUN apt-get update

RUN perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'
#(3)
#RUN cpan App::cpanminus #

RUN cpan install Switch JSON Config::Simple
RUN cpan install Switch JSON Parallel::ForkManager


#RUN perl -e "use MIME::Base64"
#RUN perl -e "use Parallel::ForkManager"
#RUN perl -e "use Config::Simple"
#RUN perl -e "use Compress::Zlib"


RUN apt-get update


RUN TZ=America/Santiago 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#apt-get install -y r-base

#apt-get --dry-run -o Debug::pkgDepCache::AutoInstall=yes install r-base-core
#RUN apt-get --no-install-recommends install -y r-base-core

RUN apt-get install -y mkdir
RUN apt-get install -y software-properties-common


RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt update

RUN apt-get install -y r-base r-base-core r-recommended r-base-dev




RUN R -e "install.packages(c('latticeExtra', 'reshape2', 'scales' ,'ggplot2'), repos = 'http://cran.us.r-project.org')"
RUN apt-get install time
RUN apt-get update

