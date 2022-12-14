FROM alpine:3.16

USER root

# Install packages
RUN apk --update --no-cache add nodejs npm python3 py3-pip jq curl bash git docker && \
	ln -sf /usr/bin/python3 /usr/bin/python

# Install golang
COPY --from=golang:1.19-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"

# Update npm
RUN npm config set unsafe-perm true
RUN npm update -g

# Install cli
RUN pip install --upgrade pip && \
    pip install --upgrade awscli

# Install cdk
RUN npm install -g aws-cdk

COPY cli /cli
COPY test /test
ENV CEVIXE_WORKSPACE="/test"

COPY entrypoint.sh /entrypoint.sh

RUN mkdir ~/.aws
RUN touch ~/.aws/credentials

ENTRYPOINT ["/entrypoint.sh"]