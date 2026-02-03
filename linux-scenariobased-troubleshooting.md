## LINUX | SCENARIOBASED INTERVIEW QUESTIONS AND ANSWERS 
1) You are managing a fleet of web servers running on Ubuntu 18.04. You need to install the latest version of Apache and PHP on all of the servers.
How would you automate this task using a DevOps tool?
Answer:
You could use a configuration management tool like Ansible or Chef to automate the installation of Apache and PHP on all of the servers. These tools allow you to define the desired state of your infrastructure and then automatically provision and configure the servers to match that state.

2) You are deploying a new application to a server running on CentOS 7. The application requires a specific configuration file to be in place before it can start.
How would you ensure that the configuration file is in place before the application starts?
Answer:
You could use a systemd service unit to define the dependencies of the application service. This would ensure that the configuration file is copied to the correct location before the application service is started.


3) You are monitoring the performance of your application and you notice that the CPU usage is spiking. You need to identify the cause of the CPU spikes and take corrective action.
Answer:
You could use a performance monitoring tool like Nagios or Prometheus to collect and analyze CPU usage data. This would help you to identify the processes that are causing the CPU spikes and take corrective action, such as restarting the processes or tuning their configuration.

4) You are experiencing network latency issues on your production network. You need to troubleshoot the cause of the latency and resolve it.
Answer:
You could use network troubleshooting tools like tcpdump or Wireshark to capture and analyze network traffic. This would help you to identify the source of the latency and take corrective action, such as upgrading network hardware or adjusting network configurations

5) You are deploying a new application to a server running on Debian 11. The application requires a specific database to be installed.
How would you install and configure the database for the application?
Answer:
You could use a package manager like apt or yum to install the database software. You would then need to configure the database by creating a database, creating a user, and granting the user the necessary privileges.

6) You are migrating your application from a physical server to a cloud platform. You need to ensure that the application is deployed and configured correctly in the cloud environment.
How would you automate the deployment of the application to the cloud platform?
Answer:
You could use a cloud infrastructure as code (IaC) tool like Terraform or CloudFormation to define the desired state of your cloud infrastructure. This would allow you to automate the provisioning and configuration of the cloud resources that your application needs.

7) You are experiencing security issues on your production network. You need to identify and remediate the vulnerabilities.
How would you use vulnerability scanning tools to identify and remediate vulnerabilities?
Answer:
You could use vulnerability scanning tools like Nessus or OpenVAS to scan your network for vulnerabilities. These tools would identify the vulnerabilities and provide remediation recommendations.

8) You are experiencing performance bottlenecks with your application. You need to identify and resolve the bottlenecks.
How would you use performance profiling tools to identify and resolve performance bottlenecks?
Answer:
You could use performance profiling tools like gprof or VTune to identify the performance bottlenecks in your application. These tools would identify the parts of the code that are taking the most time to execute and provide recommendations for optimization.

9) You are experiencing memory leaks in your application. You need to identify and fix the memory leaks.
How would you use memory profiling tools to identify and fix memory leaks?
Answer:
You could use memory profiling tools like valgrind or Massif to identify the memory leaks in your application. These tools would identify the objects that are not being properly garbage collected and provide recommendations for fixing the leaks.

10) You are experiencing concurrency issues in your application. You need to identify and resolve the concurrency issues.
How would you use concurrency testing tools to identify and resolve concurrency issues?
Answer:
You could use concurrency testing tools like JMeter or Gatling to simulate concurrent usage of your application. These tools would identify the concurrency issues and provide recommendations for resolving them.


11) You are working on a production server that is experiencing high CPU usage. How would you identify the cause of the high CPU usage and take corrective action?
Answer:
Use the top command to identify the processes that are consuming the most CPU resources.
Analyze the output of the top command to determine the cause of the high CPU usage. This could be due to a runaway process, a resource-intensive script, or a misconfigured application.
Depending on the cause, take appropriate corrective action. This may involve killing the runaway process, stopping or restarting the resource-intensive script, or reconfiguring the application.


