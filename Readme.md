Objective

This document provides architecture,designed to equip you with hands-on experience and practical knowledge of the AWS Cloud platform. Following the steps outlined in these architecture based questions will give you a deeper understanding of various AWS services, Terraform and functionalities.

Architecture

This AWS architecture represents a three-tier application, designed to ensure high availability, scalability, and security across all layers. The architecture is deployed in the AWS us-east-1 region within a dedicated Virtual Private Cloud (VPC). The VPC is segmented into public and private subnets, each serving distinct functions within the architecture. Set up an environment as per the below architecture diagram using terraform.


Outcome
A complete and fully functional wordpress application will be deployed and accessible via a custom domain name managed by Route 53. The application will be served to end-users through CloudFront, ensuring low latency and fast content delivery.

Reference
To install a Wordpress application on EC2. This is just for reference, you choose any other application as well.

https://aws.amazon.com/tutorials/deploy-wordpress-with-amazon-rds/
https://medium.com/@ashutoshranjanpatratu/step-by-step-guide-to-set-up-wordpress-on-aws-ec2-with-rds-2b288135413 

You may follow the below for testing the working of Lambda and S3 along with dynamoDB. Again, this is just for reference, you may choose any other application as well.

https://aws.amazon.com/blogs/compute/creating-a-scalable-serverless-import-process-for-amazon-dynamodb/ 

Key Considerations and pointers that you can think of here while creating this architecture:

How can we efficiently scale WordPress horizontally on EC2 to handle increased traffic?

What strategies can we employ to maintain application consistency and data synchronization across multiple EC2 instances?

What specific optimizations can we implement on our AWS infrastructure to improve WordPress performance and scalability?

How can we leverage AWS services like CloudFront, S3, and Route 53 to enhance user experience and reduce costs?

What advantages do AWS Graviton2-powered EC2 instances offer for WordPress deployments, and when are they suitable?

How can we assess the cost-benefit trade-off between Graviton2 instances and other EC2 options?

How can caching be effectively implemented to improve WordPress page load times and reduce database load?

What types of caching (e.g., page caching, object caching, query caching) are most beneficial for WordPress, and why?

How does object caching affect database query performance in a WordPress environment?

Can you provide specific examples of how object caching can reduce database load and improve overall site speed?
What are the different ways to scale RDS instances to accommodate growing database demands?

When is it appropriate to scale RDS vertically (increasing instance size) versus horizontally (adding more instances)?
How can we ensure data consistency and availability during RDS scaling operations?

How can we implement robust security measures to protect our WordPress deployment on AWS, including measures to prevent common WordPress vulnerabilities?

What tools and strategies can we use to monitor the performance and health of our WordPress infrastructure, and how can we effectively analyze logs to identify and address issues?

How can we optimize our AWS costs for the WordPress deployment, including exploring cost-saving options like reserved instances, spot instances, and on-demand pricing?

What disaster recovery strategies should we put in place to ensure business continuity and minimize downtime in case of failures or outages?
