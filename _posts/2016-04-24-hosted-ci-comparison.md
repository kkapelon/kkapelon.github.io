---
layout: post
title: Hosted CI comparison survey 2016
category: hosted-ci-2016
---

###Comparison of hosted Continuous Integration services

This page describes my comparison criteria. Feel free to go directly to a review below:

* [CircleCI review]({% post_url 2016-04-24-circleci-review %})
* Codeship review
* DeployBot review
* Distelli review
* Drone.IO review
* GreenhouseCI review
* SemaphoreApp review
* Shippable review
* SnapCI review
* SolanoLabs review
* Travis review
* Vexor review
* Wercker review
* Zeroci review



#####Building code in the cloud - the last missing piece

After the explosion of Github (where code is located offsite) and the rise of cloud computing (such as Amazon Web Services), the next logical thing to move to the cloud was the build system itself.

Continuous Integration (or Continuous delivery if you take it one step further) is the last missing link into a fully automated software creation process as it converts code into a product deliverable. With the code and the runtime already on the cloud, it would make sense to connect them together with a hosted build solution that would fetch the code and bring to production status.

Traditionally companies have their on premises build servers. Jenkins is one very popular solution (getting as much as 70% in the last ZT developer report) while Atlassian Bamboo is the second most used build server.

That changed quickly with the introduction of build servers that used the cloud. Travis is a well known solution, that became very popular in the open-source world. Travis is not however the only solution for building code remotely. A number of other vendors have appeared that offer the same (if not better) functionality with several pricing schemes for private and public repositories

In this post we will compare 14 hosted solutions that offer CI services. There are several comparison articles on the web but most of them only focus on 2 or 3 companies or are written in a biased way (often advertising a specific solution). I decided to write an impartial review (I am not affiliated with any of them) for your reading pleasure. Enjoy!

#####Comparison Criteria

Rather than writing a few sentences for each company or creating a big grid with features (these are loved by marketing folks but are not always useful to developers) I will instead provide my comparison criteria in a well structured manner. This way you can select that criteria that matter to YOU and decide on your own which is best according to your needs.

Because I am mainly a Java developer I have tested all of them with JVM projects. Here are those that I left out:

