FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=development
COPY package*.json ./
COPY tsconfig*.json ./
COPY src ./src
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
RUN mkdir -p uploads/pqrs
EXPOSE 3000
CMD ["sh", "-c", "npm run migration:run && node dist/main.js"]
