---
layout: post
title: Docker for Java Developers - The big picture
category: containers
---

### Introduction

The [Docker](https://www.docker.com/) train has already left the station and people are thinking if they should jump on or not.
It is true that Docker adoption is unprecedented compared to other technologies that were hyped before it.

Getting quality information on what Docker can do for you is surprisingly very difficult. At the time of writing, most Docker articles
and posts on the web fall under the following categories:

* [Official documentation](https://docs.docker.com/) that explains *how* things work, but not *why* and *when* you should use them
* Company sponsored articles from companies that are selling solutions on top of docker
* Very simple hello-world tutorials that (at least for the Java crowd) are not really that impressive
* Docker opinions from people who have used Docker in production to solve some very specific problems (that might be different than yours)
* Very short articles that present fancy pictures with real world containers and explain that Docker is the next best thing since sliced bread

Another issue with several Docker articles is the [elephant problem](https://en.wikipedia.org/wiki/Blind_men_and_an_elephant). Since Docker
touches so many areas (development, continuous delivery, operations), a lot of articles only view Docker from a specific standpoint and never
explain the big picture. For example, monitoring and debugging Docker containers is very conveniently left out from a lot of articles (implying
that this is a trivial problem)

It is also very hard to find language specific information for Docker. I can understand why Ruby and Python developers are excited about Docker, but in the Java world where good specs already exist, some of the Docker advantages are not that ground breaking.
(As a fun exercise, even if you are a Java developer, try to find installation guides on how a Ruby on Rails application is deployed in production)

Finally, the Docker train is following/leading the [Microservices](http://www.martinfowler.com/articles/microservices.html) train. Several articles confuse the two together even
though they are completely independent. You can use Docker with a monolith app, and you can have several micro-services
without using Docker at all. In this article we will just focus on Docker (this time around!).

### Target audience

The aim here is to look at Docker through the eyes of a Java developer. We will examine in a much more objective way
if Docker can really help you and we will attempt to de-hype the Docker craze.

First let's get this out of the way:

If you work in a pure Java shop and you already have the perfect build system based on VMs and everybody (developers, testers, operations) are happy, then adopting Docker is indeed an open question. You have to consider the possibility that Docker
will do more harm than good in your organization (at least in the initial adoption stages).

So don't feel bad if you read about Docker and just don't seem to grasp why everybody thinks that it is the only way going forward. This actually means that your organization has reached a high level of operational maturity.
Despite what Docker evangelists say around you, there are several stages for Docker adoption and you are free to stop at any of
them rather than doing all things the "Docker way". More on this later.

In fact, a major Docker disadvantage that _nobody talks about_ is that Docker is OS specific. Most Docker images
are targeted at Linux, and only recently [Docker has appeared on Windows](https://www.docker.com/microsoft). But (unless you use a VM) an OS
runs only its native images, Docker on Linux runs only Linux images and Docker on Windows runs only Windows Images. Sad but true.

This is a step backwards from the Java world (compile once - run everywhere) where the exact same WAR file can run equally well on Windows, Linux and even MacOS.
If you have a Java product that for some reason needs to be deployed on multiple OSs at the same time, then migrating to Docker
is a questionable decision.

Let me repeat that last sentence. Compared to the JVM which is OS agnostic, **Docker is a step backwards** and you should 
be highly skeptical when thinking about moving your Java apps to Docker images if that compatibility matters to you.

### The source of Docker confusion - the name itself

Understanding what Docker does is becoming even more difficult because "Docker" today is actually an ecosystem. When people
around you talk about Docker you should understand what part of Docker they are talking about. The company? The container? The format? The CLI?

Just to help you get around all this confusion I have created a table that attempts to map all Docker concepts
in the Java world. This table is not technically accurate as some technologies work differently under the hood. It is just here
to give you an fuzzy idea on how things match.

| Docker Term        | Description           | Java world  |
| ------------- |:-------------| -----|
| [Docker](https://www.docker.com/company)     | The company | Oracle (previously Sun) |
| [Docker image](https://github.com/docker/docker/tree/master/image/spec)    | The image format      |  WAR file |
| [Docker Engine](https://www.docker.com/products/docker-engine) | The runtime      |    Tomcat/Weblogic etc |
| [Docker Container](https://runc.io/) | The container      |    The JVM |
| [Docker client](https://docs.docker.com/engine/reference/commandline/cli/) | The image creator      |    Maven/Gradle |
| [Dockerfile](https://docs.docker.com/engine/reference/builder/) | The image definition      |    pom.xml/build.gradle|
| [Docker client](https://docs.docker.com/engine/reference/commandline/cli/)| The image runner      |    Weblogic CLI/Tomcat scripts |
| [Docker compose](https://docs.docker.com/compose/) | Grouping Docker images | EAR file |
| [Docker hub](https://hub.docker.com/) | Image repository | Maven central, [JCenter ](https://bintray.com/bintray/jcenter) |
| [Docker Machine](https://docs.docker.com/machine) | A VM with Docker installed| A VM with Tomcat installed |
| [Docker Swarm](https://www.docker.com/products/docker-swarm) | A cluster solution | Many proprietary Java solutions |

You can see instantly why "Docker" is such a confusing term and why it means so many things to different people.

You now have the power to understand what exactly people are talking about when they mention Docker. Spend 5 minutes on probing questions until you are certain that you know what part of Docker they refer to.
Knowing this information
is important as you will see later on.

It is interesting to note that Docker has several competitors. The biggest one as far as containers are concerned is [RKT](https://coreos.com/rkt/).
And in the clustering arena at the time or writing, Docker Swarm lags behind [Google Kubernetes](http://kubernetes.io/).

Docker (the company) is moving to a standards based approach, creating specs for several critical parts of the whole ecosystem.
Whether that will lead to a world similar to JavaEE remains to be seen.

### Docker considerations for the Java developer

The comparison table above should already save you a lot of time. Now every time that you read a Docker article and it
starts talking about this magic way of "creating self-contained archives that include all application code", you can just
shake your head and move on (as the article is probably not targeted at Java developers).

In a similar manner, if a Docker article talks about how you should "push your Docker image to a repo and then pull it at a later
pipeline stage", you should laugh, as this is the only valid way to run a proper [continuous delivery](http://martinfowler.com/books/continuousDelivery.html) organization (and you
should be doing that already).

In my experience, people outside the Java ecosystem are first impressed with Docker - the image format, and secondly with Docker - the container runtime. They almost always assume that Linux is used both in production and in development (something that is not always true in the Java world). The idea that the same Docker image is used both in production and in development 
is something unique in their eyes (because they are unaware that this was already a reality in the Java world even before Docker).

Despite what Docker zealots tell you, as a Java developer you really need to see Docker as a lightweight VM technology. 
If your existing VM infrastructure suffers from speed, then Docker indeed can help you. If however, VM speed
is not essential to you (and your existing issues are completely different) then a possible Docker adoption needs a very carefully planned evaluation phase on your part.

In particular, if you are a heavy JavaEE user and your application is a single WAR/EAR file that gets deployed on
Weblogic/Websphere and uses a big bulky Oracle DB, I would advise you to stay away from the Docker craze
until you are fully certain that you understand the implications behind adding another level of complexity
in your organization.

So with that in mind let's see some tangible advantages. As an example application we will assume that we have the following components:

 1. A Java application that implements a Web interface and accepts customer orders
 1. A Mysql DB that is used for main storage
 1. A second Java application the creates reports and keeps metrics
 1. A Mongodb for keeping metrics
 1. A RabbitMQ instance for communication among the two applications.

 Here is the diagram 

 Image here

So let's see what Docker brings into the mix.

#### Advantage 1 - Running integration tests on developers' machines

The first advantage and my recommendation for starting with Docker, is to attempt to Dockerize your application in your workstation *only*. This means that with [Docker Compose](https://docs.docker.com/compose/) you should be able to replicate the full running system in your own
workstation/laptop.

Normally, before you commit a piece of code you need to make sure that it passes all test suites (unit, integration, functional, acceptance). In practice however, developers just run unit tests locally and then assume that integration tests will be handled by the build server at a later stage.

Ideally you want to have the shortest possible feedback cycle and instead of waiting for the build server, have the ability to find problems *before* they are committed. Even if the integration tests take a long time, you should be able to run only a subset of them to verify that nothing is broken in your local workstation.

Docker gives you the ability to setup the complete environment locally and re-run the same integration tests 
the build server would perform after your commit.

 Image here

Of course you also achieve the same effect by running a VM locally that contains all components of the system. But because
Docker does not take as many resources as a VM you can extend this idea to run *any number of complete environments* at the same time.

As an extreme case you could launch at the same time using Docker containers

1. The feature you are working on now
1. The branch of a colleague that needs some feedback
1. The production version of the system for load testing
1. A hotfix version for some important bugs

 Image here

Having a large number of VMs running can quickly overwhelm a single workstation. With Docker containers however, this becomes
a possibility.


#### Advantage 2 - Debugging applications locally

#### Advantage 3 - Creating test environments on demand

#### Advantage 4 - Stateless to the extreme

#### Advantage 5 - Working in a polyglot organization


### Docker adoption stages

##### Stage 1 - Only Developers use Docker

##### Stage 2 - Docker enters the build server

##### Stage 3 - Docker is used for Testing/QA

##### Stage 4 - Docker is used in Production

##### Stage 5 - Docker is used for everything

### Conclusion



