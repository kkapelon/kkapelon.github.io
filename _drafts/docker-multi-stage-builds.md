---
layout: post
title: The dark side of Docker multi-stage builds
category: containers
---

### Introduction

One of the most groundbreaking new features of [Docker](https://www.docker.com/) is support for [multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/). While in theory this is a much needed feature that everybody was asking for, in practice it can be heavily abused (at least at its present form).

In this article I will show you why the current implementation of multi-stage builds is problematic. The feature is relatively new at the time of writing, but as time passes and more people use it, its questionable design will soon become apparent. 

I will explain how multi-stage builds can be easily abused using an extreme (but hopefully close to reality) example. Finally I will also offer some ideas on how to fix the syntax while keeping the existing functionality intact.

If you already know what multi-stage builds are, then skip straight to the [problem](#the-problem-with-multi-stage-builds). If not, then read on!

### Essential Theory - Artifacts of a Software Project

If you look at any software project at the most abstract level, you will soon realize that its resources fall under the following categories

1. Source code
1. Artifacts
1. Libraries used
1. Build systems
1. Test libraries and support
1. Runtime libraries and associated services
1. Deployment scripts 

The typical project lifecycle is also assumed to be the following

1. Compilation 
2. Unit Testing
3. Deployment
4. Running the deployed application.

There are some slight differences depending on your programming language (if sources are compiled or not), but for the sake
of this discussion lets assume that we always have a compilation phase, which in the case of interpreted runtimes, includes minification/obfuscations steps. 

By cross-referencing the resources from the first list with the phases from the second list we can define which of the resources are used at which phase.

|  Needed during...  | Compilation | Testing | Deployment | Running |
| -------------      |-------------| -----   |       -----|    -----|
| Source code        |   Yes       |  Yes    |   No       |  No     |
| Libraries          |   Yes       |  Yes    |   Yes      |  Yes    |
| Artifacts          |   No        |  No     |   Yes      |  Yes    |
| Build systems      |   Yes       |  Yes    |   Yes      |  No     |
| Test libraries     |   No        |  Yes    |   No       |  No     |
| Runtime services   |   No        |  No     |   No       |  Yes    |
| Deployment scripts |   No        |  No     |   Yes      |  No     |

The table above is one of the most important points of this article so make sure that you spend some time to understand all the possible cases it describes. It should be obvious that there is **NOT** a general pattern that resources follow. For example: 

* The build system is needed in all preparation phases, but its role is finished when the application is deployed
* Test libraries are only used in a specific phases (unit testing) and should never be deployed in production

This is an important observation and will be the basis for the mismatch between the software lifecycle and the way Docker images work.

### Essential Theory - Docker filesystem layers

Docker is currently changing the way deployments work, but as with any hyped technology before it, most people see
only the advantages without truly understanding how the technology works. Now, don't get me wrong, Docker is indeed moving things forward. However, blindly using a technology without looking at what happens behind the scenes is always a recipe for disaster.

Even the official [overview page](https://docs.docker.com/engine/docker-overview/) talks more about Docker as a deployment platform and less as a storage format. I know that any new technology needs some heavy marketing in order to be promoted, but in some cases I would even go as far to call Docker promotional material misleading.

Lets's take for example this popular image that talks about Docker layers.

![Docker layers](../../assets/docker-multi-stage-builds/container_layers.png)





### The problem with multi-stage builds







 



### Conclusion






