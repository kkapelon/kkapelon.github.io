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






