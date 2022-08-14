FROM node:16-alpine as builder

RUN npm install -g cnpm --registry=https://registry.npmmirror.com


RUN cnpm install -g eslint
RUN cnpm install -g @nestjs/cli

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN cnpm install

COPY . .
RUN cnpm ci --prod
RUN npx nest build


FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

USER node

EXPOSE 8080

ENTRYPOINT ["npm", "run", "start:prod"]
