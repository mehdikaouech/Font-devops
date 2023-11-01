# Use an official Node.js runtime as a parent image
FROM node:14.17.0-alpine3.13 AS build

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Angular app for production
RUN npm run build --prod

# Use a smaller image for production
FROM nginx:1.21.0-alpine

# Copy the build output to the nginx directory
COPY --from=build /app/dist/crud-tuto-front /usr/share/nginx/html

# Expose port 80 for the container
EXPOSE 80

# Start nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
