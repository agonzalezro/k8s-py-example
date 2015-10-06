FROM gliderlabs/alpine:3.2

RUN apk-install python

COPY src/requirements.txt .
RUN apk --update add --virtual build-dependencies py-pip \
  && pip install -r requirements.txt \
  && apk del build-dependencies

COPY src /code
WORKDIR /code

EXPOSE 5000
ENTRYPOINT ["python", "app.py"]
