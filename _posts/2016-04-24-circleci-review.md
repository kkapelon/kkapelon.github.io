---
layout: post
title: CircleCI review
category: hosted-ci-comparison
---

CircleCI is an american company started in 2011. They have a very active web page (and twitter account) and a blog covering build related topics. Although they don’t advertise Java support that much, a lot of their blog posts are Clojure related. Detailed pricing can be found on their webpage. 

### Connectivity

CircleCI supports only Github. The integration is fast and easy. The first is to authorize CircleCI to access your repositories:

![CircleCI authorize application](../../assets/circleci/auth.png)

The second step is to add the repositories you want.

![Adding a project to CircleCI](../../assets/circleci/add-project.png)

The process is really dead simple

Points 2 out of 5 (only supports github)

### First-time setup

CircleCI has one of the ideal setup procedures. Of course it supports a circle.yml file but this is completely optional. Not only you can override this file, but you also get a nice GUI for this.

![CircleCI UI builder](../../assets/circleci/ui-builder.png)

In addition to the GUI builder, it examines your repository and attempts to autodetect the type of build system you use.

I was amazed by the fact that it understood my Clojure project and run the correct command with zero configuration from my part:

![CircleCI repository autodetection](../../assets/circleci/autodetect.png)

I was able to get a successful build in a matter of seconds.

Points = base 2 + 1 (autodetection) + 1 (gui builder) = 4 out of 5

### User Interface

Out of the 14 companies, CircleCI has arguably the best user interface. It is very clean and very well thought. The dashboard can easily cater to any number of projects:

![CircleCI dashboard](../../assets/circleci/dashboard.png)

Each build shows clearly the steps involved:

![CircleCI build steps](../../assets/circleci/build.png)

There are some very nice touches such as showing status of services inside the same gui.

![CircleCI status of external services](../../assets/circleci/status.png)

Points = base 2 + 1 (clean interface) + 1 (snappy interface) = 4 out of 5

### Build environment

With a custom circle.yml you are free to prepare the environment as you want. Circle build servers have already pre-installed Java, Gradle, Maven and anything else you need for standard development. You can add other services very easily

The main problem with the environment is the fact that all phases are hardcoded. The phases are:

* machine: 
* checkout: 
* dependencies: 
* database: 
* test: 
* deployment:

You can see instantly that this pattern is better for interpreted languages where fetching the dependencies and running unit tests are two completely different phases. 

In the Java world this is not the usual case. Both Gradle and Maven fetch their dependencies dynamically (i.e when they needed). For example Maven with fetch its surefire dependencies only when you actually run JUnit tests.

That would not be a big problem apart from the fact that the cache mechanism in CircleCI is hardcoded to run directly after the dependencies phase.

This means that any deps your build system uses after that step are never cached. According to the official documentation from CircleCI you should setup the following for Java projects:

* dependencies: mvn dependency: resolve
* test: mvn integration-test

This means that all dependencies fetched by Maven during unit tests will never be cached. A more realistic setup is the following:

* dependencies: mvn dependency:go-offline
* test: mvn integration-test

Even that is not 100% efficient as surefire itself will be downloaded again and again during the tests phase (a similar issue exists with Gradle as well).. It is really a pity that CircleCI misses this because on the other hand it has explicit support for Maven and Gradle cache directories (I did not have to set them up manually)

![CircleCI built-in cache support for popular tools](../../assets/circleci/cache.png)

As I said in the introduction if downloading dependencies is a small part of your build, then you might not be bothered with this caching problem at all, so make sure that you measure your own builds. 

Note that at the time or writing CircleCI used Gradle 1.10 so you should possibly use the Gradle wrapper to define your own Gradle version.

CircleCI seems to have native support for Android builds but I didn’t have time to test it. If somebody has tested this successfully mention it in the comments and I will add one more point to the score.

Points = base 2 + 1 (auto-caching for Maven and Gradle) = 3 out of 5

### Feedback

