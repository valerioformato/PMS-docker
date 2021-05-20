FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND noninteractive
RUN apt -y update
RUN apt -y install apt
RUN apt -y update && apt -y install gcc g++ binutils \
    curl cmake git libcurl4 libcurl4-openssl-dev ninja-build python3 wget
RUN apt -y install libssl-dev libboost-regex-dev libboost-system-dev libboost-filesystem-dev

# mongoc driver
RUN git clone https://github.com/mongodb/mongo-c-driver.git -b 1.17.5
RUN cd mongo-c-driver;\
    mkdir build; cd build;\
    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=/PMS/software/install/mongo-c-driver;\
    ninja; ninja install;

# mongocxx driver
RUN git clone https://github.com/mongodb/mongo-cxx-driver.git -b r3.6.3
RUN cd mongo-cxx-driver;\
    mkdir build; cd build;\
    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=/PMS/software/install/mongo-cxx-driver\
    -DCMAKE_PREFIX_PATH=/PMS/software/install/mongo-c-driver/;\
    ninja; ninja install;

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt -y update
RUN apt -y install apt
RUN apt -y update && apt -y install gcc g++ binutils \
    curl cmake git libcurl4 libcurl4-openssl-dev ninja-build python3 wget
RUN apt -y install libssl-dev libboost-regex-dev libboost-thread-dev libboost-system-dev libboost-filesystem-dev

COPY --from=builder /PMS/software/install/ /PMS/software/install/


