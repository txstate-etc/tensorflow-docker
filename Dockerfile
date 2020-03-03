FROM node:12-buster-slim as build

RUN apt-get update -y && apt-get install -y pkg-config zip g++ zlib1g-dev unzip python3.7-dev git python3-pip
RUN pip3 install --upgrade setuptools && pip3 install future

WORKDIR /root
ADD https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-installer-linux-x86_64.sh ./
RUN chmod +x ./bazel-0.26.1-installer-linux-x86_64.sh && ./bazel-0.26.1-installer-linux-x86_64.sh

RUN git clone https://github.com/tensorflow/tensorflow /tensorflow
WORKDIR /tensorflow
RUN git checkout v1.15.2
COPY .tf_configure.bazelrc .tf_configure.bazelrc

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN bazel build --config=opt --config=monolithic --ram_utilization_factor=20 //tensorflow/tools/lib_package:libtensorflow

FROM scratch
WORKDIR /root
COPY --from=build /tensorflow/bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz ./