When you run a build you get a nice breakdown of all build phases. You can expand each one for specific details.:

![CircleCI feedback](../../assets/circleci/build.png)

The build log is almost real time.

![CircleCI feedback](../../assets/circleci/feedback.png)

CircleCI is one of the few products that supports reporting of JUnit tests. Unfortunately they are not enabled by default which again is a pity because the presence of a pom.xml or build.gradle should implicitly enable that report as well.

![CircleCI test support](../../assets/circleci/test.png)

To enable the test report I had to use a circle.yml that included the following content (configuration for Maven, I used a different one for Gradle)

{% highlight conf %}
test:
  post:
    - mkdir -p $CIRCLE_TEST_REPORTS/junit/
    - find . -type f -regex ".*/target/surefire-reports/.*xml" -exec cp {} $CIRCLE_TEST_REPORTS/junit/ \;

{% endhighlight %}

Test reports can also be collected as artifacts of the build, giving you one-click access to them:

![CircleCI test report](../../assets/circleci/test-report-gradle.png)

The real highlight however, of CircleCI is the SSH support. You can ssh directly to the build machine. Your build will be paused and you are free to run any commands you want in order to debug a problematic build. The authentication method is with ssh keys (the same ones defined in Github)

![CircleCI ssh support ](../../assets/circleci/ssh.png)

### Post-build steps/deployments

The first thing I liked about CircleCI is that it allows you to define artifact files for you build that will survive and can be downloaded afterwards. This is very helpful if you don’t want to deploy anything and just want to fetch the final outcome of the build.

![CircleCI artifact saving ](../../assets/circleci/artifact.png)

Regarding deployment you are free to define any custom command in the circle.yml.  The build machine is a normal Linux installation so you can install any software that might help you.
Looking at the docs CircleCI has native support for several providers (Heroku, AWS, Google Cloud etc)

Points = base 2 + 1 (artifacts) + 1 (popular cloud providers) = 4 out of 5

### Enterprise features

I have already mentioned the “scalable” UI of CircleCI (by that I mean that I can easily handle a lot of projects and it is very easy to navigate).

One feature I liked is the “insights” tab. This gives some very important metrics that would be helpful for large projects with lengthy build cycles:

![CircleCI insights](../../assets/circleci/history.png)

CircleCI supports the following (but unfortunately I had no time to test them)

* A REST API 
* Test parallelism

Points = base 2  + 1 (REST API) = 3 out of 5

I did not find any support for build pipelines.

### Documentation

Documentation in CircleCI is very extensive. It contains guides specific to each language along with the reference information. 

![CircleCI documentation](../../assets/circleci/docs.png)

Whenever I stumbled on something (e.g. how to get test reports) the docs always had the answer.

Points = base 2  + 1 (language guides) +1 (how-tos)= 4 out of 5

### Support

Even though I got the standard support message (that a ticket has been created) when I emailed CircleCI, I was actually contacted by a human soon enough.

CircleCI also noticed and answered all my Tweets about them

Points = base 2  + 1 (email response) +1 (Twitter response)= 4 out of 5

### CircleCI score card and conclusion

* Connectivity = 2 out of 5
* First time setup = 4 out of 5
* UI = 4 out of 5
* Build setup = 3 out of 5
* Feedback = 4 out of 5
* Post build = 4 out of 5
* Enterprise support = 3 out of 5
* Documentation = 4 out of 5
* Support = 4 out of 5

Working with CircleCI was a very pleasant experience. They have obviously looked at the needs of Java developers. Out of all 14 companies they have possibly the best UI experience and some killer features such as SSH support and reporting of JUnit results.

If you work at CircleCI and are reading this, your product is almost perfect. You should improve the caching mechanism to allow the developer to decide when things are cached and restored (some other companies already do that). Also unit tests should be automatically shown (at least for Gradle and Maven builds) as the test results are always in known directories. 

**Verdict:** I highly recommend CircleCI.











