FROM node:9

ADD ./package.json /app/package.json

WORKDIR /app
RUN npm install

ADD . /app
RUN npm run build

FROM node:9-alpine

COPY --from=0 /app/release /app
WORKDIR /app
RUN ls
RUN pwd
RUN npm install -g serve
CMD ["serve", "-p", "8000"]