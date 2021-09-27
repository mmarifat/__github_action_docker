# build step
FROM node:14.17-alpine as build

MAINTAINER mmarifat "mma.rifat66@gmail.com"

WORKDIR /usr/shako

# skip those 2 lines to avoid downloading node_modules again and again
COPY package*.json ./
RUN yarn install

COPY ./ ./

RUN yarn build

# production mode
FROM nginx:1.20.1 as production

MAINTAINER mmarifat "mmarifat66@gmail.com"

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /usr/shako/dist/spa /usr/share/nginx/html

# have to set in default.conf, or won't work
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
