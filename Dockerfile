FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY app/package*.json ./
RUN npm install

# Copy app source
COPY app/ .

# Expose app port
EXPOSE 8080

# Start app
CMD ["node", "index.js"]
