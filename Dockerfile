# Use the official Node.js 20 image as the base image
FROM node:20

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY . .

# Install dependencies
RUN npm install -g "turbo@^1.9.3"

RUN turbo prune --scope=@documenso/web --docker

ARG NEXT_PRIVATE_ENCRYPTION_KEY="CAFEBABE"
ENV NEXT_PRIVATE_ENCRYPTION_KEY="$NEXT_PRIVATE_ENCRYPTION_KEY"

ARG NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY="DEADBEEF"
ENV NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY="$NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY"

RUN npm install

RUN npm run prisma:generate

RUN npm run build:web

# Expose the port the app runs on
EXPOSE 3000

# Command to server the application
CMD ["npm", "run", "start"]
