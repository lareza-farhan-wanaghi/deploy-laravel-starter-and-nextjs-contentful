FROM node:16
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx cross-env CONTENTFUL_SPACE_ID=4znn5zxy9p3i CONTENTFUL_MANAGEMENT_TOKEN=CFPAT-EPuVH_APjyyw89RevpcUI-V0H37qknHJl61Xk9aWnKc npm run setup
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "start"]
