 # Deploying Laravel-Starter & Contentful-NextJS Apps to a VM


 ## Objectives

1. Create a virtual machine on a laptop with the following specifications:
   - 2 GB RAM
   - 1 vCPU
   - 20GB HDD

2. Establish a web server environment meeting these requirements:
   - Nginx
   - PHP 8.1
   - MariaDB 10.6
   - Composer 2

3. Deploy the application from the repository https://github.com/nasirkhan/laravel-starter.

4. Configure a domain, "laravel-starter.dot," to facilitate access to the deployed application.

5. Ensure the application supports the following functionalities:
   - User registration
   - User login
   - Display of posts, categories, tags, and comments
   - Ability to add comments to posts
   - User account verification through email (using mailtrap)

6. Install Docker version 20.10.15.

7. Utilize Docker to deploy the application from https://gitlab.dot.co.id/kudaliar032/nextjs-intern-test.

8. Establish a domain, "nextjs-docker.dot," enabling access to the deployed Dockerized application.

9. Verify that the application showcases a variety of sample posts.

## Resolution Steps
- Step 1 - Setting up the Server
- Step 2 - Setting up the Server Environment
- Step 3 - Deploying the PHP Application
- Step 4 - Testing the PHP Application
- Step 5 - Deploying the Next.js App
- Step 6 - Testing the Next.js App

### Step 1 - Setting up the Server

