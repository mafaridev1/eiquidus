FROM node:20-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Install system packages
RUN apk add --no-cache curl bash nano git python3 make g++ libstdc++ \
    && apk add --no-cache cronie

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy application source
COPY . .

# Make script files executable
RUN chmod +x /usr/src/app/scripts/*

# Setup cron
COPY crontab /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root
RUN touch /var/log/cron.log

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

ENV PORT 3001
EXPOSE ${PORT}

CMD [ "node", "--stack-size=10000", "./bin/cluster" ]
