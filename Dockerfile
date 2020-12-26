FROM amazonlinux:latest
MAINTAINER Sarfraz
RUN yum -y install make 
RUN yum -y install git 
RUN yum -y install zip 
RUN yum -y install gcc-c++ libcurl-devel
RUN yum -y install cmake3

#Install CPP AWS Library 
RUN export CC=gcc && \
    export CXX=g++ && \
    cd ~  && \
    git clone https://github.com/awslabs/aws-lambda-cpp.git && \
    cd aws-lambda-cpp && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=~/out && \
    make &&\
    make install


WORKDIR /code
COPY hello-cpp-world .
RUN export CC=gcc && \
    export CXX=g++ && \
    cat CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=~/out
RUN cd build && make && \
    make aws-lambda-package-hello && \
    cp hello.zip /artifacts/hello.zip



