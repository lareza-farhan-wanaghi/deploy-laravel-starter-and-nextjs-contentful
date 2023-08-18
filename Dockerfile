FROM node:16
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx cross-env CONTENTFUL_SPACE_ID=<CONTENTFUL SPACE ID> CONTENTFUL_MANAGEMENT_TOKEN=<CONTENTFUL MANAGEMENT TOKEN> npm run setup
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "start"]
