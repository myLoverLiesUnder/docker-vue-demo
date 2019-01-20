FROM node:9.11.1-alpine as build-stage
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN yarn install
COPY . /app
RUN yarn build

# production stage
FROM nginx:1.13.12-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY ./app.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
