---
layout: post
title: Comparison of Hosted Continuous Integration products
category: hosted-ci-comparison
---

| Version history | Changes       | 
| -------------   |:--------| 
| February 2019      | [JFrog](https://jfrog.com/)  buys [Shippable](#shippable) |
| January 2019      | [Idera](https://www.idera.com/)  buys [TravisCI](#travis) |
| February 2018      | [Cloudbees](https://www.cloudbees.com/)  buys [Codeship](#codeship) |
| September 2017      | [Puppet](https://puppet.com/)  buys [Distelli](#distelli) |
| July 2017      | [Codeship](#codeship)  redesigned their UI |
| April 2017      | Oracle buys [Wercker](#wercker)  |
| March 2017      | First version  |

### This article is very old now

Technology moves very fast. Most of the companies mentioned in the article have changed
their products in a significant manner. Please do not use this guide for major decisions.

I was going to update the guide, but since I now work for one of the companies (Codefresh)
it is a bit difficult to stay biased.


### A brief comparison of hosted Continuous Integration services

I was a happy user of [SnapCI](https://snap-ci.com/). I really liked the way pipelines worked and how easy was
to add a new project. SnapCI also had other nice features for Java developers like automatic caching
for both Maven and Gradle dependencies without any extra configuration.

![SnapCI dashboard](../../assets/ci-comparison/snapci-pipeline.png)

Unfortunately SnapCI was [discontinued in February 2017](https://blog.snap-ci.com/blog/2017/02/06/2017-02-06-snap-announcement/) so I have to yet again research all the available options.
This time I am sharing my discoveries so that I may save you some time.

Feel free also to read the [prequel](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/) of this survey first.


#### Hosted Continuous Integration products.

At the time of writing I am aware of the following companies that offer hosted CI services for Java projects.
If I miss anything [let me know](http://codepipes.com/contact.html).


* [Buddy](#buddy)
* [CircleCI](#circleci) 
* [Codefresh](#codefresh) 
* [Codeship](#codeship) 
* [DeployBot](#deploybot)
* [Distelli](#distelli) 
* [SemaphoreCI](#semaphoreci) 
* [Shippable](#shippable) 
* [SolanoLabs](#solanolabs) 
* [Travis](#travis) 
* [Vexor](#vexor) 
* [Wercker](#wercker) 

**TL;DR** Skip straight to [conclusion](#conclusion).


##### Comparison Criteria


Because I am mainly a Java developer I have tested all of them with JVM projects. Here are those that I left out:

* [NeverCode](https://nevercode.io/) (Android and iOS only - previously known as GreenhouseCI)
* [Bitrise](https://www.bitrise.io/) (Android and iOS only)
* [AppVeyor](http://www.appveyor.com) (Windows only)
* [AppHarbor](https://appharbor.com/) (.NET only)
* [MagnumCI](https://magnum-ci.com/) (Supports Ruby, Go, PHP, Python but not Java)

I also did not spend too much time with [Bitbucket pipelines](https://bitbucket.org/product/features/pipelines) as they are tied with Bitbucket (same with [Gitlab CI](https://about.gitlab.com/features/gitlab-ci-cd/))


#### My sample projects

For my tests I used 4 sample projects:

1. A [public Github repo](https://github.com/kkapelon/spring-mvc-wizard-sample) with a Maven Java project
1. The same repo with a Gradle build file
1. A private repo in Bitbucket (for companies that supported Bitbucket)
1. A public Github repo with a [Clojure/Leiningen project](https://github.com/kkapelon/clojure-http-server) (just to get something more exotic apart from Maven/Gradle)

Companies are presented in alphabetical order.
So let’s begin!

### Buddy

[Buddy](https://buddy.works/) (not to be confused with [Buddy](https://buddy.com/)) is a brand new CI company launched in 2015 and based in Poland. Unlike other CI products
they based their whole architecture on Docker right from the beginning.

Buddy supports both GitHub and Bitbucket. It is also the only product that supports Gitlab as well as its
own GIT platform. Buddy offers [one repository for free](https://buddy.works/guides/first-steps-with-git) which is perfect for demos and tutorials.

Adding my Bitbucket and GitHub projects was a trivial process. There isn't any form of build system autodetection but
this is not a big issue as Buddy provides a great UI experience for choosing your build steps and creating pipelines.

 ![BuddyWork actions](../../assets/ci-comparison/buddyworks/setup-environment.png)

 Each project can have many pipelines and each pipeline can have many actions. You choose the type of actions
 against an ever growing list of predefined ones. Under the hood you essentially select which Docker container
 will be attached to the filesystem of your checked-out repo during that build phase.

 Gradle and Maven actions are already there. Cache for Maven is already preconfigured. Adding cache for the Gradle action
 was as easy as adding a single line in the respective dialog.

 ![BuddyWork cache](../../assets/ci-comparison/buddyworks/gradle-cache.png)

 For each action you can also attach several services (perfect for running in-place integration tests).

 ![BuddyWork services](../../assets/ci-comparison/buddyworks/pipeline-setup.png)

 You can also choose your own docker image as your build environment so you are not really restricted by the actions
 already provided by Buddy.

 The killer feature of Buddy however is the way you can build pipelines. You pick pipeline actions from the GUI in a Lego-like function. You can drag-n-drop actions to change their order and also add extra on-failure actions.

![BuddyWork pipelines](../../assets/ci-comparison/buddyworks/pipeline-settings.png)

You can have multiple pipelines per project. If you prefer the configuration-as-code approach you can also
use an yml file if you want. This is completely optional (I am looking at you Travis and Shippable) and is equivalent
with the GUI actions.

The pipelines are constructed in the [true manner of continuous delivery](https://martinfowler.com/books/continuousDelivery.html). The workspace is preserved after each pipeline step so that your binary files are only compiled once in the beginning (instead
of being re-created each time).

The dashboard is very clean showing all your projects along with their latest status. You can organize
both projects and pipelines into folders/tags. This makes handling a big number of projects a very joyful experience.

![BuddyWork dashboard](../../assets/ci-comparison/buddyworks/dashboard.png)

Buddy allows you to view your workspace and download it as a zip file (exactly like Jenkins). Code files
are presented with syntax highlighting and you can even run git blame against them, making Buddy a lightweight
code viewing tool.

In summary, Buddy is a very well rounded solution. It has the easiest way of creating pipelines in a Lego-like manner
and the UX is unparalleled.

If you work at Buddy and are reading this, know that you have really nailed pipeline creation. As a finishing touch you could add auto-detection
of the build system (i.e. setup a Maven action automatically if a pom.xml file is found). Other than that,
I would recommend that you look at the name clash between Buddy and [Buddy](https://buddy.com/).

| Website    | [Buddy](https://buddy.works/) |
| Pricing    | [Details](https://buddy.works/#pricing) |
| Documentation    | Documentation covers the [basics](https://buddy.works/knowledge/deployments). It could really use more advanced examples of pipelines|
| User Interface| Nice animations and well thought UX. Could really use the full width of the screen  |
| Build configuration | You can use either UI or yml files to create pipelines. Very flexible Docker based build configuration |
| Docker support | Full support built-in. You can use Docker both as a build environment and as an artifact of your build|
| Extra features    |  [Team controls](https://buddy.works/knowledge/collaboration). [Code commit parsing](https://buddy.works/knowledge/deployments/how-use-commit-commands). [On premise version](https://buddy.works/buddy-go) |
| Disadvantages    | No auto-detection of build system|
| Killer feature    | Very flexible build environment. Lego-like creation of pipelines|
| **Final Verdict**    | I can highly recommended Buddy for both Gradle and Maven projects. The pipeline support is the ideal tool for both experienced (yml) and novice users (GUI actions) alike. |



### CircleCI

[CircleCI](https://circleci.com/) is an American company started in 2011. They have a very active web page (and [twitter account](https://twitter.com/circleci)) and a [blog](https://circleci.com/blog/) covering build related topics. Although they don’t advertise Java support that much, a lot of their blog posts are Clojure related. They support both Github and Bitbucket.

CircleCI has one of the ideal setup procedures. Of course it supports a [circle.yml](https://circleci.com/docs/configuration/) file but this is completely optional. Not only you can override this file, but you also get a nice GUI for this.

![CircleCI UI builder](../../assets/ci-comparison/circleci/circleci-ui-builder.png)

In addition to the GUI builder, it examines your repository and attempts to autodetect the type of build system you use.

I was amazed by the fact that it understood my Clojure project and run the correct command with zero configuration from my part:

![CircleCI repository autodetection](../../assets/ci-comparison/circleci/circleci-autodetect.png)

I was able to get a successful build in a matter of seconds.

The main problem with the environment is the fact that all phases are hardcoded. The phases are:

* machine: 
* checkout: 
* dependencies: 
* database: 
* compile:
* test: 
* deployment:

You can see instantly that this pattern is better for interpreted languages where fetching the dependencies and running unit tests are two completely different phases. 

In the Java world this is not the usual case. Both Gradle and Maven fetch their dependencies dynamically (i.e when they needed). For example Maven with fetch its surefire dependencies only when you actually run JUnit tests.

CircleCI is one of the few products that supports reporting of JUnit tests. Unfortunately they are not enabled by default which again is a pity because the presence of a pom.xml or build.gradle should implicitly enable that report as well.

![CircleCI test support](../../assets/ci-comparison/circleci/circleci-test.png)

Test reports can also be collected as as artifacts of the build giving you one-click access to them. CircleCI also supports [parallel testing](https://circleci.com/docs/parallel-manual-setup/). However,  I could not get this to work even though JUnit is one of the supported test runners.

The real highlight however, of CircleCI is the SSH support. You can ssh directly to the build machine. Your build will be paused and you are free to run any commands you want in order to debug a problematic build. The authentication method is with ssh keys (the same ones defined in Github)

![CircleCI ssh support ](../../assets/ci-comparison/circleci/circleci-ssh.png)



Working with CircleCI was a very pleasant experience. They have obviously looked at the needs of Java developers. Out of all  companies I have tried, they have possibly the best UI experience and some killer features such as SSH support and reporting of JUnit results.

If you work at CircleCI and are reading this, your product is almost perfect. You should improve the caching mechanism to allow the developer to decide when things are cached and restored (some other companies already do that). Also unit tests should be automatically shown (at least for Gradle and Maven builds) as the test results are always in known directories. 


| Website    | [CircleCI](https://circleci.com/) |
| Pricing    | [Details](https://circleci.com/pricing/) |
| Documentation    | Documentation in CircleCI [is very extensive](https://circleci.com/docs/). It contains guides specific to each language along with the reference information. |
| User Interface| Out of all the products, CircleCI has arguably the best user interface. It is very clean and very well thought.  |
| Build configuration | Great autodetection of build systems. Uses either a yml file or custom UI builder. |
| Docker support | [Basic support](https://circleci.com/docs/docker/) in the present version. Full support [in the next version](https://circleci.com/integrations/docker/).|
| Extra features    |  [Splitting](https://circleci.com/docs/parallelism/) of tests. Project [Insights](https://circleci.com/blog/announcing-circleci-per-project-insights/). Fully [REST API](https://circleci.com/docs/api/)|
| Disadvantages    | Build order is not ideal for Java projects. Caching is problematic for test dependencies. No support for pipelines.|
| Killer feature    | You can ssh directly into the build machine. Support for [JUnit reports](https://circleci.com/docs/test-metadata/). |
| **Final Verdict**    | Highly recommended for simple projects with no pipelines |

### Codefresh

[Codefresh](http://codefresh.io) is an American company located  in Mountain View and launched in 2014.

Like Distelli, Codefresh is much more than an hosted CI service. It supports both GitHub and Bitbucket and on the surface it appears
to be just another hosted CI service ([with Java support](https://docs.codefresh.io/docs/java)).  They even have a whole blog post about [migration from SnapCI](https://codefresh.io/blog/alternatives-to-snapci/). 

In reality however, Codefresh is a Docker Image Management platform. This is a very interesting idea and moves Codefresh
on a league on its own. Codefresh comes with some interesting features that no other product currently offers. 

You can create a Codefresh project in two modes:

![Codefresh builds](../../assets/ci-comparison/codefresh/choice.png)

If your project is really simple and uses an interpreted language (where the Docker image that contains the source code
is also the one deployed) then you can just use a Dockerfile as your "configuration file".

Once you have a Dockerfile, everything is very straightforward. You can create Docker images, monitor builds and even create compositions (a.k.a. Docker 
compose).

![Codefresh builds](../../assets/ci-comparison/codefresh/builds.png)

The more interesting approach however is to use a [yml file](https://docs.codefresh.io/docs/spring-mvc-jdbc-template). This works in a similar manner with Buddy and Wercker as you can define multiple steps that either run a script, run a command using a Docker image or create a Docker image. This capability can only be done with the yml file and no complimentary GUI is offered (unlike Buddy).

The killer features of Codefresh are that it allows you to view/manage the Docker images that you have created without
requiring an external Docker registry and it even offers test environments to launch your Docker images!

This is a very impressive feature as it allows you to easily demonstrate new features to your collegues (or customers)
without requiring any formal deployment environments. You can also use Docker compose on these test environment. I can see a lot of useful scenarios for this capability.

I had no trouble to run my Java application within a Docker image:

![Codefresh builds](../../assets/ci-comparison/codefresh/live-run.png)

 Coming back to the build environment, I could not see any support for defining a cache directory for Maven and/or Gradle. 
 Each build was downloading the full dependencies again and again. I finally found a workaround in [a blog post](https://codefresh.io/blog/caching-build-dependencies-codefresh-volumes/) (outside 
 of their official documentation), but it is not a proper solution as instead of defining multiple cache directories it requires 
 you to use a single reusable cache directory (and point Maven/Gradle to it).

 To sum up, Codefresh is indeed a fresh entry in the family of hosted CI service with some very interesting features no other competitor currently offers.
Lack of built-in cache support is the only thing that prevents me from fully recommending it as a build solution.

 If you work at Codefresh and you are reading this, I congratulate you for this new approach on fully embracing Docker.
 As far as I know you are the first company to create such a service that manages Docker image and even provides
 demo environments. You could further improve the caching configuration and at least in the case of Java
 implement built-in caching for the two main build systems.

 | Website    | [Codefresh](http://codefresh.io/) |
| Pricing    | [Details](http://codefresh.io/pricing/) |
| Documentation    | Very [basic](https://docs.codefresh.io/). Misses essential things like caching.  |
| User Interface | Clean and well designed  |
| Build configuration | A yml file is required or you use a Dockerfile for simple cases  |
| Docker support | Built-in. Actually the whole platform revolves around it|
| Extra features    | Support for Docker compose and running Docker images|
| Disadvantages    | yml is required for most cases. No built-in cache  |
| Killer feature    | The first and only platform that manages and launches Docker images|
| **Final Verdict**    | Both Maven and Gradle project could work ok with Codefresh but caching dependencies is not supported out of the box |

### Codeship

**Update February 2018**: Cloudbees [bought Codeship](https://blog.codeship.com/codeship-acquired-by-cloudbees/) so my review might soon be obsolete.

[Codeship](https://codeship.com/) is another American company from Boston. They have a vibrant web page filled
with guides and [blog posts](https://blog.codeship.com/) about CI topics. Codeship supports GitHub , Bitbucket and even Gitlab. You can authenticate with any of them and
add repositories right away.

First time setup is a bit troublesome. First of all there is absolutely no form of autodetection for
a build system. You are given all possible commands in the GUI and are expected to
uncomment the one that fits you. I don’t understand why it is that difficult to check the
existence of a Maven or Gradle file in the repo and act accordingly (at least as a starting point).


![Codeship no autodetection](../../assets/ci-comparison/codeship/codeship-no-autodetection.png)

Project setup is geared only towards dynamic languages (same problem as with [CircleCI](#circleci)). Codeship assumes that your build has two phases, downloading
of dependencies and running unit tests. Obviously this is not the way compiled languages like Java work (as both Maven and Gradle fetch their dependencies on demand)


However the thing that bothers me most with Codeship is that once you are finished with the
setup a build does NOT run at all. There is no build button!
You are expected to commit something and only then codeship will build your project.

![Codeship push first](../../assets/ci-comparison/codeship/you-must-push.png)

I am at a loss of words why this is required. I don’t think there is a technical reason 
because several other companies can perform a build without a commit.
My repository was already finished so I had to make a dummy commit in order to start the
build. Duh!
I forgive Codeship for the lack of autodetection of build system, but I find no excuses for the
lack of a "build Now" button.

The user interface of Codeship has a clean layout and shows all needed information. It also comes
with a very helpful dashboard that shows all your projects along with their latest build.

![Codeship dashboard](../../assets/ci-comparison/codeship/dashboard.png)

My experiments show that Maven dependencies are cached but Gradle ones [do not](https://documentation.codeship.com/basic/builds-and-configuration/dependency-cache/).
If you use Gradle Wrapper in your build you will even be forced to redownload
it for every
build that runs.

On the other hand Codeship build servers have preinstalled
all the popular build tools and
even some exotic ones (for Scala and Clojure).

The build log is very well designed and shows the result of all individual commands.

![Codeship log](../../assets/ci-comparison/codeship/codeship-build.png)


Like [CircleCI](#circleci), Codeship supports ssh access to the build servers but with an additional twist!
You ssh into a clone of the build machine while the build machine actually runs the next
build!
This means that you can debug a failed build at your leisure without blocking the build
queue.
From all products tested, only Codeship  and SemaphoreCI support this nonblocking
ssh. 
The keys used for the SSH access are unrelated with the Github ones. You create them
explicitly for debugging.

![Codeship push first](../../assets/ci-comparison/codeship/ssh.png)

There is no support for test results or build artifacts.
On the plus side Codeship:

* has explicit support for deployment pipelines where you define what happens
during deployment. 
* comes with [a REST API](https://documentation.codeship.com/basic/getting-started/api/)
* supports [Test Parallelism](https://documentation.codeship.com/basic/getting-started/parallelci/)

Documentation is quite extensive. In general I found it descriptive and up-to-date.

To sum up, Codeship is an imbalanced solution. On one hand it has the killer feature of nonblocking
ssh
debugging, but on the other hand the lack of a "build now" button really puzzles me. There is
caching support for Maven but not for Gradle. The fact that built-in Gradle is still at 
version 1.10 perhaps shows what Codeship thinks of supporting it. The technical product under the hood is a
solid one, but Java is a second class citizen and Gradle builds are not really viable.

Admittedly Codeship seems to be in a transition to their [Codeship Pro service](https://documentation.codeship.com/pro/getting-started/getting-started/), which is a Docker
based solution that comes with its own executable (called [Jet](https://documentation.codeship.com/pro/getting-started/installation/#what-is-jet)) that allows you to run your build locally. 
The idea is very interesting (and perhaps needs an article on its own) but as I have explained 
already [Docker is not that essential for Java apps](http://blog.codepipes.com/containers/docker-for-java-big-picture.html), so to me it seems like an overkill. You also
need a [special file](https://documentation.codeship.com/pro/getting-started/services/) that mimics the syntax of Docker compose and a [steps file](https://documentation.codeship.com/pro/getting-started/steps/) as well which to me sounds as vendor lock-in. I also could not find anywhere the source code of the Jet executable.

I really wanted to spend some time with Codeship Pro but  I stumbled again upon the "push to trigger your
first build" message and I did not want to add any more dummy commits to my projects just so that Codeship can pick the changes.

If you work at Codeship and are reading this, your product needs some design changes. You
should either support Gradle cache or even better make the cache mechanism configurable (like [Buddy](#buddy)). Not all Java projects use Maven. Add a _build now_
button to all screens
(this is a no brainer). Your ssh feature is killer and
you should advertise it more.

I have a feeling that Codeship is best for interpreted runtimes (Python, Ruby etc) so maybe Java is not
getting the attention it deserves from the company.


| Website    | [Codeship](https://codeship.com/) |
| Pricing    | [Details](https://codeship.com/pricing) |
| Documentation    | Good but [nothing impressive here](https://documentation.codeship.com/) |
| User Interface | Clean and well designed  |
| Build configuration | No project autodetection. Anciend Gradle version. No compilation phase |
| Docker support | None in the basic version. Full Docker support (and more) in the pro version|
| Extra features    | [Rest API](https://documentation.codeship.com/basic/getting-started/api/), Deployment pipelines, test parallelism, [Roles](https://documentation.codeship.com/general/account/organizations/)|
| Disadvantages    | No Gradle cache, needs a push to start the first build (!!!)  |
| Killer feature    | You can ssh to a clone of your environment. The Jet local build process  in Codeship Pro.|
| **Final Verdict**    | Codeship might be ok for a small number of Maven projects. If you use Gradle then don't even bother. |

### Deploybot

Deploybot is an American company located in Philadelphia. The parent company is [Wildbit](http://wildbit.com/).

Oh! The memories! I spent about 2 days to get a build running. I thought about giving up
several times (with other products I could get a build in seconds) but I was curious on how a
Java build might work with Deploybot.

Long story short, the product is aimed more at websites in PHP, Python and Ruby. Compiling code
is something extra-ordinatory and can only by configured as a "custom deployment script".

![Deploybot compilation](../../assets/ci-comparison/deploybot/build-deployment.png)

Calling the UI of Deploybot confusing would be an understatement. It is a typical "design by
committee" UI where each screen was probably designed by a different person.
The navigation happens via 3 top level tabs, a lot of buttons and a lot of links that look like
buttons. Sometimes the GUI contradicts itself using wrong instructions.

![Deploybot missing button](../../assets/ci-comparison/deploybot/contradicting-marked.png)

The 3 tab layout is very confusing on its own. I had to click around a lot to find what I
wanted. I think this screenshot embodies the spirit of the bad UI (3 levels of settings):

![Deploybot settings](../../assets/ci-comparison/deploybot/confusing-settings-marked.png)

In summary the UI is a mess. 
I did not really test the build environment in detail because most of my time was spent on getting that
first build to run in the first place.
I noticed that there is no built-in
support for Maven/Gradle and moved on.

Deploybot has integrations for popular cloud providers like Digital Ocean, Heroku, AWS etc.
Of course it is still a mystery to me how you can use them after your build runs, (as the build
server is another deployment option itself).

I have to say that despite the shortcomings of the product, their support was responsive,
knowledgeable and really helpful. 

Deploybot might be a good service for developers of interpreted languages where the source
files go straight to the deployment server. But for Java developers where only binaries are
deployed, the experience is awful (the UI is awful for everybody of course). You can safely
scratch it off from your evaluation list and look at all the other options presented in this report.


If you work at Deploybot and are reading this, know that your UI needs a lot of improvements. You need to hire a professional UX
designer and recreate the whole interface from scratch. That being said, your support staff is
excellent.

**Final Verdict:** Avoid Deploybot. The product is clearly aimed at Python/Ruby developers and the UI is
very confusing.



### Distelli

[Distelli](https://www.distelli.com/) is a American company launched in 2013 and based in Seattle.

**Update September 2017**: Puppet [bought Distelli](https://puppet.com/blog/welcome-distelli-to-puppet-family) so my review might soon be obsolete.

They have a very active web page with [blogs posts](http://www.blog.distelli.com/) covering several topics regarding
containers, pipelines and Kubernetes deployments.

Calling Distelli a hosted CI service would be an understatement. It is a complete one-shop solution
for the whole deployment process. It has

* support of declaring your environments and deployments (like [GoCD](https://www.gocd.io/))
* a graphical [pipeline builder](http://www.blog.distelli.com/single-post/2015/11/10/Introducing-Pipelines-Mission-Control-for-DevOps)
* support for its own [Docker repository](https://www.distelli.com/docs/europa)
* support for adding your local data center as a build server
* support for adding your local data center as a deployment target
* a complete dashboard for managing [Kubernetes clusters](http://www.blog.distelli.com/single-post/2016/12/14/Continuous-Containers-on-Kubernetes) 

While other CI services stop at the deployment phase, Distelli can also help you monitor your environments
and finally answer the age-old question "what version of application X is deployed on environment Y".

I didn't have time to evaluate everything that Distelli offers and focused on the CI part mainly. The Kubernetes
support probably deserves an article on its own.

Adding my sample projects was a very easy process. There is no support for build-system autodetection but Distelli
will propose templates for popular languages (including Java).

![Distelli Java](../../assets/ci-comparison/distelli/configuration.png)

Once all my projects were imported I could build them right away. Distelli supports either a yml file or a GUI
for defining custom commands. The documentation on the yml file is [very extensive](https://www.distelli.com/docs/manifest/distelli-manifest) (take notes Wercker).

![Distelli dashboard](../../assets/ci-comparison/distelli/dashboard.png)

The next feature I evaluated were environments and pipelines. Distelli comes with one of the most
beautiful way of creating pipelines. There is a detailed GUI to create environments, assign servers
to them and define all the build steps of any complex process you can imagine.

![Distelli pipeline](../../assets/ci-comparison/distelli/pipelines.png)

The beauty however is that Distelli takes a holistic approach to software deployments, allowing you to define
application dependencies, define environments and their respective servers and in effect model your
whole runtime environment using a friendly UI. This gives you a much better overview of builds. Apart
of the general build status you also get a report on where/when that particular build was deployed.

![Distelli overview](../../assets/ci-comparison/distelli/overview.png)

The icing of the cake is that Distelli offers a [build agent](https://www.distelli.com/docs/agent/distelli-agent) which has a combo role. It can act either
as a local build server (allowing you to monitor local capacity in the Distelli UI) or as an agent
to be installed for a target deployment server. Very impressive indeed!

I had no problem to download and install the agent, adding my laptop as a deployment target.

![Distelli local server](../../assets/ci-comparison/distelli/my-local-environments.png)

At this point in time I thought I had found the perfect CI platform. The hybrid build agent, the flexible pipeline GUI and the Kubernetes
dashboard are unique features of Distelli, pushing it well ahead of all its competitors.

But I was quickly discouraged from recommending Distelli as I noticed that both my Maven and Gradle projects did
not cache their dependencies. They were re-downloaded every time again and again for each build. Unfortunately
Distelli does not support (!!!) caching directories at the time of writing. 

I don't understand how such an important feature is missing from an otherwise impeccable service. Lack of cache configuration
is a big omission and prevents me from wholeheartedly recommending Distelli as the ultimate building solution. Sad but true.

I contacted Distelli about this show-stopper issue and they informed me that the hosted build servers indeed do not support this. This is why they offer the capability to handle local build servers (where obviously I have complete control).

I will keep a close eye on Distelli because in the future it might become the king of CI products. 

| Website    | [Distelli](https://www.distelli.com/) |
| Pricing    | [Details](https://www.distelli.com/pricing) |
| Documentation    | Probably the [most comprehensive](https://www.distelli.com/docs) I have ever seen |
| User Interface | Very well thought interface. Pipeline GUI is jaw-dropping|
| Build configuration | A yml can be used or build steps can be created in place|
| Docker support | Built-in|
| Extra features    | [Pipelines](https://www.distelli.com/docs/kb/introduction-to-dashboards), [API](https://www.distelli.com/docs/api/getting-started-with-distelli-api) , [Local build client](https://www.distelli.com/docs/agent/installing-the-distelli-cli), [Kubernetes support](https://distelli.engineering/kubernetes-ci-cd-with-docker-and-node-2ac29cf48b2b#.h50iv82sq) and more|
| Disadvantages    | No configurable cache for either Maven or Gradle |
| Killer feature    | An one-stop-shop for your deployment pipelines |
| **Final Verdict**    | Distelli is very impressive but until it gains cache support I cannot really recommend it for Java projects (unless you only use local build servers).|


### SemaphoreCI

*Disclaimer:* I have written [testing](https://semaphoreci.com/community/tutorials/testing-rest-endpoints-using-rest-assured) [tutorials](https://semaphoreci.com/community/tutorials/how-to-split-junit-tests-in-a-continuous-integration-environment) and a [blog post](http://blog.codepipes.com/containers/go-docker-semaphoreci-gcloud-tutorial.html) for SemaphoreCI, but I have no special
affiliation with them.

[SemaphoreCI](https://semaphoreci.com/) is the product of a company called [RenderedText](http://renderedtext.com/) which is located in Serbia. They have a very active site with [a large collection
of tutorials](https://semaphoreci.com/community/tutorials) on various topics related to CI including [TDD](https://en.wikipedia.org/wiki/Test-driven_development) and Docker.

I had a feeling that my experience with SemaphoreCI would be a positive one, right from the configuration step. They fully support autodetection of Java build systems, and I was really impressed when my Clojure project was handled correctly with zero-configuration on my part:

![Semaphore autodetection](../../assets/ci-comparison/semaphore/lein-autodetect.png)

They also closely follow Gradle as they had the latest version (3.3 at the time of writing) installed in the build slave.
Caching for both Maven and Gradle is enabled by default, but unfortunately cache is only created during the "setup" phase
so as with CircleCI you might miss caching for some testing libraries.

Overall the UI of SemaphoreCI is very stream-lined and well thought. They have a Jenkins-like dashboard that gathers
all projects along with their latest build.

![Semaphore dashboard](../../assets/ci-comparison/semaphore/dashboard.png)

It is very easy to setup deployments for common providers (e.g. Heroku, AWS) or you can write your own scripts
for anything custom:

![Semaphore deployments](../../assets/ci-comparison/semaphore/pipeline.png)

As with CircleCI, SemaphoreCI allows you to SSH into your build slave for debugging purposes. If you are paying for more than one boxes you can also SSH to the build slave, while the next build is already running (like Codeship). The keys used for the SSH access are unrelated with the Github ones. You create them
explicitly for debugging.

![Semaphore deployments](../../assets/ci-comparison/semaphore/ssh.png)

Finally, Docker is pre-installed in the build slaves (as an option) with the latest version. It doesn't
get any easier than this to obtain docker support for your builds.

In general SemaphoreCI is a good all around solution. It does everything right and works just like you would expect. 
If Gradle cache support was activated by default I would recommend it without any hesitation.


| Website    | [SemaphoreCI](https://semaphoreci.com/) |
| Pricing    | [Details](https://semaphoreci.com/pricing) |
| Documentation    | Good but sometimes it feels geared towards Ruby and [lacks some Java topics](https://semaphoreci.com/docs/) |
| User Interface | Very well thought interface. Could be improved by making use of the whole screen space in big screens.|
| Build configuration | Impressive project autodetection. Very easy to add build steps.|
| Docker support | Built-in|
| Extra features    | [Insights](https://semaphoreci.com/blog/2015/11/20/semaphore-insights.html), Deployment pipelines, [test parallelism](https://semaphoreci.com/docs/running-tests-in-parallel.html), [API](https://semaphoreci.com/docs/api.html), [Team controls](https://semaphoreci.com/docs/organizations/creating-a-team.html)|
| Disadvantages    | Cache needs some tuning. Lack of advanced pipelines |
| Killer feature    | You can ssh to build servers. Excellent autodetection of build systems|
| **Final Verdict**    | I can recommend SemaphoreCI for both Maven and Gradle projects |


### Shippable

**Update February 2019**: JFrog [bought Shippable](https://jfrog.com/blog/weve-acquired-shippable-to-complete-devops-pipeline-automation-from-code-to-production/) so my review might soon be obsolete.

[Shippable](https://app.shippable.com/) is an American company based in Seattle. They also have a [content-rich blog](http://blog.shippable.com/) with topics such
as microservices, Docker, Continuous delivery etc.

Shippable does not support any kind of autodetection of your project. In fact it will just refuse to
run if you don't have a custom configuration file in your project. I have already written [why
I consider this a bad practice](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/). This file should be optional (see CircleCI and Buddy for examples).

![Shippable error](../../assets/ci-comparison/shippable/yml-required.png)

In order to play along I had to make several commits into my repository until [my configuration](http://docs.shippable.com/ci/shippableyml/) was correct.
This was a very time-consuming process because there is no way of knowing if Shippable will accept your yml file before
hand. You need to commit each of your changes and make a build. Naturally, my repository was now full or trivial commits
with minor adjustments. Sad but true.

Shippable has a very nice UI, but unfortunately I could never enjoy it. It always became unresponsive as soon
as I tried to click the log or check the build status.

After a while it stopped being funny. At first I thought that maybe they did some kind of maintenance that day
and tried another one. Same thing happening again and again.

![Shippable error](../../assets/ci-comparison/shippable/unresponsive1.png)

Coupled with the fact that I had to make multiple commits for the yml file, using Shippable became quickly a 
painful process.

![Shippable error](../../assets/ci-comparison/shippable/unresponsive2.png)

Apart from the freezing of UI, the builds themselves were very slow. With my example projects,
most other products could finish a build in less than a minute. With Shippable however it took a full 2 minutes
just to start the build slave.

![Shippable performance](../../assets/ci-comparison/shippable/bad-performance.png)


It is really a shame because I noticed many interesting features. For example Shippable
supports test results and even code coverage.

![Shippable error](../../assets/ci-comparison/shippable/test-results.png)

These are not supported out of the box. They need to be configured in the yml file.

![Shippable error](../../assets/ci-comparison/shippable/test-coverage.png)

I also saw that they have support for pipelines, but at the point in time I had already spent enough
time reloading my pages, restarting my browser and in general trying to fight the unresponsiveness of the whole system.

Neither Maven nor Gradle cache is supported. I tried to set it up on the yml file and it did not seem to work.
Documentation was listing [this as a breaking change](http://blog.shippable.com/shippable-3.0-breaking-changes) so maybe
some more research was needed (but other products at least support Maven right away).

Like Codeship, Shippable is an imbalanced product. The UI is great, the features are there, but the performance is abysmal.


| Website    | [Shippable](https://app.shippable.com/) |
| Pricing    | [Details](https://app.shippable.com/pricing.html) |
| Documentation    | Good but [needs some more Java love](http://docs.shippable.com/ci/shippableyml/) |
| User Interface | Very well designed. But pages are unresponsive. |
| Build configuration | No project autodetection. Does not work without a yml file|
| Docker support | Yes, but did not try it|
| Extra features    | Test coverage, Test reports, Build pipelines|
| Disadvantages    | No cache for Maven or Gradle. UI is unusable. The yml file is very complex |
| Killer feature    | Test coverage for your tests ([Jacoco](http://www.eclemma.org/jacoco/))|
| **Final Verdict**    | I cannot recommend Shippable until the performance problems are fixed. The yml file should become optional like CircleCI/Buddy. Cache should be enabled at least for Maven. |

### SolanoLabs

[SolanoLabs](https://www.solanolabs.com) (previously known as Tddium ) is an American company founded in 2011 with offices in Boston and San Fransisco. They 
have a very "enterprisy" [page](https://www.solanolabs.com/services) and a [blog](http://blog.solanolabs.com/)  
that seems to be filled with press releases mostly, instead of actual engineering content.

The service supports Git repositories from Github only. You can also use
local GIT repos via the Solano CLI. This is a very useful feature for companies that do not host their code in public clouds.

Creating a new project is a very easy process.
As with Travis, SolanoLabs has this bad habit of requiring a yml configuration file and will refuse to run without one.

![Solano yml required](../../assets/ci-comparison/solano/yml-required.png)

Unlike Wercker however, SolanoLabs has excellent documentation on the contents of the yml, so it was very easy to create
one and get a successful build right away.

![Solano build](../../assets/ci-comparison/solano/build.png)

Cache support is very flexible as you can define any directory to be cached. There is explicit documentation for both
[Gradle and Maven](http://docs.solanolabs.com/ConfiguringLanguage/java/) cache so adding the respective line in the yml file was straightforward.

When a build fails, you can easily connect to the build slave using SSH. The keys are completely different
than the ones you have in GitHub. By default you get 30 minutes of connection time and you can easily extend them.

 ![Solano ssh](../../assets/ci-comparison/solano/ssh.png)

 In general SolanoCI is a well balanced solution. My only complaint with the service would be the UI sizing. Some of the fonts are really small for no particular reason.
 The main buttons and important details are ok, but I think that some UX changes would certainly be welcome.

 ![Solano ssh](../../assets/ci-comparison/solano/small-ui.png)

 Overall I was very happy with SolanoLabs. It works as it should and judging by its documentation it seems to offer
 anything you might need. Some features are by request (e.g. Docker) and Pipelines are still in Beta so this could
 be a disadvantage if you need to use them. I did not try Pipelines but they seem to be defined in the YML file
 so if you prefer a graphical way you should look at Distelli or Buddy.

| Website    | [SolanoLabs](https://www.solanolabs.com) |
| Pricing    | [Details](https://www.solanolabs.com/#pricing) |
| Documentation    | Very [comprehensive](http://docs.solanolabs.com/). Explicit support for Java |
| User Interface | Needs bigger fonts in some places. Could use the full width in bigger screens. |
| Build configuration | Everything happens via a yml file. Configurable Cache. |
| Docker support | Yes but you need to [request it first](http://docs.solanolabs.com/Setup/docker/).|
| Extra features    | Parallel tests, [Command line client](https://github.com/solanolabs/solano), [SSH support](http://docs.solanolabs.com/AccountManagement/ssh-configuration/), [Pipelines](http://docs.solanolabs.com/Beta/build-pipelines/) (in beta), Test results|
| Disadvantages    | No language autodetection. Configuration file is required. |
| Killer feature    | Very flexible configuration. Feature rich for enterprise projects|
| **Final Verdict**    | I can recommend SolanoCI for both Maven and Gradle projects.  Especially for large and complex code-bases SolanoCI seem to offer everything you might need|

### Travis

**Update January 2019**: Idera [bought TravisCI](https://blog.travis-ci.com/2019-01-23-travis-ci-joins-idera-inc) so my review might soon be obsolete.

[Travis](https://travis-ci.org/) is the service that has become synonymous with hosted CI. It is also the service
that started [this annoying trend](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/) of requiring yml files for a build.

Travis supports Github but not Bitbucket. Adding a new repository is very easy and painless. 

There is no form of language auto-detection.
What is puzzling to me is that even though Travis makes it clear that it requires a yml file, it will continue
the build if it doesn't find one and assume that it is a Ruby one!

![Travis likes ruby](../../assets/ci-comparison/travis/default-ruby.png)

Oh well... On the plus side Travis allows you to validate your yml file either online or via a [Command line client](https://github.com/travis-ci/travis.rb#readme) (requires Ruby) so at least I didn't have to spend that many trivial commits to make it right.

![Travis cli](../../assets/ci-comparison/travis/travis-cli.png)

The command line application has also access to the Travis API and allows you to manage your builds via your terminal.
A very handy feature indeed.

Given the power of the Travis CLI, it is no surprise that the Travis web interface is very simple and to the point.
Unfortunately the UX is not perfect. While in theory you get a list of your projects with the latest build status (which
is what a proper dashboard should contain) the Travis dashboard seems out of sync.

![Travis cli](../../assets/ci-comparison/travis/dashboard.png)

In the picture above,  for the first project Travis cannot really decide if the build has failed or not. For the second project,
even though the latest build is successful (not shown in the picture), Travis shows a failed build from 5 days ago.

All configuration happens via the Travis YML file which is very powerful and has everything you would possibly need
for. [Caching](https://docs.travis-ci.com/user/caching/) has first class support in Travis and you can configure easily multiple directories (Maven and Gradle in my case).

A nice UI touch is the fact that you can monitor your cache size in the UI:

![Travis cache](../../assets/ci-comparison/travis/travis-cache.png)

Both Gradle and Maven are pre-installed in build slaves so Java support is excellent. Gradle is still in the 2.x version
but this is not problem if you use [Gradle wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html).

Docker support is not available by default, but you need to configure it (again in the yml file) so that the build slave
is Docker enabled.

In general my experience with Travis was a positive one. My only big complain would be the lack of explicit
pipelines.
Travis has obviously the first mover advantage in the hosted CI market. It is an adequate solution
and works as you would expect. I feel however,  that the competition not only caught up with Travis
but is now surpassing it. 


| Website    | [Travis](https://travis-ci.org/) |
| Pricing    | [Details](https://travis-ci.com/plans) |
| Documentation    | Very good and [very extensive](https://docs.travis-ci.com/). Most languages have a dedicated guide. |
| User Interface | Truly Spartan but functional. A bit confusing regarding the build status.  |
| Build configuration | Everything happens via a yml file. Configurable Cache.|
| Docker support | Yes but you need to [declare it first](https://docs.travis-ci.com/user/docker/).|
| Extra features    | [Parallel tests](https://docs.travis-ci.com/user/speeding-up-the-build/). [Command line client](https://github.com/travis-ci/travis.rb#readme). [Deployments](https://docs.travis-ci.com/user/deployment/) for popular services. [Other UIs](https://docs.travis-ci.com/user/apps/)|
| Disadvantages    | No language autodetection. Configuration file is required.  |
| Killer feature    | Well known, Battle tested, very configurable.|
| **Final Verdict**    | I can recommend Travis for both Maven and Gradle projects. It works ok, but if you want features like pipelines or a ssh session to the build, its competitors are already ahead. |


### Vexor

[Vexor](https://vexor.io/) is a Russian company launched in 2011 and located in Moscow. The parent company is [Evrone](https://evrone.com/). Their website is very spartan and their blog contains exactly one post about the product itself.

Vexor supports both GitHub and Bitbucket and it was very easy to build projects from both types or repositories.

The first surprise came from the autodetection dialog. They can detect Scala and Clojure but not Java!!!

![Vexor autodetect](../../assets/ci-comparison/vexor/auto-detect.png)

My Clojure project was built right way, but my Java one needed special customization. Vexor supports
a yml file with the same syntax as Travis. The good thing however is that it also offers a simple GUI that allows
you to define your yml via the web interface so that you don't litter your repo with extra files (I am looking
at you Shippable and Wercker).

I made the configuration change and was also able to add cache support for both Gradle and Maven. Awesome!
Latest Maven version (3.x ) is pre-installed. For Gradle you can use the Gradle wrapper.
The latest version of Docker is also available in the build slaves.

Vexor was clearly created by a web development company that knows a thing or two about UX. The UI feels very fluid,
had very nice animations and is a joy to navigate. CircleCI might have the most functional GUI, but Vexor has
the most beautiful one.

![Vexor dashboard](../../assets/ci-comparison/vexor/dashboard.png)

A minor problem with configuration is that even though you can get a build on master straight away, if you want
to build another branch, you need to make a commit there so that Vexor can pick it up.

Vexor also supports SSHing into the build slave, but there is a catch. SSH access is only available while the slave
is running. If your build finishes too fast you are out of luck. So the trick is to add some sleep statements
in you build script. 

![Vexor ssh session](../../assets/ci-comparison/vexor/ssh-in.png)

I did not know about this trick and their documentation is not helping me either:

![Vexor documentation](../../assets/ci-comparison/vexor/documentation.png)

Unfortunately this also means that the time you spent debugging your build also counts against your billing. So
make sure you are aware of this before starting your SSH session.

On the bright side they have very good live support. The embedded chat window had always an actual person
that was ready to answer my questions (with some English language errors but still on point).

In general Vexor is a spartan solution that works very well for small projects. If you want extra features
such as deployment pipelines, team permissions, test coverage etc. you have to look elsewhere. It would be
the ideal solution for teaching or demonstrating basic CI concepts. 

If you work on Vexor and read this, you need to restructure your documentation. You also need to add documentation/autodetection for Java (since you support Scala and Clojure already). 
Other than that the product
does exactly what it says on the box.

| Website    | [Vexor](https://vexor.io/) |
| Pricing    | [Details](https://vexor.io/#pricing) |
| Documentation    | Not good. Still  [has missing sections](https://vexor.io/help/). Java is not even mentioned. |
| User Interface | Minimalistic and clean. Very nice animations. |
| Build configuration | Supports Travis syntax. Can work without a yml file straight from the Web UI. Configurable Cache.|
| Docker support | Yes (built-in) |
| Extra features    | Ssh into your build slave if it takes too long. Parallel tests.|
| Disadvantages    | Documentation is lacking. |
| Killer feature    | Simple and to the point.|
| **Final Verdict**    | I can highly recommend Vexor for both Maven and Gradle projects. People who are new to CI/CD will especially find Vexor easy to understand and use. For some advanced usages (e.g. pipelines) you may need to look for another product. |


### Wercker



[Wercker](http://www.wercker.com/) is a company launched in 2012 with offices in San Francisco, London and Amsterdam.
They have a very active web page with [blogs posts](http://blog.wercker.com/) covering apart from CI, topics such as deployments and Kubernetes.

**Update April 2017**: Oracle [bought Wercker](https://www.oracle.com/corporate/acquisitions/wercker/index.html) so my review might soon be obsolete.

Wercker supports both GitHub and Bitbucket. It is very easy to import your repositories.

Wercker has been inspired (in a bad way) by Travis and Shippable and will refuse to run if it doesn't find a yml file
with settings.

![Wercker yml is required](../../assets/ci-comparison/wercker/yml-required.png)

There is no way to define the settings from the GUI, so my only choice was to add a yml file to my repo. Unfortunately
the documentation on the exact format expected is not very clear. In particular, the [Wercker documentation](http://devcenter.wercker.com/docs/wercker-yml/creating-a-yml) is very light on the subject and does not include a reference page
that describes everything that can go into the yml file. The problem is further exacerbated by the fact that Wercker is very
picky when it comes to the format of the yml file.

I managed to get a build running with Maven, but couldn't get a Gradle build to work correctly. The cache on my Maven build worked out of the box without any configuration.

![Wercker dashboard](../../assets/ci-comparison/wercker/dashboard.png)

On the plus side, Wercker provides a [command line client](http://www.wercker.com/wercker-cli) that not only can check your config file, but even runs
the build locally (using Docker). The CLI is available only for Linux and MacOSX. The CLI is open-source
and [available on GitHub](https://github.com/wercker/wercker) (unlike Codeship Pro). A very nice feature indeed.

Wercker also supports pipelines but in strange way. You have to define them in the yml file and then connect
them in the UI.

![Wercker pipelines](../../assets/ci-comparison/wercker/pipeline.png)

Overall I tried to like Wercker but I am really tired of [battling with yml files](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/).
It feels like a solid product, but the competition is much better in regards to configuration.

Also notice that Wercker does **NOT** support running Docker commands as part of your build
and this is [actually](http://devcenter.wercker.com/docs/faq/can-i-build-dockerfiles)  by [design](http://devcenter.wercker.com/docs/faq/can-i-run-docker-commands). 

If you work at Wercker and read this, please see how easy configuration can be done with other services (e.g. CircleCI and/or Buddy).


| Website    | [Wercker](http://www.wercker.com/) |
| Pricing    | [Details](http://www.wercker.com/pricing) |
| Documentation    | Very [basic](http://devcenter.wercker.com/docs/home). Configuration options lack documentation.  |
| User Interface | Clean and well designed  |
| Build configuration | Very complex yml format with insufficient documentation. Does not work without it.  |
| Docker support | No and seems that [it will stay that way](http://devcenter.wercker.com/docs/faq/can-i-run-docker-commands).|
| Extra features    | A [CLI](http://devcenter.wercker.com/docs/cli) for local builds. [Team control](http://devcenter.wercker.com/docs/organizations/people-and-teams). An [API](http://devcenter.wercker.com/docs/api). [Pipelines](http://devcenter.wercker.com/docs/pipelines)|
| Disadvantages    | Requires a yml file with picky format and unclear documentation  |
| Killer feature    | Open source CLI that builds locally|
| **Final Verdict**    | While Wercker could work ok for Java projects, I do not truly recommend it as there are several other products with much easier configuration (e.g. Buddy and CircleCI). |

### Conclusion

After all is said and done here is the comparison chart you have been waiting for.

| Company                          | Clean UI       | Configuration | Cache | Docker support| Pipelines | Local builds | SSH | Recommended |
| -------------                    |:--------|  ------ |  ------ | ------ |------  | ------ | ------ |------ |
| [Buddy](#buddy)       | Yes     |yml/GUI | Yes | Yes|  Yes | No |  No| Yes|
| [CircleCI](#circleci)            | Yes  |yml/GUI | Partial| Partial | No | No | Yes | Yes|
| [Codefresh](#codefresh)          | Yes  |yml/dockerfile | No  | Yes  | No | Yes (Docker)  | No | Maybe |
| [Codeship](#codeship)            | Yes | yml/GUI | Partial | Pending | No | Pending | Yes  | Maybe |
| [DeployBot](#deploybot)          | No!  | awful | No | - | -  |-  | -  | Hell No |
| [Distelli](#distelli)            | Yes  | yml/GUI | No | Yes | Yes | No | No | No |
| [SemaphoreCI](#semaphoreci)    | Yes   | GUI | Partial | Yes  | No | No  | Yes | Yes|
| [Shippable](#shippable)          | Yes  | yml only| No | Yes | No | No | No | No|
| [SolanoLabs](#solanolabs)        | Yes  |yml only| Yes | Yes | Pending | No | Yes | Yes |
| [Travis](#travis)                | No  |yml only | Yes | Yes  | No  | No  | No | Yes |
| [Vexor](#vexor)                  | Yes   |yml/GUI | Yes| Yes| No | No | Yes| Yes| 
| [Wercker](#wercker)              | Yes  | yml only| Yes | No | Yes| Yes| No | Maybe |

Not shown in this table are some unique features to Distelli ([Local agent](https://www.distelli.com/docs/kb/using-your-own-build-server), [Kubernetes Dashboard](https://www.distelli.com/docs/k8s/create-project)) and CodeFresh ([launching Docker images](https://docs.codefresh.io/docs/test-your-feature)) so keep that in mind as well.

Some explanations regarding the values and features:

#### Clean UI

By this I mean how easy it was to navigate the UI and perform my tasks. This is a bit subjective so you might
want to read the details in the respective section for each service. Deploybot has a horrendous UI and needs a complete
redesign. Codeship and Travis had some minor problems.


#### Configuration

I have [already described](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/) why requiring yml files is a bad practice. 

At the simplest case each service should allow you to define a simple build just from the UI. A yml file should be optional.
Shippable, Travis, SolanoLabs and Wercker are particularly bad examples of requiring a yml file before a build can even start. Organizations
that have a lot of Micro-services will find it very consuming to commit a yml file to each repository right at the beginning
(especially when the format of the yml file is a result of trial and error).

The only products that could autodetect my build system and offer suggestions for the build commands were
CircleCI, SemaphoreCI and Vexor.

#### Cache

Maven and Gradle artifacts should be cached after each build. If you have embraced the Micro-services paradigm there is
a very good chance that fetching these dependencies might take as much time as the build itself.

`Partial` support means that I could get cache working for Maven but not Gradle (or that caching is non configurable in general). `Yes` means that both my Gradle and Maven 
builds had cache enabled with no problems at all. 

For me this is probably the most important feature as lack of cache will make all builds much slower (and in some cases
the dependency downloading dominates the actual compilation).

#### Docker support

This is a very confusing metric for a lot of people. Several products advertise Docker support and actually mean that they use Docker internally for powering 
the service itself. Frankly this is irrelevant to me. Docker support for me means that the service allows **me** to use
Docker in my builds, either by overriding the default build environment with a custom Docker image or by creating Docker images as artifacts at the end of the build.

#### Pipelines

A pipeline is any arbitrary sequence of steps as defined [in the continuous delivery book](https://martinfowler.com/books/continuousDelivery.html). Several products advertise pipelines and they just mean that you can add a deployment step
after your compilation phase. This is certainly a start, but complex pipelines cannot be created with such as simple model.
Pipelines should also be able to fan out (parallel steps) and then merge back in.

Distelli and Buddy have the most comprehensive pipeline support. Wercker also offers pipelines in a much more complex manner. SolanoLabs has proper [Pipeline support as a beta feature](http://docs.solanolabs.com/Beta/build-pipelines/).

##### Local builds

It is very convenient to be able to run a build locally in exactly the same manner as the build server. At the time or writing
only Codeship Pro and Wercker support this feature (i.e. building without committing anything).

Distelli takes a completely different approach allowing you to use local build servers (but they are still managed
by their web interface).


##### SSH into build slaves.

While build logs are certainly helpful when a build fails, having SSH support for a build slave is the ultimate tool
for debugging build problems. At the time of writing this capability is offered only by CircleCI, Codeship, SemaphoreCI, SolanoLabs and
Vexor.

### A final word about pricing

Trying to compare products for their price proved a very difficult process. Some products charge with number of projects,
some charge with executors, and some (i.e. Vexor) charge by build times! Pricing is something volatile, and I imagine
that if you are a big/well known company you might get different quotes anyway.

As a starting point I mention which products are free for open source (public) projects and the cheapest plan. If you have a better
table than this I am happy to include it here.

| Company                          | Free for Open Source projects  | Free version |    Pricing starts at |
| -------------                    |:--------|   ------ |  ------ |  
| [Buddy](#buddys)       | No     | 1 project | $49/month (25 projects 1 executor)| 
| [CircleCI](#circleci)            | Yes (with limitations)  | 1500 minutes/1 executor | $50/month (2 executors) | 
| [Codefresh](#codefresh)          | Yes (with limitations)  |1 executor/environment | $99/month (3 executors) |
| [Codeship](#codeship)            | Yes (no limits) | 1 builder/100 builds | $49/month (Basic) or $75/month (Pro version) |
| [DeployBot](#deploybot)          | No  | No | $15/month for 10 projects | 
| [Distelli](#distelli)            | Yes (with limitations) | 1 repository | $7/month (10 executors) |
| [SemaphoreCI](#semaphoreci)    | Yes (no limits)   | 100 builds | $29/month (1 executor unlimited private projects) |
| [Shippable](#shippable)          | Yes (no limits)   | Yes (150 builds)| $25/month (2 executors) | 
| [SolanoLabs](#solanolabs)        | No  |No| $15/month (2 executors/ 10 hours) | 
| [Travis](#travis)                | Yes (no limits)  |No  | $69/month (1 executor) |
| [Vexor](#vexor)                  | No   |100 minutes | $0.015 per minute | 
| [Wercker](#wercker)              | No  | 2 executors | $350/month (3 executors) | 


That's it! I hope I saved you some time.






















