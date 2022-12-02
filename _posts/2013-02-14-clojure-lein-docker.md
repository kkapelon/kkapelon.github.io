---
layout: post
title: Multi stage Docker container for a Clojure/Lein application 
category: containers
---

## Introduction

With this post, we round off this series on JVM languages. In the future, we hope to get around to other interesting programming tongues that we missed this time. The last one we checked out was [Fantom](https://fantom.org/), a bit of a move away from the traditional JVM languages, and in that spirit we will talk now about [Clojure](https://clojure.org/), a Lisp-like programming language that runs on the JVM.

![Clojure Logo](../../assets/clojure-lein-docker/clojure-logo.png)

Clojure first appeared in 2007 and is relatively new compared to more established languages. It was created by Rich Hickey as a Lisp dialect targeted for the JVM.

Version 1.0 appeared in 2009 and the name is a pun on C (C#), L (Lisp) and J (Java). The current version of Clojure is 1.4. Clojure is open-source (released under the [Eclipse Public License v 1.0 – EPL](http://www.eclipse.org/legal/epl-v10.html)).

As with the other post, I ported from Java a simple file-based HTTP server that you can download on [Github](https://github.com/kkapelon/clojure-http-server).

## Starting Clojure development with Leiningen

After starting reading the Clojure documentation, I decided to setup my development environment using [Leiningen](http://leiningen.org/) which is a Maven like tool for Clojure. Leiningen (or Lein for short) can perform most tasks for Clojure that you would expect from Maven such as:

* Create a project structure (think: Maven archetypes)
* Handle dependencies
* Compile Clojure code to JVM classes
* Run tests
* Publish built artifacts to a central repository

If you have used Maven, then you will feel right at home with Lein. In fact, Lein even supports Maven repositories. A major difference between the two however is that the project file in Lein is written in Clojure itself while Maven uses XML (pom.xml).

I have to admit that Lein was a very welcome addition and although it is possible to develop in Clojure without it, it really makes several things much easier.

So I did the following in order to get the project skeleton:

```shell
$ lein new clojure-http-server
```

## Looking at IDE support

After I got the basic project structure in place, it was time to start editing code. As a long-time Eclipse user, the first thing I did was to search for an Eclipse plugin that handled Clojure. This would offer me syntax highlighting and code completion in my familiar workspace. That’s how I found the Eclipse plugin for Clojure called [CounterClockWise](https://github.com/ccw-ide/ccw/wiki/GoogleCodeHome). So I installed the plugin and created a new Clojure project in Eclipse.

While this was OK, I didn’t manage to import into Eclipse my existing Clojure project that I had created from the command line with Lein as described into the previous section. I expected the CounterClockWise plugin to function like the Maven Eclipse plugin where there is two-way interaction between the pom.xml and the Eclipse GUI.

So, in summary I expected more automatic integration between Lein and the Eclipse plugin.

I also looked at [Clooj](https://github.com/arthuredelstein/clooj), which is a lightweight IDE for Clojure developed in Clojure itself. While it is very easy to download and run it, I found it very lacking compared to Eclipse.

In the end I decided to develop in Clojure the hard way using just Lein from the command line and my trusty [GVIM](https://www.vim.org/download.php) as a text editor. I did this because I was very interested to see how Lein works in detail.

I did not find a built-in Clojure mode in Vim (an external plugin file exists), so I just used the Lisp mode which worked well for my needs.

## The Read Eval Print Loop (REPL)

Like most Functional languages, Clojure offers a command line shell where you can directly execute Clojure statements. This shell is very handy for development since it allows you not only to test small code snippets but also to run only parts of the program during development.

This is nothing new for developers who have already used languages like Python or Perl. But for Java developers its brings a refreshing and more interactive way to coding.

![Clojure REPL](../../assets/clojure-lein-docker/clojure-repl.png)

## Functional programming – a different way of thinking

Clojure is a functional language very similar to Lisp or Scheme. The functional paradigm is very different for those who are accustomed to the Java way of OOP and working with side effects all the time.

Functional programming promotes:

* Little or no side effects
* Functions that always return the same result if called with the same argument (and not methods that depend on the object state)
* No global variables
* Functions as first-order objects
* Lazy evaluation of expressions

These features are not particular to Clojure, but rather to functional programming in general:

```clojure
(defn send-html-response
 "Html response"
 [client-socket status title body]
 (let [html (str "<HTML><HEAD><TITLE>" title "</TITLE></HEAD><BODY>" body "</BODY></HTML>")]
  (send-http-response client-socket status "text/html" (.getBytes html "UTF-8"))
 ))
 ```

## Java Interoperability

Clojure offers excellent interoperability with Java libraries. In fact, for some basic classes Clojure does not even provide its own abstractions, instead you are expected to use the Java classes directly. In this HTTP server example, I borrow classes such as Readers and Writers from Java:

```clojure
(ns clojure-http-server.core
(:require [clojure.string])
(:import (java.net ServerSocket SocketException)
(java.util Date)
(java.io PrintWriter BufferedReader InputStreamReader BufferedOutputStream)))
```

Creating Java objects and calling them is very straightforward. There are actually two forms (as explained in this [excellent Clojure introduction](https://objectcomputing.com/resources/publications/sett/march-2009-clojure-functional-programming-for-the-jvm)):


```clojure
(def calendar (new GregorianCalendar 2008 Calendar/APRIL 16)) ; April 16, 2008
(def calendar (GregorianCalendar. 2008 Calendar/APRIL 16))
```

Calling methods:

```clojure
(. calendar add Calendar/MONTH 2)
(. calendar get Calendar/MONTH) ; -> 5
(.add calendar Calendar/MONTH 2)
(.get calendar Calendar/MONTH) ; -> 7
```

Here is an actual sample:

```clojure
(defn get-reader
"Create a Java reader from the input stream of the client socket"
[client-socket]
(new BufferedReader (new InputStreamReader (.getInputStream client-socket))))
```

However for some structures I decided to use the Clojure way. The original Java code uses [StringTokenizer](https://docs.oracle.com/javase/6/docs/api/java/util/StringTokenizer.html) which goes against the pure functional principle of immutable objects and no side effects. Calling the nextToken() method not only has side effects (since it modifies the Tokenizer object) but also returns a different result when called with the same (non-existing argument).

For this reason I used the [Split function of Clojure](https://clojuredocs.org/clojure.string/split) which is more “functional”:

```clojure
(defn process-request
"Parse the HTTP request and decide what to do"
[client-socket]
(let [reader (get-reader client-socket) first-line (.readLine reader) tokens (clojure.string/split first-line #"\s+")]
(let [http-method (clojure.string/upper-case (get tokens 0 "unknown"))]
(if (or (= http-method "GET") (= http-method "HEAD"))
(let [file-requested-name (get tokens 1 "not-existing")
[...]
```

## Concurrency

Clojure was designed with [concurrency](https://clojure.org/about/concurrent_programming) in mind from the beginning and not as an afterthought. It is very easy to write multi-threaded applications in Clojure since all functions implement by default the [Runnable](https://docs.oracle.com/javase/6/docs/api/java/lang/Runnable.html) and [Callable](https://docs.oracle.com/javase/6/docs/api/java/util/concurrent/Callable.html) interfaces from Java allowing any method to run into a different thread on its own.

Clojure also provides other constructs specifically for concurrency, such as [atoms](https://clojure.org/reference/atoms) and [agents](https://clojure.org/reference/agents), but I didn’t use them in my HTTP server example, preferring instead the familiar Java Threads.

```clojure
(defn new-worker
"Spawn a new thread"
[client-socket]
(.start (new Thread (fn [] (respond-to-client client-socket)))))
```

## Order of methods matters

One thing that I noticed is that the order of methods inside the source file is critical. Functions must be defined before they are first used. Alternatively, you can use the [declare special form](https://clojuredocs.org/clojure.core/declare) to use a function before its actual definition. This reminded me of the C/C++ way of doing things, with header files and function declarations.

## Creating a Docker container for Clojure

The application is ready to be executed. This can be done very simply with `lein run`. This command however requires that you jave a full Java/Clojure development environment.
We can instead package the application to a Docker container.

We use [multi-stage builds](https://docs.docker.com/build/building/multi-stage/) to create a minimal image with just the final executable and not the whole development environment. Here is the [Dockerfile](https://github.com/kkapelon/clojure-http-server/blob/master/Dockerfile):

```dockerfile
FROM clojure:lein-2.9.1 AS LEIN_TOOL_CHAIN
COPY . /tmp/app-src/
WORKDIR /tmp/app-src/
RUN lein uberjar

FROM eclipse-temurin:11-jre-alpine

EXPOSE 8080

RUN apk add --no-cache ca-certificates bash

RUN mkdir /app

COPY index.html /app
COPY --from=LEIN_TOOL_CHAIN /tmp/app-src/target/uberjar/clojure-http-server.jar /app/clojure-http-server.jar

WORKDIR /app

CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","./clojure-http-server.jar"]
```

The build does the following 

1. Starts from a Docker image that contains Clojure and Lein
1. Creates an executable jar that holds the application
1. Discards the Clojure image and starts from a new one that has only the JRE
1. Copies the created Jar file to the new image
1. Runs it

The gains in size are very important. The Clojure development image is about 650 MB while the JRE Alpine image is about 150 MB

The resulting image can be executed like any other Docker image:

```shell
docker build . -t my-app
docker run -p 8080:8080 my-app
```

## Conclusion

Clojure offers a great platform for those looking for a functional language running on the JVM. Developers with experience in Lisp/Scheme will feel right at home. However Java developers will not only face a new syntax but also a new paradigm.

Although it would be possible to abuse Clojure and write code in a Java-like way, this is not optimal. The big strength of Clojure can be found in the concurrency constructs which could be handy in the future as more programmers are interested in parallelization of their code.

P.S. There is also [ClojureCLR](https://github.com/clojure/clojure-clr) for .NET development and [ClojureScript](https://github.com/clojure/clojurescript) which might be of interest to you.

_This post was originally published at the [JRebel/Zeroturnaround blog](https://www.jrebel.com/). Reposting here since it is not available there any more._