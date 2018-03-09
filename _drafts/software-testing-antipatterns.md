---
layout: post
title: Software Testing Anti-patterns
category: testing
---

### Introduction

There are several articles out there that talk about testing anti-patterns in the software development process. Most of them however deal with the low
level details of the programming code, and almost always they focus on a specific technology or programming language. 

In this article I wanted to take a step back and catalog some high-level testing anti-patterns that are technology agnostic. Hopefully you will recognize some of these patterns regardless of your favorite programming language.


### Terminology

Unfortunately, testing terminology has not reached a common consensus yet. If you ask 100 developers what is the difference between an integration test, a component test and an end-to-end test you might get 100 different answers. For the purposes of this article I will focus on the definition of the test pyramid as presented below. 

![The Testing pyramid](../../assets/testing-anti-patterns/testing-pyramid.png)

If you have never encountered the testing pyramid before, I would urge you to become familiar with it first before going on. Some good starting points are:

 * [The forgotten layer of the test automation pyramid](https://www.mountaingoatsoftware.com/blog/the-forgotten-layer-of-the-test-automation-pyramid) (Mike Cohn 2009)
 * [The Test Pyramid](https://www.mountaingoatsoftware.com/blog/the-forgotten-layer-of-the-test-automation-pyramid) (Martin Fowler 2012)
 * [Google Testing blog ](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html) (Google 2015)

 The testing pyramid deserves a whole discussion on its own, especially on the topic of the amount of tests needed for each category. For the current article I am just referencing the pyramid in order to define the two lowest test categories. Notice that in this article User Interface Tests (the top part of the pyramid) are *not* mentioned (mainly for brevity reasons and because UI tests come with their own specific antipatterns). 


 Therefore the two major test categories mentioned as *unit* and *integration* tests from now on are:

 | Tests | Focus on | Require | Speed | Complexity | Setup needed |
 | ------- | ---------- | --------- |  --------- | ------- | -------------|
 | Unit tests | a class/method  | the source code | very fast | low | No |
 | Integration tests | a component/service | part of the running system | slow | medium | Yes |

 **Unit tests** are the category of tests that have wider acceptance regarding the naming and what they mean. They are the tests that accompany the source code and have direct access to it. Usually they are executed with an [xUnit framework](https://en.wikipedia.org/wiki/XUnit) or similar library. These tests work directly on the source code and have full view of everything. A single class/method/function is tested (or whatever is the smallest possible working unit for that particular business feature) and anything else is mocked/stubbed.

 **Integration tests** (also called service tests, or even component tests) focus on a whole component. A component can be a set of classes/methods/functions, a module, a subsystem or even the application itself. They examine the component by passing input data and examinining the output data it produces. Usually some kind of deployment/bootstrap/setup is required first. External systems can be mocked completely, replaced (e.g. using an in-memory database instead of a real one), or the real external dependency might be used depending on the business case. Compared to unit tests they may require more specialized tools either for preparing the test environment, or for interacting/verifying it.

 The second category suffers from a blurry definition and most naming controversies regarding testing start here. The "scope" for integration tests is also highly controversial and especially the nature of access to the application ([black](https://en.wikipedia.org/wiki/Black-box_testing) or [white](https://en.wikipedia.org/wiki/White-box_testing) box testing and whether [mocking](https://en.wikipedia.org/wiki/Mock_object) is allowed or not).

As a basic rule of thumb if

 * a test uses a database
 * a test uses the network to call another component/application
 * a test uses an external system (e.g. a queue or a mail server)
 * a test reads/writes files or performs other I/O
 * a test does not rely on the source code but instead it uses the deployed binary of the app

…then it is an integration test and not a unit test. 

 With the naming out of the way, we can dive into the list. The order of anti-patterns roughly follows their appearance in the the wild. Frequent problems are gathered in the top positions. 

### Software Testing Anti-Pattern List


1. Having unit tests without integration tests
1. Having integration tests without unit tests
1. Having the wrong kind of tests
1. Testing the wrong functionality
1. Testing internal implementation
1. Paying excessive attention to test coverage
1. Having flaky or slow tests
1. Running tests manually
1. Treating test code as a second class citizen
1. Ignoring tests
1. Not converting production bugs to tests
1. Treating TDD as a religion
1. Writing tests without reading documentation first
1. Giving testing a bad reputation out of ignorance


### Anti-Pattern 1 - Having unit tests without integration tests

This problem is a classic one with small to medium companies. The application that is being developed in the company has only unit tests (the base of the pyramid) and nothing else.
Usually lack of integration tests is caused by any of the following issues:

1. The company has no senior developers. The team has only junior developers fresh out of college who have only seen unit tests
1. Integration tests existed at one point but were abandonded because they caused more trouble than their worth. Unit tests were much more easy to maintain and so they prevailed.
1. The running environment of the application is very "challenging" to setup. Features are "tested" in production.

I cannot really say anything about the first issue. Every effective team should have at least some kind of mentor/champion that can show good practices to the other members. The second issue is covered in detail in antipatterns 8, 9 and 10

This brings us to the last issue - difficulty in setting up a test environment. Now don't get me wrong, there are indeed some applications that are *really* hard to test. Once I had to work with a set of REST applications that actually required special hardware on their host machine. This hardware existed only in production, making integration tests very challenging. But this is a corner case. 

For the run-of-the-mill web or back-end application that the typical company creates, setting up a test environment should be a non-issue. With the appearance of Virtual Machines and lately Containers this is more true than ever. Basically if you are trying to test an application that is hard to setup, you need to fix the setup process first before dealing with the tests themselves.

But why are integration tests essential in the first place?  

The truth here is that there are some types of issues that *only* integration tests can detect. The canonical example is everything that has to do with database operations. Database transactions, database triggers and any stored procedures can only be examined with integration tests that touch them. Any connections to other modules either developed by you or external teams need integration tests (a.k.a. contract tests). Any tests that need to verify performance, are integration tests by definition. Here is a summary on why we need integration tests:

 | Type of issue | Detected by Unit tests | Detected by Integration tests | 
 | ------- | ---------- | --------- |  
 | Basic business logic | yes | yes | 
 | Component integration problems | no | yes | 
 | Transactions | no  | yes | 
 | Database triggers/procedures | no | yes |
 | Wrong Contracts with other modules/APIs | no | yes |
 | Wrong Contracts with other systems | no | yes |
 | Performance/Timeouts | no | yes |
 | Deadlocks/Livelocks | maybe | yes |
 | Cross-cutting Security Concerns| no | yes |

 Basically any cross-cutting concern of your application will require integration tests. With the recent microservice craze integration tests become even more important as you now have contracts between your own services. If those services are developed by other teams, you need an automatic way to verify that interface contracts are not broken. This can only be covered with integration tests.

 To sum up, unless you are creating something extrememely isolated (e.g. a command line linux utility), you really **need** integration tests to catch issues not caught by unit tests.


### Anti-Pattern 2 - Having integration tests without unit tests

This is the inverse of the previous anti-pattern. This anti-pattern is more common in large companies and large enterprise projects. Almost always the history behind this anti-pattern involves developers who believe that unit tests have no real value and only integration tests can catch regressions. There is a large majority of experienced developers who consider unit tests a waste of time. Usually if you probe them with questions, you will discover that at some point in the past, upper management had forced them to increase code coverage (See anti-pattern 6) forcing them to write trivial unit tests.

Now don't get me wrong, in theory you *could* have only integration tests in a software project. But in practice this would become very expensive to test (both in developer time and in build time).
We saw in the table of the previous section that integration tests can also find business logic errors after each run, and so they could "replace" unit tests in that manner. But is this strategy viable in the long run?

#### Integration tests are complex

Let's look at an example. Assume that you have a service with the following 4 methods/classes/functions.

![Cyclomatic complexity for 4 modules](../../assets/testing-anti-patterns/just-unit-tests.png)

The number on each module denotes its [cyclomatic complexity](https://en.wikipedia.org/wiki/Cyclomatic_complexity) or in other words the separate code paths this module can take. 

Mary "by the book" Developer wants to write unit tests for this service (because she understands that unit tests *do* have value). How many tests does she need to write in order to get full coverage of all possible scenarios?

It should be obvious that one can write 2 + 5 + 3 + 2 = 12 isolated unit tests that cover fully the **business logic** of these modules. Remember that this number is just for a single service, and the application Mary is working on, has multiple services.

Joe "Grumpy" developer on the other hand does not believe in the value of unit tests. He thinks that unit tests are a waste of time and he decides to write only integration tests for this module. How many integration tests should he write? He starts looking at all the possible paths a request can take in that service.

![Examining code paths in a service](../../assets/testing-anti-patterns/just-integration-tests.png)

Again it should be obvious that all possible scenarios of codepaths are 2 * 5 * 3 * 2 = 60. Does that mean that Joe will actually write 60 integration tests? Of course not! He will try and cheat. He will try to select a subset of integration tests that feel "representative". This "representative" subset of tests will give him enough coverage with the minimum amount of effort.

This sounds easy enough in theory, but can quickly become problematic. The reality is that these 60 code paths are not created equally. Some of them are corner cases. For example if we look at module C we see that is has 3 different code paths. One of them is a very special case, that can only be recreated if C gets a special input from component b, which is itself a corner case and can only be obtained by a special input from component A. This means that this particular scenario might require a very complex setup in order to select the inputs that will trigget the special condition on the component C.

Mary on the other hand, can just recreate the corner case with a simple unit test, with no added complexity at all.

![Basic unit test](../../assets/testing-anti-patterns/unit-test-corner-case.png)

Does that mean that Mary will *only* write unit tests for this service? After all that will lead her to anti-pattern 1. To avoid this she will write *both* unit *and* integration tests. She will keep all unit tests for the actual business logic and then she will write 1 or 2 integration tests that make sure that the rest of the system works as expected (i.e. the parts that help these modules do their job)

The integration tests needed in this system should focus on the rest of the components. The business logic itself can be handled by the unit tests. Mary's integration tests will
focus on testing serialization/deserialization and with the communication to the queue and the database of the system.

![correct Integration tests](../../assets/testing-anti-patterns/correct-integration-tests.png)

In the end the number of integration tests will be much smaller than the number of unit tests (matching the shape of the test pyramid described in the first section of this article).



#### Integration tests are slow

The second big issue with integration tests apart from their complexity is their speed. Usually an integration test is one order of magnitute slower than a unit test. Unit tests need just the source code of the application and nothing else. They are almost always CPU bound. Integration tests on the other hand can perform I/O with external systems making them much more difficult to run in an effective manner. 

Just to get an idea on the difference for the running time let's assume the following numbers.

* Each unit test takes 60ms (on average)
* Each integration test takes 800ms (on average)
* The application has 40 services like the one shown in the previous section
* Mary is writing 10 unit tests and 2 integration tests for each service
* Joe is writing 12 integration tests for each service

Now let's do the calculations. Notice that I assume that Joe has found the perfect subset of integration tests that give him the same code coverage as Mary (which would not be true in a real application).

 |  Time to run | Having only integration tests (Joe) | Having both Unit and Integration tests (Mary) | 
 | ------- | ---------- | --------- |  
 | Just Unit tests | N/A | 24 seconds | 
 | Just Integration tests | 6.4 minutes | 64 seconds | 
 | All tests | 6.4 minutes  | 1.4 minutes |

 The difference in total running time is enormous. Waiting for 1 minute after each code change is vastly different than waiting for 6 minutes. The 800ms I assumed for each integration test is vastly conservative. I have seen integration test suites where a single test can take several minutes on its own.

 In summary, trying to use *only* integration tests to cover business logic is a huge time sink. Even if you automate the tests with CI, your feedback loop (time from commit to getting back the test result) will be very long.


#### Integration tests are hard to debug

The last reason why having only integration tests (without any unit tests) is an anti-pattern is the amount of time spent to debug a failed test. Since an integration test is testing multiple software components (by definition), when it breaks, the failure can come from *any* of the tested components. Pinpointing the problem can be a hard task depending on the number of components involved.

When an integration tests fails you need to be able to understand why it failed and how to fix it. The complexity and breadth of integration tests make them extremely difficult to debug. Again, as an example let's say that your application only has integration tests. You run them and get the following result.








