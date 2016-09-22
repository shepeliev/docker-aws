FROM alpine
MAINTAINER Aleksandr Shepeliev <a.shepeliev@gmail.com>

ENV S3_TMP /tmp/s3cmd.zip
ENV S3_ZIP /tmp/s3cmd-master
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV PATH ${PATH}:${JAVA_HOME}/bin
ENV PAGER more

WORKDIR /tmp

RUN apk --no-cache add \
      bash \
      bash-completion \
      groff \
      less \
      curl \
      jq \
      py-pip \
      python &&\
    pip install --upgrade \
      awscli \
      pip \
      python-dateutil &&\
    ln -s /usr/bin/aws_bash_completer /etc/profile.d/aws_bash_completer.sh &&\
    curl -sSL --output ${S3_TMP} https://github.com/s3tools/s3cmd/archive/master.zip &&\
    unzip -q ${S3_TMP} -d /tmp &&\
    mv ${S3_ZIP}/S3 ${S3_ZIP}/s3cmd /usr/bin/ &&\
    rm -rf /tmp/* &&\
    mkdir ~/.aws &&\
    chmod 700 ~/.aws

# Expose volume for adding credentials
VOLUME ["~/.aws"]

CMD ["/bin/bash", "--login"]
