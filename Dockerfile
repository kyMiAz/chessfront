FROM alpine
LABEL maintainer="1151807762@qq.com"
RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
&& apk add --update nodejs nodejs-npm  
RUN npm config set registry https://registry.npm.taobao.org \
&& npm install -g @vue/cli
COPY . /src
WORKDIR /src
RUN npm install
EXPOSE 8080
CMD npm run serve

