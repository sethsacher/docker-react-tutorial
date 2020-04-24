# We don't specify anywhere that we're using this Dockerfile
# with Travis CI / AWS EB; it does that automatically 

# Removed the named builder and use default 0 instead
# To resolve AWS issue ""docker pull" requires exactly 1 argument"

FROM node:alpine
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

# Does nothing locally, but tells 
# Elastic Beanstalk to expose this port (default HTTP port)
EXPOSE 80

# Copying directory from the builder step and moving it to this one
# The usr... directory is what nginx uses by default to serve content
COPY --from=0 app/build /usr/share/nginx/html

# Default command of the base image is to start nginx
# so we don't need a separate command at the bottom