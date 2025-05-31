# Jenkins <img src="https://www.jenkins.io/images/logos/jenkins/jenkins.png" alt="Jenkins Logo" height="30">  Setup with Docker <img src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png" alt="Docker Logo" height="30">

This project provides a fully automated setup for Jenkins using Docker, enabling you to run Jenkins with Docker-in-Docker (DIND) support. 

---

## ✨ What’s Included

| File                     | Purpose                                                                                                    |
| ------------------------ | ---------------------------------------------------------------------------------------------------------- |
| **`jenkins.Dockerfile`** | Builds a Jenkins image that contains Docker CLI and a set of pre‑selected plugins (customisable).  |
| **`make_jenkins.mk`**    | Makefile that drives the entire Jenkins lifecycle.                                                         |

---

## ⚙️ Prerequisites

1. **Docker** must be installed and running.
2. **Make** must be installed (for running the Makefile).
3. **Jenkins credentials file** – After setting up Jenkins, create a file named **`.priv_jauth`** containing:

   ```json
    {
        "user": "your-jenkins-username",
        "token": "your-jenkins-api-token"
    }
   ```

    >  you can generate an API token by going to **Jenkins → Your Profile → Security → API Token → Add New Token**.

4. *(Optional)* environment overrides

| Variable         | Default                  | Description                                 |
| ---------------- | ------------------------ | ------------------------------------------- |
| `CONTAINER`      | `docker`                 | The Docker executable.                      |
| `JENKINS_SERVER` | `localhost`              | Hostname where Jenkins will be reachable.  |
| `JENKINS_JOB`    | *current directory name* | Job name to trigger.                        |

---

## 🛠 Make Targets

### Local Targets

| Target                 | What it does                                                         |
| ---------------------- | -------------------------------------------------------------------- |
| **`.bridge-network`**  | Creates a Docker network named jenkins for container communication.  |
| **`.run-dind`**        | Starts a DIND container, enabling Jenkins to run Docker commands.    |

### User Targets

1. **`jenkins-build`**
    - Pulls the latest base image.
    - Builds the image with the name `myjenkins-blueocean:2.510`.

2. **`jenkins-start`**    
    - Starts the container with the name `jenkins-blueocean`.
    - Maps ports 8080 and 50000.
    - Waits for Jenkins to be ready by polling the login URL.
    - Prints the initial admin password (on first run).

3. **`jenkins-stop`**     
    Stops the Jenkins container and the DIND container.
    
4. **`jenkins-clean`**    
    Stops and removes all Jenkins-related containers, networks, images, and volumes.
    
5. **`jenkins-ws-clean`**    
    Deletes all files in `/var/jenkins_home/workspace`.
    > Uses root privileges to ensure removing all files.

6. **`jenkins-validate`**    
    Sends the local **`Jenkinsfile`** to the Pipeline Model Converter for syntax validation.
    > Requires `.priv_jauth` for authentication.

7. **`jenkins-trigger`**  
    Sends a POST request to trigger the `JENKINS_JOB`.
    > Requires `.priv_jauth` for authentication.

## 📝 Usage
- To invoke the script from the terminal, navigate to the directory containing the `make_jenkins.mk` file and run:

    ```bash
    make -f make_jenkins.mk <user-target>
    ```

- To integrate it to a main Makefile, include the following line:

    ```makefile
    include path/to/make_jenkins.mk
    ```
    > make sure variables defined in the main Makefile do not conflict with those in `make_jenkins.mk`.

- After initial setup, don't forget adding credentials to `.priv_jauth`.

This script uses Unix-style syntax. Tested on Linux and macOS. For Windows, consider using WSL.

## 🤝 Contributing

Found a bug or have an improvement? PRs and issues are welcome!
