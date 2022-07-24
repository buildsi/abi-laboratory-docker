FROM ubuntu

# docker build -t abi-laboratory .
# docker run -it abi-laboratory
# Bind to spack install to compare things!
# docker run -it -v $PWD/spack-vsoch:/spack abi-laboratory

RUN apt-get update && apt-get install -y git \
    build-essential \
    elfutils
RUN git clone https://github.com/lvc/abi-dumper && \
    cd abi-dumper && \
    make install prefix=/usr && \
    cd .. && \
    git clone https://github.com/lvc/abi-compliance-checker && \
    cd abi-compliance-checker && \
    make install prefix=/usr
COPY /entrypoint.sh /entrypoint.sh
WORKDIR /data
ENTRYPOINT ["/entrypoint.sh"]