12) A user is unable to log in to their account on a Linux server. How would you troubleshoot this issue?
Answer:
Verify that the user's account exists and has the correct password. Use the passwd command to check the user's password and the cat /etc/passwd command to verify that the user exists.
Check for any locked-out accounts. Use the last -x user command to see if the user's account has been locked out due to too many failed login attempts.
Check for any permission issues. Use the ls -ld /home/user command to check the permissions of the user's home directory.


13) A web application deployed on a Linux server is experiencing slow performance. How would you troubleshoot this issue?
Answer:
Monitor the server's resource usage, including CPU, memory, and disk I/O. Use tools like top, ps, and free to gather this information.
Analyze the web application's logs to identify any errors or performance bottlenecks. Use tools like grep and awk to parse the logs.
Profile the web application to identify any performance issues in the code. Use tools like gprof or valgrind to profile the application.



14) A Linux server is experiencing a sudden drop in network connectivity. How would you troubleshoot this issue?
Answer:
Verify that the network cable is connected properly and that the network interface is up. Use the ifconfig command to check the status of the network interface.
Check for any network-related errors or messages in the system logs. Use the dmesg command to view the system logs.
Test network connectivity to other devices on the network. Use tools like ping or traceroute to test connectivity.



15) A user accidentally deletes an important file on a Linux server. How would you recover the deleted file?
Answer:
Check the user's trash or recycle bin to see if the file was deleted recently. Use the trash command to access the trash or recycle bin.
Use file recovery tools like testdisk or foremost to scan the disk for deleted files.
If the file was not recently deleted, it may be difficult to recover. Consider using data recovery services if necessary.



16) A Linux server is experiencing a security breach. How would you identify the extent of the breach and take corrective action?
Answer:
Gather information about the breach, such as when it occurred, how it was initiated, and what systems were affected.
Isolate the affected systems to prevent further damage and preserve evidence.
Analyze the system logs to identify any suspicious activity or unauthorized access.
Identify and patch any vulnerabilities that were exploited in the breach.
Implement additional security measures to prevent future breaches.



17) A Linux server is running low on disk space. How would you free up disk space and prevent future disk space issues?
Answer:
Identify the files or directories that are consuming the most disk space. Use the du command to analyze disk usage.
Remove unnecessary files or directories.
Archive or compress large files to reduce their size.
Implement a regular disk usage monitoring system to identify potential disk space issues early on.



18) A Linux server is experiencing a power outage. How would you ensure that the server shuts down gracefully and data is not lost?
Answer:
Implement a UPS (Uninterruptible Power Supply) to provide backup power during power outages.
Configure the server to automatically shut down when the battery level reaches a certain threshold. Use tools like poweroff or shutdown to configure automatic shutdown.
Implement a data replication or backup strategy to



19) You are managing a web server running on Ubuntu 18.04. The server is experiencing high CPU usage and you need to identify the root cause of the problem.
What steps would you take to troubleshoot the high CPU usage issue?
Answer:
Check the top or htop commands to identify the processes that are consuming the most CPU resources.
If a specific process is causing the high CPU usage, investigate the application or service that is associated with that process.
If the high CPU usage is not caused by a specific process, check other potential causes such as high disk I/O, excessive network traffic, or system-level issues like load balancing or resource contention.


20) You are deploying a new application to a production environment. The application is a Java-based web application that requires specific configurations and dependencies.
How would you approach the deployment of the Java-based web application in a production environment?
Answer:
Create a dedicated user account for the application to isolate it from other system users.
Install the required Java runtime environment and any additional libraries or dependencies.
Configure the application server, such as Tomcat or Jetty, to run the application.
Implement a deployment strategy that allows for rolling updates or seamless transitions between versions.
Configure monitoring and alerting mechanisms to track application performance and health.



