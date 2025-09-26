# Stage 1: Build Angular app
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the Angular project
COPY . .

# Fix permissions & build the Angular app
RUN chmod +x node_modules/.bin/ng && npx ng build --configuration production

# Build the Angular app (dist/ folder will be created)
RUN npx ng build --configuration production


# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built Angular app from builder
COPY --from=build /app/dist/helloworld /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

