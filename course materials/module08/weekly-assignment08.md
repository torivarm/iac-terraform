Infrastructure as Code - Modularization and Stack Components with Terraform and Azure

This weekly assignment is designed to assess your ability to apply theoretical concepts related to Infrastructure as Code, particularly the modularization of infrastructure and management of stack components, using Terraform and Microsoft Azure. You will be asked to discuss and design solutions to given scenarios that reflect real-world challenges in managing cloud infrastructure.
Assignment context:
In the contemporary cloud computing landscape, the ability to define, deploy, and manage infrastructure in a modular, efficient, and scalable manner is pivotal. As you have learned from the theoretical foundation provided in the course, components such as server instances, stack modules, and environment estates must be structured in a way that supports independence, reuse, and scalability while mitigating risks associated with tight coupling and monolithic designs.
Tasks:
1.	Modularizing a Monolithic Infrastructure:
Imagine you are working with a legacy Azure infrastructure that is currently structured as a monolithic stack. It includes various tightly coupled resources such as networking components, server clusters, and databases. Your first task is to propose a modularization strategy.
•	Discuss the principles of modularization in the context of IaC, including the benefits and potential challenges.
•	Design a plan to refactor the monolithic stack into a series of modular stacks, ensuring that you explain how each stack could be independently deployable and manageable.
•	Utilize Terraform to demonstrate how you would structure the code for one of the modular stacks, considering the principles of high functional cohesion and minimized coupling.

2.	Implementing Stack Components with Terraform and Azure:
Building upon your modularization plan, you are to implement a prototype using Terraform that represents a portion of the modular infrastructure.
•	Select a component of the infrastructure (e.g., Virtual Machine scale set, networking, or database) and construct a Terraform module that encapsulates this component.
•	Explain how parameters and variables can be utilized to make your module adaptable to different environments or requirements.
•	Address potential issues with versioning and interdependencies between modules and stacks, providing a strategy for managing these using Terraform and Azure features.

3.	Simulation of Infrastructure Pipelines:
With the stacks now modularized, you need to establish infrastructure pipelines that support continuous integration and delivery (CI/CD).
•	Discuss the role of pipelines in the delivery of IaC, including testing, integration, and deployment stages.
•	Craft a sample pipeline configuration that would automate the testing and deployment of one of your Terraform modules.
•	Describe how you would simulate an infrastructure change within the pipeline, including the provisioning of resources in Azure and how you might handle rollbacks or infrastructure recovery.

Deliverables:
•	A short and summarized report that includes the discussions and designs for each task, complemented by diagrams where appropriate.
•	Terraform pseudocode snippets / files that demonstrate the implementation strategies proposed in your report.
•	Any assumptions made or constraints identified should be explicitly stated within your report.
