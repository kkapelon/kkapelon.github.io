---
layout: post
title: Comparison of Hosted Continuous Integration products
category: hosted-ci-comparison
---

### A brief comparison of hosted Continuous Integration services

I was a happy user of [SnapCI](https://snap-ci.com/). I really liked the way pipelines worked and how easy was
to add a new project. SnapCI also had other nice features for Java developers like automatic caching
for both Maven and Gradle dependencies.

![SnapCI dashboard](../../assets/ci-comparison/snapci-pipeline.png)

Unfortunately SnapCI was [discontinued in February 2017](https://blog.snap-ci.com/blog/2017/02/06/2017-02-06-snap-announcement/) so I have to yet again research all the available options.
This time I am sharing my discoveries so that I may save you some time.


#### Hosted Continuous Integration products.

At the time of writing I am aware of the following companies that offer hosted CI services for Java projects.
If I miss anything [let me know](http://codepipes.com/contact.html).


* [Buddy Works](https://buddy.works/)
* [CircleCI](https://circleci.com/) 
* [Codefresh](http://codefresh.io/) 
* [Codeship](https://codeship.com/) 
* [DeployBot](https://deploybot.com/)
* [Distelli](https://www.distelli.com/) 
* [SemaphoreApp](https://semaphoreci.com/) 
* [Shippable](https://app.shippable.com/) 
* [SolanoLabs](https://www.solanolabs.com/) 
* [Travis](https://travis-ci.org/) 
* [Vexor](https://vexor.io/) 
* [Wercker](http://www.wercker.com/) 



##### Comparison Criteria


Because I am mainly a Java developer I have tested all of them with JVM projects. Here are those that I left out:

* [GreenhouseCI](https://greenhouseci.com/) (Android and iOS only)
* [Bitrise](https://www.bitrise.io/) (Android and iOS only)
* [AppVeyor](http://www.appveyor.com) (Windows only)
* [AppHarbor](https://appharbor.com/) (.NET only)
* [MagnumCI](https://magnum-ci.com/) (Supports Ruby, Go, PHP,Python but not Java)


#### My sample projects

For my tests I used 4 sample projects:

1. A [public Github repo](https://github.com/kkapelon/spring-mvc-wizard-sample) with a Maven Java project
1. The same repo with a Gradle build file
1. A private repo in Bitbucket (for companies that supported Bitbucket)
1. A public Github repo with a [Clojure/Leiningen project](https://github.com/kkapelon/clojure-http-server) (just to get something more exotic apart from Maven/Gradle)

Companies are presented in alphabetical order.
So let’s begin!

### BuddyWorks

### CircleCI

[CircleCI](https://circleci.com/) is an american company started in 2011. They have a very active web page (and [twitter account](https://twitter.com/circleci)) and a [blog](https://circleci.com/blog/) covering build related topics. Although they don’t advertise Java support that much, a lot of their blog posts are Clojure related. They support both Github and Bitbucket.

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
| User Interface| Out of the products, CircleCI has arguably the best user interface. It is very clean and very well thought.  |
| Build configuration | Great autodetection of build systems. Uses either a yml file or custom UI builder. |
| Docker support | [Basic support](https://circleci.com/docs/docker/) in the present version. Full support [in the next version](https://circleci.com/integrations/docker/).|
| Extra features    |  [Splitting](https://circleci.com/docs/parallelism/) of tests. Project [Insights](https://circleci.com/blog/announcing-circleci-per-project-insights/). Fully [REST API](https://circleci.com/docs/api/)|
| Disadvantages    | Build order is not ideal for Java projects. Caching is problematic for test dependencies. No support for pipelines.|
| Killer feature    | You can ssh directly into the build machine. Support for [JUnit reports](https://circleci.com/docs/test-metadata/). |
| **Final Verdict**    | Highly recommended for simple projects with no pipelines |

### Codefresh

### Codeship

[Codeship](https://codeship.com/) is another American company from Boston. They have a vibrant web page filled
with guides and [blog posts](https://blog.codeship.com/) about CI topics. Codeship supports GitHub , Bitbucket and even Gitlab. You can authenticate with any of them and
add repositories right away.

First time setup is a bit troublesome. First of all there is absolutely no form of autodetection for
a build system. You are given all possible commands in the GUI and are expected to
uncomment the one that fits you. I don’t understand why it is that difficult to check the
existence of a MAven or Gradle file in the repo and act accordingly (at least as a starting point).


![Codeship no autodetection](../../assets/ci-comparison/codeship/codeship-no-autodetection.png)


However the thing that bothers me most with Codeship is that once you are finished with the
setup a build does NOT run at all. There is no build button!
You are expected to commit something and only then codeship will build your project.

![Codeship push first](../../assets/ci-comparison/codeship/you-must-push.png)

I am at a loss of words why this is required? I don’t think there is a technical reason for this
because several other companies can perform a build without a commit.
My repository was already finished so I had to make a dummy commit in order to start the
build. Duh!
I forgive Codeship for the lack of autodetection of build system, but I find no excuses for the
lack of a “build Now” button.

The user interface of Codeship has a clean layout and shows all needed information. It has
however two minor quirks that spoil the experience.
The first problem is that there is no “dashboard” (or at least I did not find it). You can only
select a single project and manage it.

![Codeship no dashboard](../../assets/ci-comparison/codeship/no-dashboard.png)

So if you have let’s say 8 projects there is no way to see a single page that gives you the
pass/fail status of all projects. You need to visit them one by one to see their last build.
The second problem is that in the feedback screen where you see the results of the build an
“accordion” component is used. This means that it is impossible to expand all sections at
once to see what is happening. Only one section can be open. Sad but true.

My experiments show that Maven dependencies are cached but Gradle ones do not.
If you use Gradle Wrapper in your build you will even be forced to redownload
it for every
build that runs.

On the other hand Codeship build servers have preinstalled
all the popular build tools and
even some exotic ones (for Scala and Clojure).

Like CircleCI, Codeship support ssh access to the build servers but with an additional twist!
You ssh into a clone of the build machine while the build machine actually runs the next
build!
This means that you can debug a failed build at your leisure without blocking the build
queue.
From all products tested, only Codeship supports this nonblocking
ssh.
The keys used for the SSH access are unrelated with the Github ones. You create them
explicitly for debugging.

There is no support for test results or build artifacts.
On the plus side Codeship:

* has explicit support for deployment pipelines where you define what happens
during deployment. 
* comes with [A REST API](https://documentation.codeship.com/basic/getting-started/api/)
* supports [Test parallelism](https://documentation.codeship.com/basic/getting-started/parallelci/)

Documentation is fairly basic. There are some topics without documentation (e.g. how
caching works) but in general I found it descriptive and up-to-date.

To sum up, Codeship is an imbalanced solution. On one hand it has the killer feature of nonblocking
ssh
debugging, but on the other hand the lack of a "build now" button really puzzles me. There is
caching support for Maven but not for Gradle. The fact that built-in Gradle is still at 
version 1.10 perhaps shows what Codeship thinks of supporting it. The technical product under the hood is a
solid one, but it is plagued by several UI problems.

Admittedly Codeship seems to be in a transition to their [Codeship Pro service](https://documentation.codeship.com/pro/getting-started/getting-started/), which is a Docker
based solution that comes with its own executable (called [Jet](https://documentation.codeship.com/pro/getting-started/installation/#what-is-jet)) that allows you to run your build locally. 
The idea is very interesting (and perhaps needs an article on its own) but as I have explained 
already [Docker is not that essential for Java apps](http://blog.codepipes.com/containers/docker-for-java-big-picture.html), so to me it seems like an overkill. You also
need a [special file](https://documentation.codeship.com/pro/getting-started/services/) that mimics the syntax of Docker compose and a [steps file](https://documentation.codeship.com/pro/getting-started/steps/) as well which to me sounds as vendor lock-in. I also could not find anywhere the source code of the Jet executable.

I really wanted to spend some time with Codeship Pro but  I stumbled again upon the "push to trigger your
first build" message and I did not want to add any more dummy commits to my projects just so that Codeship can pick the changes.

If you work at Codeship and are reading this, your product needs some design changes. You
should either support Gradle cache or even better make the cache mechanism transparent
and configurable. Not all Java projects use Maven. Add a "buildnow"
button to all screens
(this is a no brainer). Add a dashboard screen for all projects. Your ssh feature is killer and
you should advertise it more.

I have a feeling that Codeship is best for interpreted runtimes (Python, Ruby etc) so maybe Java is not
getting the attention it deserves from the company.


| Website    | [Codeship](https://codeship.com/) |
| Pricing    | [Details](https://codeship.com/pricing) |
| Documentation    | Good but [nothing impressive here](https://documentation.codeship.com/) |
| User Interface | Big problems with UX. The accordion component for the logs is especially problematic. Lack of a dashboard that shows all projects  |
| Build configuration | No project autodetection. No support for Gradle |
| Docker support | None in the basic version. Full Docker support (and more) in the pro version|
| Extra features    | Rest API, Deployment pipelines, test parallelism, |
| Disadvantages    | No Gradle cache, needs a push to start the first build (!!!)  |
| Killer feature    | You can ssh to a clone of your environment. The Jet local build process  in Codeship Pro.|
| **Final Verdict**    | Codeship might be ok (if you forgive the UI problems) for a small number of Maven projects. If you use Gradle then don't even bother. |

### Deploybot

### Distelli

### SemaphoreApp

### Shippable

### SolanoLabs

### Travis

### Vexor

### Wercker

### Conclusion


