* [https://hosted-ci.com/](https://hosted-ci.com/) (Mac and IOS only)
* [http://www.appveyor.com](http://www.appveyor.com) (Windows only)
* [https://magnum-ci.com/](https://magnum-ci.com/) (Supports Ruby, Go, PHP,Python but not Java)

For the rest of the companies I compare the following areas:

######Connectivity

By connectivity I mean how easy it is to bring your code into the service. Even though Github is the most popular solution, not all projects use it. A product is getting high points on this area if it supports several ways of fetching the source code.

######First-time setup

Setting a build server can be a time-consuming process if your project is complicated. Getting a prototype project to work might be easy, but you are not done until the real project actually works, and the build artifact(s) are the same as your local setup (e.g. Jenkins). A product gets high points in this area if it guides me well through my first steps with it. There were cases where getting a to a successful build was a matter of seconds, and cases where I spent hours in order to understand what the service expected of me.


######User Interface

Getting a build running is only the beginning. If you have many projects on a CI system you also need a way to monitor and manage them. Here I looked at the “dashboard” of each solution, its organization of web pages, reports and navigation links and in general how user friendly the system is. I realize that a good UI can be subjective, so in most cases I emphasized bad points of User Experience (which are arguably easier to detect)

######Build environment

Perhaps the most important metric. This area includes the programming languages supported by the product (but as I said already I will focus on Java), the versions of compilers present, build systems and how easy it is to update or install new software. A product gets high points if it has extensive configuration properties and allows me to define the build environment in an intuitive way.

######Feedback

With the build in place, there are several things that can go wrong with it. Wrong environment setup, failed unit tests, unresponsive external services and so on. A product is getting high points in the this area if is allows real-time monitoring of the build, and excessive logging on things that went wrong. Some solutions even allowed for ssh connections to the build servers which is a really nice feature to have when the build does not do what you expected it.

###### Post-build steps/deployments

Assuming that the build is complete you need to do something with the results. Maybe deploy the artifact to a staging server, send an email, upload it to FTP, update a bug issue or anything that matches your process. A product is getting high points in this area if it offers several post-build hooks to allow you to take advantage of the build. 

###### Enterprise features

Getting a simple web project to build might be easy but not all projects are that simple (not all projects are web projects as well). Multi-module builds, pipelines, support for pull requests, and having a huge number of active projects with long build history are examined in this area. Products get high points if they cater to complex build processes. This is one of the area has has of lot of diversity as different companies have a different mindset on what exactly an “enterprise” wants.

###### Documentation

There is no such thing as too much documentation. Unfortunately not all companies embrace this idea. Giving access to quick tutorials is one thing, having a complete reference guide is another. Products get high points if they come with a detailed explanation of how they work and what they do.

###### Support

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

For each area mentioned in the previous section I assign 5 points (1=worst, 5 = best) with the following format

* 0 = Product has serious issues in this area that may be showstoppers for some users
* 1 = Product has some issues but can still serve its purpose
* 2 = Product does exactly what I expected it to do (this is the base case)
* 3 = Product has some features in this area that are better than competitors
* 4 = Product is exceptional in this area going above and beyond the competition
* 5 = Product impressed me during the comparison for that particular area
The biggest mark (5 points) is reserved for very special cases where I was particularly happy with a product in that area.


#### My expectations

Now that you know my comparison criteria and my scoring system it is time to define the base case. The base case is an imaginary product that gets 2 out of 5 in all categories.

Initially I had planned a complex build scenario with unit/integration tests, deployment stages and even multi-step builds. However as my research continued I saw that due to time constraints I needed to focus on the basic scenario. My base case:

1. Fetches the code from github
1. Compiles the code while giving me real time feedback on the build log
1. Archives my artifacts (i.e. war file)
1. Allows me to add post build steps (send an email, ftp something etc)
1. Has at least a reference guide for documentation
1. Is responsive via Twitter/Email or contact form

A product that does all the following would get 2 points in all categories. Here are more details on my expectations

##### Base case for connectivity

A product gets 2 points if it supports Github. Additional points are awarded if Bitbucket or other providers (such as Gitlab) are also supported.


##### Base case for creating a new build

A product gets 2 points if it allows me to get to a successful build in a matter of minutes. There were products where the signup-to-green-build time was about 30 seconds and others where I did not even reach the point of having a successful build.

Some products also had auto-detection capabilities and could understand the build system of my project without any other extra configuration (such as .yml files). These got extra points. 

In general, I gave extra points to products that guided me in an understandable manner during the creation of a build job.

##### Base case for the UX design

I know that it is hard to define what makes a good interface. I believe however that everybody can instantly recognize a bad interface that prevents you from accomplishing your task. 

A product gets 2 points if it has a dashboard that gives me an overview of all my builds and allows me to drill down into each specific build.

I award extra points when a product succeeds in making complex actions seem very simple, or when I see expertly designed UI screens.

##### Base case for configuration 

A lot of products use yml file for configuration. This is not always the optimal solution (more on this later) but at least it allows you to define any kind of pre-build and post-build steps. I award 2 points to products that have Maven and Gradle preinstalled. 

I award more points if they have specific support for Java  projects (for example if they automatically cache my dependencies and allow me to easily change the JDK versions).

##### Base case for build feedback

Here I expect at least a log of the build. I award 2 points to products that offer a real-time build log.

Additional points go to products that offer ssh session on the build server or explicit support for JUnit reports (as Jenkins does)

##### Base case for deployment steps

At the very minimum I should be able to call custom shell commands at the end of the build (e.g. sftp) to do something with my artifact. 

Extra points go for integrations with specific cloud providers (Amazon, Heroku etc)

##### Base case for extra Enterprise features

At the very minimum the dashboard should support a big number of projects. Historical data for previous builds should be available.

Extra points go to products that offer an API, pipelines and other features that will be useful to big companies.

##### Base case for documentation

I award 2 points to all products that have at least a reference guide that covers all features they support. Extra points go for tutorials, quick starts and FAQ pages.

##### Ease of contact

It is very hard to put points on “communication” in a subjective way. Before I started my research I contacted all companies, told them about the report and asked for any feeback they have regarding their product strengths. 

During my actual testing I also twitted at twitter.com/codepipes some highlights (both good and bad) of each product. For some products I also used the official support channels they provide.

I give 2 points to companies who have a clear way of contact on their webpages and also answered my original email.

I award extra points to companies that also answered promptly to my tweets about them (all my tweets mentioned the official account of each product)


#### Common pain points across CI services

With so many products to compare, I chose to focus on explicit Java support on the builds. Most of my issues had to do with the format of yml files and the lack of explicit support for Java (a lot of products assume that you are a Python or Ruby developer)

##### The cancer of YML files

Almost all products have a way to define your build in a yml file. I think that Travis was the first service that started this trend. Even though in theory the yml file is a good idea, in practice it gets complicated very fast for no special reason. It is a meta-build system that needs to be maintained along with the normal build files (e.g.)

I see the need for a yml file if I need to do something special in the build or if I want to define some environment parameter (e.g. a mysql service for unit tests), but frankly I don’t understand why it is required the basic compile step.

At least in the Java world there are not too many build systems. If my project contains a top level pom.xml file, there is a good chance that simply runningn mvn test will compile and test my code. So why do I need a yml files for this?

The syntax between yml files differs from service to service and not all of them had good documentation on the exact contents.

Going from the best solution to the worst the service can be roughly divided to the following categories

1. The service autodetects your build system and runs the appropriate command
1. The service allows to you to create a yml file with a gui wizard
1. The service requires a yml file but you can override via gui options
1. The service requires a yml file and fails the build if there is none

For some service I had to do a lot of commits to my repositories until the yml file would be complete for the build. I find this a total waste of time (not to mention that it clutters the repo history)

##### Lack of dependency caching

With Maven and Gradle your build will also download a lot of binary dependencies. Ideally these dependencies should be downloaded only once. 

However all services start a new build with a vm/container that has a clean state. This means that unless you do something about these dependencies, each build will download them again and again.

If you project is a big monolith, perhaps you don’t care about that because your build time might be dominated by the compilation phase rather than the fetching of dependencies.

But if you have a lot of small projects (perhaps you follow the latest micro-services craze) downloading all these dependencies can quickly become a problem. If you also employ the use of Gradle wrapper it also means that time is spent on downloading Gradle itself for each build.
It is therefore evident that a caching mechanism is needed. Some services have special documentation pages that explain how you can cache these dependencies. Some smarter services have built-in support for Maven and Gradle and automatically cache everything with no intervention from you

##### Lack of love for Java applications
My final pain point is the lack of sane defaults for Java applications. 

For example why do I have to configure a path for my JUnit reports? If I have told you that I use Maven, then the path to junit reports is known in advance.

Jenkins has some smart support for showing code coverage and unit tests result without any special configuration. I did not find any similar support to any CI service (and most of them advertise themselves as replacement of Jenkins)

#### Disclaimer

All my research happened during December 2015 - February 2016. By the time you read this, companies might have fixed things or added new features. If you read this report at a date later than 2018 I would advise you to consider it mostly obsolete and you should instead perform your own research on what CI solution is best for you.

Companies are presented in alphabetical order.
So let’s begin!

* [CircleCI review]({% post_url 2016-04-24-circleci-review %})
* Codeship review
* DeployBot review
* Distelli review
* Drone.IO review
* GreenhouseCI review
* SemaphoreApp review
* Shippable review
* SnapCI review
* SolanoLabs review
* Travis review
* Vexor review
* Wercker review
* Zeroci review














