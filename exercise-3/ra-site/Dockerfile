### STAGE 1: Build ###

## We label our stage as ‘builder’
FROM node as builder

## Copy to container root folder
COPY package.json ./

## Put node modules in build container to keep final smaller
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app

## Set working directory
WORKDIR /ng-app

## Copy source into build container
COPY . .

## Build the angular app in production mode and store the artifacts in dist folder
RUN $(npm bin)/ng build --prod

### STAGE 2: Setup ###

## Use nginx as web server
FROM nginx

## Copy our default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /usr/share/nginx/html

## Run nginx server
CMD ["nginx", "-g", "daemon off;"]
