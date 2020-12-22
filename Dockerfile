FROM alpine
LABEL maintainer="1151807762@qq.com"
RUN apk add --update nodejs nodejs-npm  
RUN npm install -g @vue/cli
COPY . /src
WORKDIR /src
RUN npm install
EXPOSE 8080
CMD npm run serve

