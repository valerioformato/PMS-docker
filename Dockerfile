FROM centos:8 as builder

RUN dnf update -y --exclude=glibc*
RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled powertools
RUN dnf install -y epel-release
RUN dnf install -y gcc gcc-c++ cpp \
    git curl libcurl-devel ninja-build python3 wget
RUN dnf install -y openssl-devel boost boost-devel

RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz
RUN tar -xvkf cmake-3.20.2-linux-x86_64.tar.gz --strip-components=1 -C /usr

# mongoc driver
RUN git clone https://github.com/mongodb/mongo-c-driver.git -b 1.17.5
RUN cd mongo-c-driver;\
    mkdir -p build; cd build;\
    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=/PMS/software/install/mongo-c-driver;\
    ninja; ninja install;

# mongocxx driver
RUN git clone https://github.com/mongodb/mongo-cxx-driver.git -b r3.6.3
RUN cd mongo-cxx-driver;\
    mkdir -p build; cd build;\
    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=/PMS/software/install/mongo-cxx-driver\
    -DCMAKE_PREFIX_PATH=/PMS/software/install/mongo-c-driver/;\
    ninja; ninja install;


FROM centos:8

RUN dnf update -y --exclude=glibc*
RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled powertools
RUN dnf install -y epel-release
RUN dnf install -y gcc gcc-c++ cpp \
    git curl libcurl-devel ninja-build python3 wget
RUN dnf install -y openssl-devel boost boost-devel

RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz
RUN tar -xvkf cmake-3.20.2-linux-x86_64.tar.gz --strip-components=1 -C /usr

COPY --from=builder /PMS/software/install/ /PMS/software/install/


