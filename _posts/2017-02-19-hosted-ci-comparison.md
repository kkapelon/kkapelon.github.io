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
existence of a Maven or Gradle file in the repo and act accordingly (at least as a starting point).


![Codeship no autodetection](../../assets/ci-comparison/codeship/codeship-no-autodetection.png)


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

The user interface of Codeship has a clean layout and shows all needed information. It has
however two minor quirks that spoil the experience.
The first problem is that there is no “dashboard” (or at least I did not find it). You can only
select a single project and manage it.

![Codeship no dashboard](../../assets/ci-comparison/codeship/no-dashboard.png)

So if you have let’s say 8 projects there is no way to see a single page that gives you the
pass/fail status of all projects. You need to visit them one by one to see their last build.

The second problem is that in the feedback screen where you see the results of the build an
"accordion" component is used. This means that it is impossible to expand all sections at
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
| User Interface | Big problems with UX. The accordion component for the logs is especially problematic. Lack of a dashboard that shows all projects.  |
| Build configuration | No project autodetection. No support for Gradle |
| Docker support | None in the basic version. Full Docker support (and more) in the pro version|
| Extra features    | Rest API, Deployment pipelines, test parallelism, [Roles](https://documentation.codeship.com/general/account/organizations/)|
| Disadvantages    | No Gradle cache, needs a push to start the first build (!!!)  |
| Killer feature    | You can ssh to a clone of your environment. The Jet local build process  in Codeship Pro.|
| **Final Verdict**    | Codeship might be ok (if you forgive the UI problems) for a small number of Maven projects. If you use Gradle then don't even bother. |

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
first built to run in the first place.
I noticed that there is no built-in
support for Maven/Gradle and moved on.

Deploybot has integrations for popular cloud providers like Digital Ocean, Heroku, AWS etc.
Of course it is still a mystery to me how you can use them after your build runs, (as the build
server is another deployment option itself).

I have to say that despite the shortcomings of the product, their support was responsive,
knowledagable and really helpful. 

Deploybot might be a good service for developers of interpreted languages where the source
files go straight to the deployment server. But for Java developers where only binaries are
deployed, the experience is awful (the UI is awful for everybody of course). You can safely
scratch it off from your evaluation list and look at all the other options presented in this report.


If you work at Deploybot and are reading this, know that your UI needs a lot of improvements. You need to hire a professional UX
designer and recreate the whole interface from scratch. That being said, your support staff is
excellent.

**Final Verdict:** Avoid Deploybot. The product is clearly aimed at Python/Ruby devs and the UI is
very confusing.



### Distelli

### SemaphoreApp

*Disclaimer:* I have written [testing](https://semaphoreci.com/community/tutorials/testing-rest-endpoints-using-rest-assured) [tutorials](https://semaphoreci.com/community/tutorials/how-to-split-junit-tests-in-a-continuous-integration-environment) and a [blog post](http://blog.codepipes.com/containers/go-docker-semaphoreci-gcloud-tutorial.html) for SemaphoreCI, but I have no special
affiliation with them.

[SemaphoreCI](https://semaphoreci.com/) is the product of a company called [RenderedText](http://renderedtext.com/) which is located in Serbia. They have a very active site with [a large collection
of tutorials](https://semaphoreci.com/community/tutorials) on various topics related to CI including [TDD](https://en.wikipedia.org/wiki/Test-driven_development) and Docker.

I had a feeling that my experience with SemaphoreCI would be a positive one, right from the configuration step. They fully support autodetection of Java build systems, and I was really impressed when my Clojure project was handled correctly with zero-configuration on my part:

![Semaphore autodetection](../../assets/ci-comparison/semaphore/lein-autodetect.png)

They also closely follow Gradle as they had the latest version (3.3 at the time of writing) installed in the build slave.
Unfortunately the caching support is only active for Maven and no support exists for Gradle by default.

Overall the UI of SemaphoreCI is very stream-lined and well thought. They have a Jenkins-like dashboard that gathers
all projects along with their latest build.

![Semaphore dashboard](../../assets/ci-comparison/semaphore/dashboard.png)

It is very easy to setup deployments for common providers (e.g. Heroku, AWS) or you can write your own scripts
for anything custom:

![Semaphore deployments](../../assets/ci-comparison/semaphore/pipeline.png)

As with CircleCI, Semaphore allows you to SSH into your build slave for debugging purposes. The keys used for the SSH access are unrelated with the Github ones. You create them
explicitly for debugging.

![Semaphore deployments](../../assets/ci-comparison/semaphore/ssh.png)

Finally, Docker is pre-installed in the build slaves (as an option) with the latest version. It doesn't
get any easier than this to obtain docker support for your builds.

In general SemaphoreCI is a good all around solution. It does everything right and works just like you would expect. 


| Website    | [SemaphoreCI](https://semaphoreci.com/) |
| Pricing    | [Details](https://semaphoreci.com/pricing) |
| Documentation    | Good but sometimes it feels geared towards Ruby and [lacks some Java topics](https://semaphoreci.com/docs/) |
| User Interface | Very well thought interface. Could be improved by making use of the whole screen space in big screens.|
| Build configuration | Impressive project autodetection. Very easy to add build steps.|
| Docker support | Built-in|
| Extra features    | [Insights](https://semaphoreci.com/blog/2015/11/20/semaphore-insights.html), Deployment pipelines, [test parallelism](https://semaphoreci.com/docs/running-tests-in-parallel.html)|
| Disadvantages    | No Gradle cache. Maven cache [is ready](https://semaphoreci.com/docs/caching-between-builds.html)  |
| Killer feature    | You can ssh to build servers. Docker is pre-installed. Excellent autodetection of build systems|
| **Final Verdict**    | Highly recommended for Maven projects. Gradle projects work ok as well but may be slow until cache support is added. |


### Shippable

[Shippable](https://app.shippable.com/) is an American company based in Seattle. They also have a [content-rich blog](http://blog.shippable.com/) with topics such
as microservices, Docker, Continuous delivery etc.

Shippable does not support any kind of autodetection of your project. In fact it will just refuse to
run if you don't have a custom configuration file in your project. I have already written [why
I consider this a bad practice](https://zeroturnaround.com/rebellabs/9-features-you-need-to-demand-from-a-hosted-continuous-integration-service/). This file should be optional (CircleCI achieves this beautifully for example)

![Shippable error](../../assets/ci-comparison/shippable/yml-required.png)

So in order to play along I had to make several commits into my repository until [my configuration](http://docs.shippable.com/ci/shippableyml/) was correct.
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

Apart from the freezing of UI, the builds themselves were very slow. With my example projects
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
| Killer feature    | Test coverage for your tests (Jacoco)|
| **Final Verdict**    | I cannot recommend Shippable until the performance is fixed. The yml file should become optional like CircleCI. Cache should be enabled at least for Maven. |

### SolanoLabs

### Travis

### Vexor

[Vexor](https://vexor.io/) is a Russian company launched in 2011 and located in Moscow. The parent company is [Evrone](https://evrone.com/). Their website is very spartan and their blog contains exactly one post about the product itself.

Vexor supports both GitHub and Bitbucket and it was very easy to build projects from both types or repositories.

The first surprise came from the autodetection dialog. They can detect Scala and Clojure but not Java!!!

![Vexor autodetect](../../assets/ci-comparison/vexor/auto-detect.png)

My Clojure project was built right way, but my Java one needed special customization. Vexor supports
a yml file with the same syntax as Travis. The good thing however is that it also offers a simple GUI that allows
you to define your yml via the web interface so that you don't litter your repo with extra files (I am looking
at you Shippable).

I made the configuration change and was also able to add cache support for both Gradle and Maven. Awesome!
Latest Maven version (3.x ) is pre-installed. For Gradle you can use the Gradle wrapper.
The latest version of Docker is also available in the build slaves.

Vexor was clearly created by a web development company that knows about UX. The UI feels very fluid,
had very nice animations and is a joy to navigate. CircleCI might have the most functional GUI, but Vexor has
the most beautiful one.

![Vexor dashboard](../../assets/ci-comparison/vexor/dashboard.png)

A minor problem with configuration is that even though you can get a build on master straight away, if you want
to build another branch, you need to make a commit there so that Vexor can pick it up.

Vexor also supports SSHing into the build slave, but there is a catch. Ssh access is only available while the slave
is running. If your build finishes too fast you are out of luck. So the trick is to add some sleep statements
in you build script. 

![Vexor ssh session](../../assets/ci-comparison/vexor/ssh-in.png)

I did not know about this trick and their documentation is not helping me either:

![Vexor documentation](../../assets/ci-comparison/vexor/documentation.png)

Unfortunately this also means that the time you spent debugging your build also counts against your billing. So
make sure you are aware of this before connecting.

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

### Conclusion


















