# Stage 1 - Build React client
FROM node:18-alpine AS client-builder
WORKDIR /app/client
COPY client/package.json ./
RUN npm install --omit=dev
COPY client/ ./
RUN npm run build

# Stage 2 - Install server
FROM node:18-alpine
WORKDIR /app

COPY package.json ./
COPY server/package.json server/
RUN npm run install-server --omit=dev

# Copy built React app into server/public
COPY --from=client-builder /app/client/build ./server/public

# Copy server code
COPY server/ server/

USER node
EXPOSE 8000
CMD ["npm", "start", "--prefix", "server"]