21) You are responsible for managing a fleet of Linux servers across multiple data centers. You need to ensure that all servers are up-to-date with the latest security patches.
What strategies would you use to automate the patch management process for your Linux servers?
Answer:
Implement a centralized configuration management tool such as Ansible, Chef, or Puppet to automate the installation of security patches.
Utilize a vulnerability scanning tool to identify missing patches and prioritize them based on severity.
Schedule regular patch deployment windows and implement rollback plans in case of issues.
Monitor patch installation status and address any failures or errors promptly.
Document the patch management process and maintain up-to-date records.


22) You are troubleshooting a network connectivity issue on a Linux server. The server is unable to ping other devices on the network.
What steps would you take to diagnose the network connectivity problem?
Answer:
Verify that the network interface is properly configured and enabled.
Check the IP address and subnet mask of the server.
Test connectivity to a known-good device, such as a router or another server.
Check for network connectivity errors in the system logs.
If the problem persists, consider using network troubleshooting tools like tcpdump or wireshark to capture and analyze network traffic.



23) You are investigating a performance issue with a database server running on Linux. The database is experiencing slow query response times.
Answer:
Analyze the database server logs to identify any performance-related issues or bottlenecks.
Check the database configuration parameters, such as memory allocation and cache settings.
Monitor database resource utilization, including CPU, memory, and I/O usage.
Optimize database queries to improve performance.
Consider scaling the database if hardware resources are insufficient.



24) You are migrating a legacy application from a physical server to a cloud environment. The application is running on CentOS 7 and uses a traditional file-based backup system.
Answer:
Assess the application's requirements and identify any dependencies or compatibility issues.
Create a cloud instance with the appropriate operating system and hardware specifications.
Migrate the application files and data to the cloud instance.
Configure the application server and services on the cloud instance.
Implement a cloud-based backup solution for the application.
Test the migrated application to ensure it functions as expected in the cloud environment.



25) You are tasked with implementing a containerization strategy for a microservices-based application. The application is currently deployed on multiple physical servers.
Answer:
Evaluate containerization platforms such as Docker, Kubernetes, or OpenShift.
Containerize the microservices using the chosen platform.
Set up a container registry to store and manage container images.
Deploy the containerized microservices to a container orchestration platform.
Configure load balancing and service discovery for the microservices.
Implement monitoring and logging for the containerized application.





26) You are managing a fleet of web servers running on Ubuntu 18.04. You need to install the latest version of Apache and PHP on all of the servers.
How would you automate this task using a DevOps tool?
Answer:
You could use a configuration management tool like Ansible or Chef to automate the installation of Apache and PHP on all of the servers. These tools allow you to define the desired state of your infrastructure and then automatically provision and configure the servers to match that state.



27) You are deploying a new application to a server running on CentOS 7. The application requires a specific configuration file to be in place before it can start.
How would you ensure that the configuration file is in place before the application starts?
Answer:
You could use a systemd service unit to define the dependencies of the application service. This would ensure that the configuration file is copied to the correct location before the application service is started.



28) You are monitoring the performance of your application and you notice that the CPU usage is spiking. You need to identify the cause of the CPU spikes and take corrective action.
Answer:
You could use a performance monitoring tool like Nagios or Prometheus to collect and analyze CPU usage data. This would help you to identify the processes that are causing the CPU spikes and take corrective action, such as restarting the processes or tuning their configuration.



29) You are experiencing network latency issues on your production network. You need to troubleshoot the cause of the latency and resolve it.
Answer:
You could use network troubleshooting tools like tcpdump or Wireshark to capture and analyze network traffic. This would help you to identify the source of the latency and take corrective action, such as upgrading network hardware or adjusting network configurations.


30) You are deploying a new application to a server running on Debian 11. The application requires a specific database to be installed.
How would you install and configure the database for the application?
Answer:
You could use a package manager like apt or yum to install the database software. You would then need to configure the database by creating a database, creating a user, and granting the user the necessary privileges.

