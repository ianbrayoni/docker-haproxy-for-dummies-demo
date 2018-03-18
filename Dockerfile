FROM alpine:latest

# install packages with an updated index
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ONBUILD COPY . /usr/src/app

EXPOSE 5000
ENTRYPOINT ["python3"]
CMD ["app.py"]