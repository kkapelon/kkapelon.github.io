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

#### BuddyWorks

#### CircleCI

[CircleCI](https://circleci.com/) is an american company started in 2011. They have a very active web page (and [twitter account](https://twitter.com/circleci)) and a [blog](https://circleci.com/blog/) covering build related topics. Although they don’t advertise Java support that much, a lot of their blog posts are Clojure related. They support both Github and Bitbucket.

CircleCI has one of the ideal setup procedures. Of course it supports a [circle.yml](https://circleci.com/docs/configuration/) file but this is completely optional. Not only you can override this file, but you also get a nice GUI for this.

![CircleCI UI builder](../../assets/ci-comparison/circleci-ui-builder.png)

In addition to the GUI builder, it examines your repository and attempts to autodetect the type of build system you use.

I was amazed by the fact that it understood my Clojure project and run the correct command with zero configuration from my part:

![CircleCI repository autodetection](../../assets/ci-comparison/circleci-autodetect.png)

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

![CircleCI test support](../../assets/ci-comparison/circleci-test.png)

CircleCI also supports [parallel testing](https://circleci.com/docs/parallel-manual-setup/). However,  I could not get this to work even though JUnit is one of the supported test runners.

The real highlight however, of CircleCI is the SSH support. You can ssh directly to the build machine. Your build will be paused and you are free to run any commands you want in order to debug a problematic build. The authentication method is with ssh keys (the same ones defined in Github)

![CircleCI ssh support ](../../assets/ci-comparison/circleci-ssh.png)



Working with CircleCI was a very pleasant experience. They have obviously looked at the needs of Java developers. Out of all  companies I have tried, they have possibly the best UI experience and some killer features such as SSH support and reporting of JUnit results.

If you work at CircleCI and are reading this, your product is almost perfect. You should improve the caching mechanism to allow the developer to decide when things are cached and restored (some other companies already do that). Also unit tests should be automatically shown (at least for Gradle and Maven builds) as the test results are always in known directories. 


| Website    | [CircleCI](https://circleci.com/) |
| Pricing    | [Details](https://circleci.com/pricing/) |
| Documentation    | Documentation in CircleCI [is very extensive](https://circleci.com/docs/). It contains guides specific to each language along with the reference information. |
| User Interface| Out of the products, CircleCI has arguably the best user interface. It is very clean and very well thought.  |
| Build configuration | Great autodetection of build systems. Uses either a yml file or custom UI builder. |
| Docker support | [Basic support](https://circleci.com/docs/docker/) in the present version. Full support [in the next version](https://circleci.com/integrations/docker/).|
| Extra features    | Support for [JUnit reports](https://circleci.com/docs/test-metadata/). [Splitting](https://circleci.com/docs/parallelism/) of tests. Project [Insights](https://circleci.com/blog/announcing-circleci-per-project-insights/).|
| Disadvantages    | Build order is not ideal for Java projects. Caching is problematic for test dependencies. No support for pipelines.|
| Killer feature    | You can ssh directly into the build machine |
| **Final Verdict**    | Highly recommended for simple projects with no pipelines |

#### Codefresh

#### Codeship

#### Deploybot

#### SemaphoreApp

#### Shippable

#### SolanoLabs

#### Travis

#### Vexor

#### Wercker

#### Conclusion


