31) You are migrating your application from a physical server to a cloud platform. You need to ensure that the application is deployed and configured correctly in the cloud environment.
How would you automate the deployment of the application to the cloud platform?
Answer:
You could use a cloud infrastructure as code (IaC) tool like Terraform or CloudFormation to define the desired state of your cloud infrastructure. This would allow you to automate the provisioning and configuration of the cloud resources that your application needs.



32) You are experiencing security issues on your production network. You need to identify and remediate the vulnerabilities.
How would you use vulnerability scanning tools to identify and remediate vulnerabilities?
Answer:
You could use vulnerability scanning tools like Nessus or OpenVAS to scan your network for vulnerabilities. These tools would identify the vulnerabilities and provide remediation recommendations.



33) You are experiencing performance bottlenecks with your application. You need to identify and resolve the bottlenecks.
How would you use performance profiling tools to identify and resolve performance bottlenecks?
Answer:
You could use performance profiling tools like gprof or VTune to identify the performance bottlenecks in your application. These tools would identify the parts of the code that are taking the most time to execute and provide recommendations for optimization.



34) You are experiencing memory leaks in your application. You need to identify and fix the memory leaks.
How would you use memory profiling tools to identify and fix memory leaks?
Answer:
You could use memory profiling tools like valgrind or Massif to identify the memory leaks in your application. These tools would identify the objects that are not being properly garbage collected and provide recommendations for fixing the leaks.



35) You are experiencing concurrency issues in your application. You need to identify and resolve the concurrency issues.
How would you use concurrency testing tools to identify and resolve concurrency issues?
Answer:
You could use concurrency testing tools like JMeter or Gatling to simulate concurrent usage of your application. These tools would identify the concurrency issues and provide recommendations for resolving them.


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


10 linux commands that you use on day to day basis.

Kill vs Kill -9 in Linux

Find and remove the log files older than 30 days in a folder.

Cronjob + Shell script to perform advanced log rotation (Scenario Provided)

Bulk creation of linux users using CSV file.

Service Health monitor script in Bash

Find and delete files over 100MB    ----  find / -size +100M -delete

Can you restore lost pem file ? If not how can you access the instance ?

/Var is almost 90 percent full, What will be your next steps ?

Linux Server is slow due to High CPU utilization. How will you fix it ?

Application deployed on Nginx returns Connection Refused, How will you fix it ?

SSH to an instance stopped working ? How will you troubleshoot the issue 
Find and list the log files older than 7 days in /var/log folder.

Get the list of users who logged in today (scenario - some packages deleted)

Website doesn't load, How will you investigate ??

Using sed command, how to remove first and last line of the file

What are the different types of variables in Linux ?


How do you combine Multiple commits into a Single commit ?

Explain 10 Git Commands that you use on Day to Day basis ?

I want to ignore pushing changes to a file to Git, How can you do it ?

What is the purpose of .git folder in a Git repository ?

Can you restore a deleted .git folder ?

A teammate accidentally committed a Kubernetes Secret (base64 encoded) to Git.

Explain a scenario where you used Git Fork instead of Git Clone.

Git Fork in action with example

Create a fork of the project mentioned below and create a pull request

Git Fetch vs Git Pull

Show how does Git Fetch and Pull work in Realtime.

Which command do you use mostly - Git Fetch or Git Pull and why ?

Practice Git Fetch vs Git Pull on a GitHub Repo.

Git Rebase vs Git Merge Detailed Explanation

Show practically how Git Rebase is different from Git Merge

How to explain Git Merge vs Git Rebase in Interviews 

Git Fork vs Git Clone

Have you ever used Git tags ? If yes, why ?

Practice Git Merge vs Git Rebase

Explain the Git Branching Strategy that you used in your company.

Explain 3 challenges that you faced with Git during your work experience.

Explain the recent challenge that you faced with Git and how did you address it

How do you handle Merge conflicts in Git ?

Explain Git Merge Strategies - Ours and Theirs strategies

Create a Merge Conflict and address it locally using Git merge

Create a feature branch from the main branch. 
Pick up a file and update same line in both the branches. Merge feature branch into main -> You will see a merge conflict. Fix the Merge conflict.

