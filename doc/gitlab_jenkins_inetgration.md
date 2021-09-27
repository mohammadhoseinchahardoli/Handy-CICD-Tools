# Gitlab/Jenkins Integration Steps

1. Allow requests to the local network from web hooks and services, under admin area, setting, network, outbound requests.
2. Install Gitlab plugin in Jenkins.
3. Add hostnames and IP addresses of jenkins and gitlab servers
4. Setup ssh key authentication from Jenkins server or Slave to Gitlab server(Create ssh key under jenkins user on jenkins container, copy public key and past into setting, ssh keys, run ssh -T git@gitlab.local under jenkins user at jenkins container)
5. Create Access Token in Gitlab server via this privileges(api, read repository, write repository from setting, access token).
6. Create credential via Gitlab API Token in Jenkins server based on previous step.
7. Create a freestyle project in jenkins, based on git repository.(Description, Gitlab connection, Git URL, Build[Make gradlew executable, Tasks=>build], Post Build[dist/trainSchedule.zip, publish ])
7'. Create a multibranch pipeline in jenkins, based on git repository.(Display name, source branch)
8. Create API Token in Jenkins server, under username menu, configure section.
9. Create web hook in this format "http://USERID:APITOKEN@JENKINS_URL/project/YOUR_JOB", based on previous generated API Token under setting, integrations section.
10. If a freestyle project made, enable Build when a change is pushed to GitLab under task configure, build triggers.

REFs:
https://medium.com/@teeks99/continuous-integration-with-jenkins-and-gitlab-fa770c62e88a
https://github.com/jenkinsci/gitlab-plugin#gitlab-to-jenkins-authentication