**1.1 Download Required Software**
1. Download VMWare Fusion 13 to create a virtual machine: [VMWare Fusion 13](https://www.vmware.com/products/fusion/fusion-evaluation.html)
2. Download Ubuntu 20.04.5 LTS (Focal Fossa) Server ISO image: [Ubuntu 20.04.5 LTS](https://cdimage.ubuntu.com/ubuntu/releases/20.04.5/release/ubuntu-20.04.5-live-server-arm64.iso)

**1.2 Launch the Virtual Machine**

1. Open VMWare Fusion and create a new virtual machine using the downloaded ISO file.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.48.15.webp" width="75%"/>
   
2. In the configuration tab, choose "Custom" configuration to access the settings menu.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.49.39.webp" width="75%"/>

3. Under Network Adapter, select "Autodetect" under "Bridged Networking" to configure the networking.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.35.17.webp" width="75%"/>

4. Return to the previous menu, select Hard Disk, and set the disk size to 20,00 GB.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.35.06.webp" width="75%"/>

5. Back to the previous menu, select Processor & Memory. Choose "1 processor core" from the Processor dropdown and set the memory to 2048.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.34.57.webp" width="75%"/>

6. Start the VM and proceed with the Ubuntu installation.

   <img src="_resources/Screenshot%202023-08-11%20at%2014.50.59.webp" width="75%"/>

### Step 2 - Setting up the Server Environment

**2.1 Install Nginx**
1. Inside the server VM, execute the following commands to install Nginx:

```bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

**2.2 Install PHP 8.1**
1. In the server VM, run the commands below to install PHP 8.1 and its extensions:

```bash
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install --no-install-recommends php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath
sudo systemctl start php8.1-fpm
sudo systemctl enable php8.1-fpm
```

**2.3 Install Composer 2**
1. Inside the server VM, run the following commands to install Composer 2:

```bash
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
sudo php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('/tmp/composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

**2.4 Install MariaDB 10.6**
1. Inside the server VM, install MariaDB 10.6 using the following commands:

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install software-properties-common -y
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.6
sudo apt update
sudo apt install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

2. Optionally, you can enhance security by running the command below:
```bash
sudo mariadb-secure-installation
```

### Step 3 - Deploying the PHP Application

**3.1 Configure Mailtrap**
1. Register on Mailtrap and access the Dashboard.

   <img src="_resources/Screenshot%202023-08-11%20at%2015.22.11.webp" width="75%"/>

2. Create an Inbox and obtain the credentials for use in the PHP app later.

   <img src="_resources/Screenshot%202023-08-11%20at%2015.24.38.webp" width="75%"/>

**3.2 Configure the Database**
1. Connect to the database:
   ```
   sudo mysql -u root
   ```

2. Create a database and a user to manage it:
   ```
   CREATE DATABASE laravel_starter;
   CREATE USER 'your_username'@'localhost' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON laravel_starter.* TO 'your_username'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```

**3.3 Setup the PHP Application**
1. Clone the PHP app repository and install Composer dependencies:
   ```
   cd /var/www/html
   sudo git clone https://github.com/nasirkhan/laravel-starter.git
   cd laravel-starter
   sudo composer install
   sudo cp .env.example .env
   ```

2. Edit the `.env` file with the following environment settings:
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=laravel_starter
   DB_USERNAME=your_username  
   DB_PASSWORD=your_password
   MAIL_MAILER=smtp
   MAIL_HOST=sandbox.smtp.mailtrap.io
   MAIL_PORT=2525
   MAIL_USERNAME=<Your Username>
   MAIL_PASSWORD=<Your Password>
   ```

3. Set proper permissions:
   ```
   sudo chown -R www-data:www-data /var/www/html/laravel-starter/storage
   sudo chmod -R 775 /var/www/html/laravel-starter/storage
   sudo chown -R www-data:www-data /var/www/html/laravel-starter/bootstrap/cache
   sudo chmod -R 775 /var/www/html/laravel-starter/bootstrap/cache
   ```

4. Continue Installation:
   ``` bash
   sudo php artisan migrate --seed
   sudo php artisan storage:link
   sudo php artisan starter:insert-demo-data --fresh
   sudo php artisan key:generate
   sudo php artisan cache:clear
   ```

**3.4 Configure Nginx**

1. Add the following entry to the `/etc/hosts` file on the host machine to set up the domain name:
   ```
   192.168.1.8 laravel-starter.dot
   ```

2. Create a configuration file for Nginx:
   ```
   sudo nano /etc/nginx/sites-available/laravel-starter
   ```
   Copy and paste the following content:
   ```
   server {
       listen 80;
       server_name laravel-starter.dot;

       root /var/www/html/laravel-starter/public;
       index index.php;

       location / {
           try_files $uri $uri/ /index.php?$query_string;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
       }
   }
   ```

3. Enable the Nginx configuration:
   ```
   sudo ln -s /etc/nginx/sites-available/laravel-starter /etc/nginx/sites-enabled/
   ```

4. Restart Nginx:
   ```
   sudo systemctl restart nginx
   ```

### Step 4 - Testing the PHP Application

**4.1 Verify Page Functionality**
1. Visit the homepage:

   <img src="_resources/Screenshot%202023-08-11%20at%2015.54.40.webp" width="75%"/>

2. Explore the post page:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.09.02.webp" width="75%"/>

3. Navigate to the tags page:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.09.29.webp" width="75%"/>

4. Check out the categories page:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.09.18.webp" width="75%"/>

5. Explore the comments page:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.09.44.webp" width="75%"/>

**4.2 Create a User and Edit Profile**

1. Register a user from the registration page:

   <img src="_resources/Screenshot%202023-08-11%20at%2015.55.53.webp" width="75%"/>

2. From the homepage, access the settings and edit the profile:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.02.30.webp" width="75%"/>

   Edit profile details, e.g., birthday:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.02.54.webp" width="75%"/>

**4.3 Email Verification**

1. Log in with the default admin account:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.07.54.webp" width="75%"/>

2. Access the Admin Dashboard:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.15.10.webp" width="75%"/>

3. Click "Send Confirmation Email" to trigger the email:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.15.25.webp" width="75%"/>

4. Log in to the designated account and confirm the email via the mailtrap dashboard:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.16.23.webp" width="75%"/>

5. After confirmation, the user's admin dashboard will appear as follows:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.18.07.webp" width="75%"/>

**4.4 Comment on a Post**

1. Visit the post page and select a post for commenting:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.19.35.webp" width="75%"/>

2. Scroll down to the comment section, click "Write a comment," and submit the form:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.20.17.webp" width="75%"/>

3. As the admin, access the dashboard and click the notification button:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.20.39.webp" width="75%"/>

4. Choose the comment notification, access the backend URL, and review the comment:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.20.57.webp" width="75%"/>

5. Edit the comment status to "publish" to make it publicly visible:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.21.13.webp" width="75%"/>
   <img src="_resources/Screenshot%202023-08-11%20at%2016.21.22.webp" width="75%"/>

7. Verify that the comment is now visible:

   <img src="_resources/Screenshot%202023-08-11%20at%2016.21.55.webp" width="75%"/>

### Step 5 - Deploying the Next.js App

**5.1 Install Docker Engine 20.10.15**

To install Docker Engine 20.10.15, follow these steps:

1. Update the package repository and install required packages:
   ```sh
   sudo apt-get update
   sudo apt-get install ca-certificates curl gnupg
   sudo install -m 0755 -d /etc/apt/keyrings
   ```

2. Download and install the Docker GPG key:
   ```sh
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg
   ```

3. Add the Docker repository to the package sources:
   ```sh
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

4. Update the package repository again:
   ```sh
   sudo apt-get update
   ```

5. Install Docker Engine:
   ```sh
   VERSION_STRING=5:20.10.15~3-0~ubuntu-focal
   sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
   ```

**5.2 Setup Contentful**

1. Register on the Contentful webpage and create a space.

   <img src="_resources/Screenshot%202023-08-11%20at%2016.36.22.webp" width="75%"/>

2. Go to the API Keys dashboard via Settings -> API Keys on the main space dashboard.

   <img src="_resources/Screenshot%202023-08-11%20at%2018.25.04.webp" width="75%"/>

3. Under the "Content Delivery/Preview Tokens" tab, add an API key by clicking "Add API Key."

   <img src="_resources/Screenshot%202023-08-11%20at%2016.39.17.webp" width="75%"/>

4. Retrieve `CONTENTFUL_SPACE_ID`, `CONTENTFUL_ACCESS_TOKEN`, and `CONTENTFUL_PREVIEW_ACCESS_TOKEN` for later use.

   <img src="_resources/Screenshot%202023-08-11%20at%2016.40.16.webp" width="75%"/>

5. Still in the API Keys Dashboard, generate a personal access token by clicking "Generate Personal Token."

   <img src="_resources/Screenshot%202023-08-11%20at%2018.27.11.webp" width="75%"/>

   Copy the generated key for later use.

   <img src="_resources/Screenshot%202023-08-11%20at%2018.27.50.webp" width="75%"/>

**5.3 Deploy Next.js App to Docker**

1. Clone the Next.js project and download it:
   ```sh
   cd /var/www/html/
   sudo git clone https://gitlab.dot.co.id/kudaliar032/nextjs-intern-test.git
   ```

2. Set environment variables in the `.env.local` file based on the previously acquired data:
   ```sh
   cd nextjs-intern-test/
   sudo cp .env.local.example .env.local
   sudo nano .env.local
   ```
   Update the content to match the following:
   ```
   CONTENTFUL_SPACE_ID=<your_space_id>
   CONTENTFUL_ACCESS_TOKEN=<access_token>
   CONTENTFUL_PREVIEW_ACCESS_TOKEN=<your_preview_access_token>
   CONTENTFUL_PREVIEW_SECRET=<your_own_secret>
   ```

3. Update the `package.json` to use the appropriate React requirements:
   ```sh
   sudo nano package.json
   ```
   Ensure the following React dependencies:
   ```
   "react": "^18.2.0",
   "react-dom": "^18.2.0"
   ```

4. Create a Dockerfile with the specified content:
   ```sh
   sudo nano Dockerfile
   ```
   Dockerfile content:
   ```Dockerfile
   FROM node:16
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   RUN npx cross-env CONTENTFUL_SPACE_ID=<contentful space id> CONTENTFUL_MANAGEMENT_TOKEN=<contentful management token>  npm run setup
   RUN npm run build
   EXPOSE 3000
   CMD ["npm", "run", "start"]
   ```

5. Build the Docker image:
   ```sh
   sudo docker build -t my-nextjs-app .
   ```

6. Run the Docker image:
   ```sh
   sudo docker run -d -p 3000:3000 my-nextjs-app
   ```

**5.4 Configure Nginx**

1. Create an Nginx configuration file:
   ```sh
   sudo nano /etc/nginx/sites-available/nextjs-docker
   ```
   Paste the following content:
   ```nginx
   server {
       listen 80;
       server_name nextjs-docker.dot;  # Replace with your domain

       location / {
           proxy_pass http://localhost:3000;  # Address of your Docker container
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

2. Enable the Nginx configuration:
   ```sh
   sudo ln -s /etc/nginx/sites-available/nextjs-docker /etc/nginx/sites-enabled/
   ```

3. Restart Nginx:
   ```sh
   sudo systemctl restart nginx
   ```

### Step 6 - Testing the Next.js App

**6.1 Visiting the Initial Pages**

1. Visit the homepage:

   <img src="_resources/Screenshot%202023-08-11%20at%2017.22.12.webp" width="75%"/>

**6.2 Populating Some Data**
1. Go to the Contentful dashboard.

   <img src="_resources/Screenshot%202023-08-11%20at%2018.42.43.webp" width="75%"/>

2. Create a new author item by going to the Content section, clicking "Add Entry" -> "Author," and then publishing the data.

   <img src="_resources/Screenshot%202023-08-11%20at%2017.17.15.webp" width="75%"/>

3. Create a new post by going to the Content section, clicking "Add Entry" -> "Post," and then publishing the data.

   <img src="_resources/Screenshot%202023-08-11%20at%2017.20.01.webp" width="75%"/>

4. After populating some data, your Contentful dashboard should look similar to this.

   <img src="_resources/Screenshot%202023-08-11%20at%2017.21.27.webp" width="75%"/>

**6.3 Checking for Populated Data**

1. Visit the homepage again to see the data you created.

   <img src="_resources/Screenshot%202023-08-11%20at%2017.49.31.webp" width="75%"/>
   <img src="_resources/Screenshot%202023-08-11%20at%2017.49.41.webp" width="75%"/>
   
