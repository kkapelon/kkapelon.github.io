---
layout: post
title: The dark side of Docker multi-stage builds
category: containers
---

### Introduction

One of the most groundbreaking new features of [Docker](https://www.docker.com/) are [multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/). While in theory this is a much needed feature that everybody was asking for, in practice it can be heavily abused (at least at its present form).

In this article we will see why the current implementation of multi-stage builds is problematic. The feature is relatively new at the time of writing, but as time passes and more people use it, its questionable design will soon become apparent. 

We will explain how multi-stage builds can be easily abused using an extreme (but hopefully close to reality) example. Finally we will also offer some ideas on how to fix the syntax while keeping the existing functionality intact.

If you already know what multi-stage builds are, then skip straight to the [problem](#the-problem-with-multi-stage-builds). If not, then read on!

### Essential Theory - Artifacts of a Software Project

If you look at any software project at the most abstract level, you will soon realize that its resources fall under the following categories

1. Source code
1. Binaries 
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
| Binaries           |   Yes       |  Yes    |   Yes      |  Yes    |
| Build systems      |   Yes       |  Yes    |   Yes      |  No     |
| Test libraries     |   No        |  Yes    |   No       |  No     |
| Runtime services   |   No        |  No     |   No       |  Yes    |
| Deployment scripts |   No        |  No     |   Yes      |  No     |

The table above is one of the most important points of this article so make sure that you spend some time to understand all the possible cases it describes. It should be obvious that there is **NOT** a general pattern that resources follow. Some keys points are: 

* The build system is needed in all preparation phases, but its role is finished when the application is deployed
* Test libraries are only used in a specific phases (unit testing) and should never be deployed in production

### Essential Theory - Docker filesystem layers

### The problem with multi-stage builds







 



### Conclusion






