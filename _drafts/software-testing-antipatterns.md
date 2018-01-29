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

This problem is very classic with small to medium companies. The application that is being developed in the company has only unit tests (the base of the pyramid) and nothing else.
Usually lack of integration tests is caused by any of the following issues:

1. The company has no senior developers. The team has only junior developers fresh out of college who have only see unit tests
1. Integration tests existed at one point but were abandonded because they caused more trouble than their worth. Unit tests were much more easy to maintain and so they prevailed.
1. The running environment of the application is very "challenging" to setup. Features are "tested" in production.

I cannot really say anything about the first issue. Every effective team should have at least some kind of mentor/champion that can show good practices to the other members. The second issue is covered in detail in antipatterns 8, 9 and 10

This brings us to the last issue - difficulty in setting up a test environment. Now don't get me wrong, there are indeed some applications that are *really* hard to test. Once I had to work with a set of REST applications that actually required special hardware on their host machine. This hardware existed only in production, making integration tests very challenging. But this is a corner case. For the run-of-the-mill web or back-end application that they typical company requires, setting up a test environment should be a non-issue. With the appearance of Virtual Machines and lately Containers this is more true than even. Basically if you are trying to test an application that is hard to setup, you need to fix the setup process first before dealing with the tests themselves.

But why are integration tests essential in the first place?  

The truth here is that there are some types of issues that *only* integration tests can detect. The canonical example is everything that has to do with database operations. Database transactions, database triggers and any stored procedures can only be examined with integration tests that touch them. Any connections to other modules either developed by you or external teams need integration tests (a.k.a. contract tests). Any tests that need to verify performance tests are integration tests by definition. Here is a summary

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









