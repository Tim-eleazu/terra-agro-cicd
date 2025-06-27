# Step 1: Use an official Node.js runtime as a parent image
FROM node:16-alpine
 
# Step 2: Set the working directory inside the container
WORKDIR /app
 
# Step 3: Copy package.json and yarn.lock files (if yarn.lock exists)
COPY package.json ./
COPY yarn.lock* ./
 
# Step 4: Install app dependencies
# Using yarn to install the dependencies.
RUN yarn install
 
# Step 5: Copy the project files into the container
COPY . .
 
# Step 6: Expose the port that Vue.js development server uses
EXPOSE 8080
 
# Step 7: Start the Vue.js development server
CMD ["yarn", "serve"]
