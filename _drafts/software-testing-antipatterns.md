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

 With the naming out of the way, we can dive into the list. The order of anti-patterns roughly follows their appearance in the the wild. Frequent problems are gathered in the top positions. 

### Software Testing Anti-Pattern List


1. Having unit tests without integration tests
1. Having integration tests without unit tests
1. Having the wrong kind of tests
1. Testing the wrong functionality
1. Treating test code as a second class citizen
1. Testing internal implementation
1. Paying excessive attention to test coverage
1. Having flaky or slow tests
1. Running tests manually
1. Ignoring tests
1. Not converting production bugs to tests
1. Treating TDD as a religion
1. Writing tests without reading documentation first
1. Giving testing a bad reputation out of ignorance


### Anti-Pattern 1 - Having unit tests without integration tests

sd






