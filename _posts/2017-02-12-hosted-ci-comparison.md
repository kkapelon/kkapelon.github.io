---
layout: post
title: Hosted CI comparison survey
category: hosted-ci-comparison
---

### Comparison of hosted Continuous Integration services

This page describes my comparison criteria. Feel free to go directly to the review of a particular service below:

* Buddy Works
* [CircleCI review]({% post_url 2016-04-24-circleci-review %})
* Codefresh review
* Codeship review
* DeployBot review
* Distelli review
* Drone.IO review
* SemaphoreApp review
* Shippable review
* SolanoLabs review
* Travis review
* Vexor review
* Wercker review
* Zeroci review


##### Comparison Criteria

Rather than writing a few sentences for each company or creating a big grid with features (these are loved by marketing folks but are not always useful to developers) I will instead provide my comparison criteria in a well structured manner. This way you can select that criteria that matter to YOU and decide on your own which is best according to your needs.

Because I am mainly a Java developer I have tested all of them with JVM projects. Here are those that I left out:

* [GreenhouseCI](https://greenhouseci.com/) (Android and iOS only)
* [Bitrise](https://www.bitrise.io/) (Android and iOS only)
* [AppVeyor](http://www.appveyor.com) (Windows only)
* [AppHarbor](https://appharbor.com/) (.NET only)
* [MagnumCI](https://magnum-ci.com/) (Supports Ruby, Go, PHP,Python but not Java)

For the rest of the companies I compare the following areas:

###### 1. Connectivity

By connectivity I mean how easy it is to bring your code into the service. Even though Github is the most popular solution, not all projects use it. A product is getting high points on this area if it supports several ways of fetching the source code.

###### 2. First-time setup

Setting a build server can be a time-consuming process if your project is complicated. Getting a prototype project to work might be easy, but you are not done until the real project actually works, and the build artifact(s) are the same as your local setup (e.g. Jenkins). A product gets high points in this area if it guides me well through my first steps with it. There were cases where getting a to a successful build was a matter of seconds, and cases where I spent hours in order to understand what the service expected of me.


###### 3. User Interface

Getting a build running is only the beginning. If you have many projects on a CI system you also need a way to monitor and manage them. Here I looked at the “dashboard” of each solution, its organization of web pages, reports and navigation links and in general how user friendly the system is. I realize that a good UI can be subjective, so in most cases I emphasized bad points of User Experience (which are arguably easier to detect).

###### 4. Build environment

Perhaps the most important metric. This area includes the programming languages supported by the product (but as I said already I will focus on Java), the versions of compilers present, build systems and how easy it is to update or install new software. A product gets high points if it has extensive configuration properties and allows me to define the build environment in an intuitive way.

###### 5. Docker support

Even though most people think about Docker in conjuction with Kubernetes for a production deployment, in fact I think
that Docker is much more useful in the development phase. Specifically it allows you to create your own build environment.
Your favourite CI service does not have the latest GO compiler, but supports Docker? Just spin a Docker instance with your
own Go compiler. You can do the same thing for Maven and JDK of course. Docker support might be less
useful if your project has adopted [Gradle wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html)

###### 6. Feedback

With the build in place, there are several things that can go wrong with it. Wrong environment setup, failed unit tests, unresponsive external services and so on. A product is getting high points in the this area if is allows real-time monitoring of the build, and excessive logging on things that went wrong. Some solutions even allowed for ssh connections to the build servers which is a really nice feature to have when the build does not do what you expected it.

###### 7. Post-build steps/deployments

Assuming that the build is complete you need to do something with the results. Maybe deploy the artifact to a staging server, send an email, upload it to FTP, update a bug issue or anything that matches your process. A product is getting high points in this area if it offers several post-build hooks to allow you to take advantage of the build. 

###### 8. Enterprise features

Getting a simple web project to build might be easy but not all projects are that simple (not all projects are web projects as well). Multi-module builds, pipelines, support for pull requests, and having a huge number of active projects with long build history are examined in this area. Products get high points if they cater to complex build processes. This is one of the area has has of lot of diversity as different companies have a different mindset on what exactly an “enterprise” wants.

###### 9. Documentation

There is no such thing as too much documentation. Unfortunately not all companies embrace this idea. Giving access to quick tutorials is one thing, having a complete reference guide is another. Products get high points if they come with a detailed explanation of how they work and what they do.

###### 10. Support

Last, but not least I tested how responsive to email communication are these projects. When things go wrong you need to know that your questions can be answered by a human and that your problems will be dealt in a swift manner. As part of this comparison I contacted all companies by their respective communication channels. I give high praise for those that answered to me quickly and on point.

###### But what about pricing or performance or X?

I did not compare the pricing options of the companies, because pricing is something that can easily change on the spot. Also it would be unfair for future readers (that read this post after a year) to see a comparison based on prices that might no longer be up-to-date.

All my projects are fairly simple. Due to time constraints I could not really focus on the performance/scalability of the CI services. If your project is really large (a monolithic application) then you might have a different view on which service is better.


#### My sample projects

For my tests I used 4 sample projects:

1. A public Github repo with a Maven Java project
1. The same repo with a Gradle build file
1. A private repo in Bitbucket (for companies that supported Bitbucket)
1. A public Github repo with a Clojure/Leiningen project (just to get something more exotic apart from Maven/Gradle)

#### Scoring method

For each area mentioned in the previous section I assign 5 points ( 1 = worst, 5 = best) with the following format:

* 0 = Product has serious issues in this area that may be showstoppers for some users
* 1 = Product has some issues but can still serve its purpose
* 2 = Product does exactly what I expected it to do (this is the base case)
* 3 = Product has some features in this area that are better than competitors
* 4 = Product is exceptional in this area going above and beyond the competition
* 5 = Product impressed me during the comparison for that particular area. 
The biggest mark (5 points) is reserved for very special cases where I was particularly happy with a product in that area.


#### My expectations

Now that you know my comparison criteria and my scoring system it is time to define the base case. The base case is an imaginary product that gets 2 out of 5 in all categories.

Initially I had planned a complex build scenario with unit/integration tests, deployment stages and even multi-step builds. However as my research continued I saw that due to time constraints I needed to focus on the basic scenario. My base case:

1. Fetches the code from Github
1. Compiles the code while giving me real time feedback on the build log
1. Archives my artifacts (i.e. war file)
1. Allows me to add post build steps (send an email, ftp something etc)
1. Has at least a reference guide for documentation
1. Is responsive via Twitter/Email or contact form

A product that does all the following would get 2 points in all categories. Here are more details on my expectations:

##### 1. Base case for connectivity

A product gets 2 points if it supports Github. Additional points are awarded if Bitbucket or other providers (such as Gitlab) are also supported.


##### 2. Base case for creating a new build

A product gets 2 points if it allows me to get to a successful build in a matter of minutes. There were products where the signup-to-green-build time was about 30 seconds and others where I did not even reach the point of having a successful build.

Some products also had auto-detection capabilities and could understand the build system of my project without any other extra configuration (such as .yml files). These got extra points. 

In general, I gave extra points to products that guided me in an understandable manner during the creation of a build job.

##### 3. Base case for the UX design

I know that it is hard to define what makes a good interface. I believe however that everybody can instantly recognize a bad interface that prevents you from accomplishing your task. 

A product gets 2 points if it has a dashboard that gives me an overview of all my builds and allows me to drill down into each specific build.

I award extra points when a product succeeds in making complex actions seem very simple, or when I see expertly designed UI screens.

##### 4. Base case for configuration 

A lot of products use yml file for configuration. This is not always the optimal solution but at least it allows you to define any kind of pre-build and post-build steps. I award 2 points to products that have Maven and Gradle preinstalled. 

I award more points if they have specific support for Java  projects (for example if they automatically cache my dependencies and allow me to easily change the JDK versions).

##### 5. Base case for Docker support

A product gets 2 points if it supports Docker. By that I mean it allows you to setup you own build environment
and bypass its default versions of build systems, compilers and other supporting utilities. 

Extra points are awarded for caching Docker images, providing a Docker repository and having the latest version of Docker.

##### 6. Base case for build feedback

Here I expect at least a log of the build. I award 2 points to products that offer a real-time build log.

Additional points go to products that offer ssh session on the build server or explicit support for JUnit reports (as Jenkins does)

##### 7. Base case for deployment steps

At the very minimum I should be able to call custom shell commands at the end of the build (e.g. sftp) to do something with my artifact. 

Extra points go for integrations with specific cloud providers (Amazon, Heroku etc)

##### 8. Base case for extra Enterprise features

At the very minimum the dashboard should support a big number of projects. Historical data for previous builds should be available.

Extra points go to products that offer an API, pipelines and other features that will be useful to big companies.

##### 9. Base case for documentation

I award 2 points to all products that have at least a reference guide that covers all features they support. Extra points go for tutorials, quick starts and FAQ pages.

##### 10. Ease of contact

It is very hard to put points on "communication" in a subjective way. Before I started my research I contacted all companies, told them about the report and asked for any feedback they have regarding their product strengths. 

During my actual testing I also twitted at twitter.com/codepipes some highlights (both good and bad) of each product. For some products I also used the official support channels they provide.

I give 2 points to companies who have a clear way of contact on their webpages and also answered my original email.

I award extra points to companies that also answered promptly to my tweets about them (all my tweets mentioned the official account of each product)

Companies are presented in alphabetical order.
So let’s begin!

* Buddy Works
* [CircleCI review]({% post_url 2016-04-24-circleci-review %})
* Codefresh review
* Codeship review
* DeployBot review
* Distelli review
* Drone.IO review
* SemaphoreApp review
* Shippable review
* SolanoLabs review
* Travis review
* Vexor review
* Wercker review
* Zeroci review














