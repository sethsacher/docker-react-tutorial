FROM node:alpine as builder
WORKDIR '/app'

COPY package.json .
RUN npm install

# Don't have to worry about volume mounting
# We want to build everything and have it all in the container
COPY . . 

# Running a command in the container,
# not starting up the default process yet (CMD command)
RUN npm run build


FROM nginx
# Copying directory from the builder step and moving it to this one
# The usr... directory is what nginx uses by default to serve content
COPY --from=builder app/build /usr/share/nginx/html

# Default command of the base image is to start nginx
# so we don't need a separate command at the bottom