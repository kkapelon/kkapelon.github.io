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
 * [The Test Pyramid](https://martinfowler.com/bliki/TestPyramid.html) (Martin Fowler 2012)
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

In the end, the number of integration tests will be much smaller than the number of unit tests (matching the shape of the test pyramid described in the first section of this article).



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


#### Integration tests are harder to debug than unit tests

The last reason why having only integration tests (without any unit tests) is an anti-pattern is the amount of time spent to debug a failed test. Since an integration test is testing multiple software components (by definition), when it breaks, the failure can come from *any* of the tested components. Pinpointing the problem can be a hard task depending on the number of components involved.

When an integration tests fails you need to be able to understand why it failed and how to fix it. The complexity and breadth of integration tests make them extremely difficult to debug. Again, as an example let's say that your application only has integration tests. The application you are developing is the typical e-shop.

A developer in your team (or even you) creates a new commit, which triggers the integration tests with the following result:

![breakage of integration tests](../../assets/testing-anti-patterns/integration-tests-break.png)


As a developer you look at the test result and see that the integration test named "Customer buys item" is broken. In the context of an e-shop application this is not very helpful. There are many reasons why this test might be broken. 

There is no way 
to know why the test broke without diving into the logs and metrics of the test environment (assuming that they can pinpoint the problem). In several cases (and more complex applications) the only way
to truly debug an integration test is to checkout the code, recreate the test environment locally, then run the integration tests and see it fail in the local developmenet environment.

Now imagine that you work with Mary on this application so you have both integration and unit tests. Your team makes some commits, you run all the tests and get the following:

![breakage of both kinds of tests](../../assets/testing-anti-patterns/both-tests-break.png)

Now two tests are broken:

* "Customer buys item" is broken as before (integration test)
* "Special discount test" is also broken (unit test)

It is now very easy to see the pattern. You can go directly to the source code of the *Discount* functionality, locate the bug and fix it and in 99% of the cases the integration
test will be fixed as well. 

Having unit tests break *before* or *with* integration tests is a much more painless process when you need to locate a bug.

##### Quick summary of why you need integration tests

This is the longest section of this article, but I consider it very important. In summary while *in theory* you could only have integration tests, *in practice*

1. Unit tests are easier to maintain 
1. Unit tests can easily replicate corner cases and not-so-freqent scenario
1. Unit tests run much faster than integration tests
1. Broken unit tests are easier to fix than broken integration tests

If you only have integration tests, you waste developer time and company money.


### Anti-Pattern 3 - Having the wrong kind of tests

Now that we have seen why we need both kinds of tests (unit *and* integration), we need to decide on *how many* tests we need from each category.

There is no hard and fast rule here, it depends on your application. The imporant point is that you need to spend some time to understand what type of tests
add the most value to *your* application. The test pyramid is only a suggestion on the amount
of tests that you should create. It assumes that you are writing a commercial web application, but that is not always the case. Let's see some examples:


#### Example - Linux command line utility

Your application is a command line utility. It reads one special format of a file (let's say a CSV) and exports another format (let's say JSON) after doing some transformations.
The application is self-contained, does not communicate with any other system or use the network. The transformations are complex mathematical processes that are critical for
the correct functionality of the application (it should always be correct even if it slow).

In this contrived example you would need:

* Lots and lots of unit tests for the mathematical equations. 
* Some integration tests for the CSV reading and JSON writing
* No UI tests because there is no UI.

Here is the breakdown of tests for this project:

![Test pyramid example](../../assets/testing-anti-patterns/pyramid1.png)

Unit tests dominate in this example and the shape is **not** a pyramid.


#### Example - Payment Management

You are adding a new application that will be inserted into an existing big collection of enterprise systems. The application is a payment gateway that processes payment information
for an external system. This new application should keep a log of all transactions to an external DB, it should communicate with external payment providers (e.g. Paypal, Stripe, WorldPay) and
it should also send payment details to another system that prepares invoices.

In this contrived example you would need

* Almost no unit tests because there is no business logic
* Lots and lots of integration tests for the external communications, the db storage, the invoice system
* No UI Tests because there is a no UI

Here is the breakdown of tests for this project:

![Test pyramid example](../../assets/testing-anti-patterns/pyramid2.png)

Integrations tests dominate in this example and the shape is **not** a pyramid.

#### Example - Website creator

You are working on this brand new startup that will revolutionize the way people create websites, by offering a one-of-a-kind way to create web applications from 
within the browser. 

The application is a graphical designer with a toolbox of all the possible HTML elements that can be added on a web page along with  library of premade templates. There is also
the ability to get new templates from a marketplace. The website creator works in a very friendly way by allowing you to drag and drop components on the page, resize them,
edit their properties and change their colours and appearance.

In this contrived example you would need

* Almost no unit tests because there is no business logic
* Some integration tests for the marketplace
* Lots and lots of UI tests that make sure the user experience is as advertised

Here is the breakdown of tests for this project:

![Test pyramid example](../../assets/testing-anti-patterns/pyramid3.png)

UI tests dominate here and the shape is **not** a pyramid.

I used some extreme examples to illustrate the point that you need to understand what your application needs and focus only on the tests
that give you value. I have personally seen "payment management" applications with no integration tests and "website creator" applications with no UI test.

There are several articles on the web (I am not going to link them) that talk about a specific amount on integration/unit/UI tests that you need or don't need. All
these articles are based on assumptions that may *not* be true in your case.

### Anti-Pattern 4 - Testing the wrong functionality

In the previous sections we have outlined the types and amount of tests you need to have for your application. The next logical step is to explain what functionality 
you actually need to test.

In theory, getting 100% code coverage in an application is the ultimate goal. In practice this goal is not only difficult to achieve but also it doesn't guarantee a bug free application.

There are some cases where indeed it is possible to test *all* functionality of your application. If you start on a green-field project, if you work in a small team that is well
behaved and takes into account the effort required for tests, if it perfectly fine to write new tests for all new functionality you add (because the existing code already has tests).

But not all developers are lucky like this. In most cases you inherit an existing application that has a minimal amount of tests (or even none!). If you are part of a big and established company, working with legacy code is mostly the rule rather than the exception. 

Ideally you would have enough development time to write tests for both new and existing code for a legacy application. This is a romantic idea that will probably be rejected
by the average project manager who is mostly interested on adding new features rather then testing/refactoring. You have to pick your battles and find a fine balance between adding new functionality (as requested by the business) and expanding the existing test suite.

So what do you test? Where do you focus your efforts? Several times I have seen developers wasting valuable testing time by writing "unit tests" that add little or no value to the overall stability of the application. The canonical example of useless testing is trivial tests that verify the application data model.

Code coverage is analyzed in detail in its own anti-pattern section. In the present section however we will talk about code "severity" and how it relates to your tests. 

If you ask any developer to show you the source code of any application, he/she will probably open an IDE or code repository browser and show you the invididual folders.

![Source code physical model](../../assets/testing-anti-patterns/source-code-physical.png)

This representation is the physical model of the code. It defines the folders in the filesystem that contain the source code. While this hierachy of folders is great for working with the code itself, unfortunately it doesn't define the importance of each code folder. A flat list of code folders implies that all code components contained in them are of equal importance. 

This is not true as different code components have a different impact in the overall functionality of the application. As a quick example let's say that you are writing an eshop application and two bugs appear in production:

1. Customers cannot check-out their cart halting all sales
1. Customers get wrong recommendations when they browse products.

Even though both bugs should be fixed, it is obvious that the first one has higher priority. Therefore if you inherit an eshop application with zero tests, you should write new tests the directly validate the check-out functionality rather than the recommendation engine. So even though the recomendation engine and the check-out process might exist on sibling folders in the filesystem, their importance is different when it comes to testing.

To generalize this example, if you work for some time in any medium/large application you will soon need to think about code using a different representation - the mental model.

![Source code mental model](../../assets/testing-anti-patterns/code-mental-model.png)

I am showing here 3 layers of code, but depending on the size of your application it might have more. These are:

1. Critical code - This is the code that breaks often, gets most of new features and has a big impact on application users
1. Core code - This is the code that breaks sometimes, gets few new features and has medium impact on the application users
1. Other code - This is code that rarely changes, rarely gets new features and has minimul impact on application users.


This mental mode should be your guiding principle whenever you write a new unit test. Ask yourself if the functionality you are writing tests for now belongs to the *critical* or *core* categories.
If yes, then write a unit test. If no, then maybe your development time should better be spent elseware (e.g. in another bug).

The concept of having code with different severity categories is also great when you need to answer the age old question of how much code coverage is enough for an application. To answer this question you need to either know the severity layers of the application or ask somebody that does. Once you have this information at hand the answer is obvious:

Try to write tests that work towards 100% coverage **of critical code**. If you have already done this, then try to write tests that work towards 100% **of core code**.

The important thing to notice here is that the critical code in an application is always a small subset of the overall code. So if in an application critical code is let's say 20% of
the overall code, then getting just 20% overall code coverage is a good first step for reducing bugs in production. 

In summary, write unit and integration tests for code that

* breaks often
* changes often
* is critical to the business

If you have the time luxury to further expand the test suite, make sure that you understand the diminishing returns before wasting time on tests with little or no value.





### Anti-Pattern 5 - Testing internal implementation

More tests are always a good thing. Right? 

Wrong! You also need to make sure that the tests are actually structured in a correct way. Having tests that are written in the wrong manner is bad in two ways. 

* They waste precious development time the first time they are written
* They waste even more time when they need to be refactored (when a new feature is added)

Strictly speaking, test code is like any other type of code. You will need to refactor it as some point in order to improve it in a gradual way. But if you find yourself routinely
changing existing tests just to make them pass when a new feature is added then *your tests are are not testing what they should be testing*

I have seen several companies that started new projects and thinking that they will get it right it this time, they started writing a big number of tests to cover the functionality
of the application. After a while, a new feature got added and several existing tests needed to change in order to make them pass again. Soon the amount of effort spent fixing
the existing tests was actually larger than the time needed to implement the feature itself.

In such situations, several developers just accept defeat. They declare software tests a waste of time and abandon completely the existing test suite in order to focus fully on new features.
In some extreme scenarios some changes might even be held back because of the amount of tests that break.
Unfortunately, you need some basic testing experience to understand which tests are written in the "wrong" way. 

Having to change a big number of existing tests when a new feature is introduced shows the *symptom*. The actual problem is that tests were instructed to verify internal implementation which is
always a recipe for disaster. There are several software testing resources online that attempt to explain this concept, but very few of them show some solid examples.


I promised in the begining of this article that I will not speak about a particular programming language and I intend to keep that promise. In this section the illustrations
show the data structure of your favourite programming language. Think of them as structs/objects/classes that contain fields/values. 

Let's say that the customer object in an e-shop application is the following:

![Tight coupling of tests](../../assets/testing-anti-patterns/coupled-testing.png)

The customer type has only two values where `0` means "guest user" and `1` means "registered user". Developers look at the object and write 10 unit tests that verify various cases of guests users and 10 cases of registered user. And when I say "verify" I mean that tests **are looking at this particular field in this particular object**.

Time passes by and business decides that a new customer type with value `2` is needed for affiliates. Developers add 10 more tests that deal with affiliates. Finally another type of user called "premium customer"
is added and developers add 10 more tests. 

At this point, we have 40 tests in 4 categories that all look at this particular field.
(These numbers are imaginary. This contrived example exists only for demonstration purposes. In a real project you might have 10 interconnected fields within 6 nested objects and 200 tests).

![Tight coupling of tests example](../../assets/testing-anti-patterns/coupled-testing-example.png)

If you are a seasoned developer you can always imagine what happens next. New requirements come that say:

1. For registered users, their email should also be stored
1. For affiliate users, their company should also be stored
1. Premium users can now gather reward points.

The customer object now changes as below:



![Tight coupling of tests broken](../../assets/testing-anti-patterns/coupled-testing-broken.png)

You now have 4 objects connected with foreign keys and all 40 tests are instantly broken because the field they were checking no longer exists. 

*Of course in this trivial example 
one could simply keep the existing field to not break backwards compatibility with tests*. In a real application this is not always possible. Sometimes backwards compatibility might essentially
mean that you need to keep both old and new code (before/after the new feature) resulting in a huge bloat. Also notice that having to keep old code around just to make unit tests pass is a huge anti-pattern on its own.

In a real application when this happens, developers ask from management some extra time to fix the tests. Project managers then declare that unit testing is a waste of time because they seem to hinder new features. The whole team then abandons the test suite by quickly disabling the failing tests.

The big problem here is not testing, but instead the way the tests were constructed. Instead of testing internal implementation they should instead expected behaviour. In our simple example
instead of testing directly the internal structure of the customer they should instead check the exact business requirement of each case. Here is how these same tests should be handled instead.

![Tests that test behaviour](../../assets/testing-anti-patterns/coupled-testing-fixed.png)


The tests do not really care about the internal structure of the customer object. They only care about its interactions with other objects/methods/functions. The other objects/method/functions should be mocked when needed
on a case to case basis. Notice that each type of tests directly maps to a business need rather than a technical implementation (which is always a good practice.)

If the internal implementation of the *Customer* object changes, the verification code of the tests remains the same. The only thing that might change is the setup code for each test, which should be centralized in a single helper function called `createSampleCustomer()` or something similar (more on this in [AntiPattern 9](AntiPattern 9))

Of course in theory it is possible for the verified objects themselves to change. In practice it is not realistic for changes to happen at `loginAsGuest()` *and* `register()` *and* `showAffiliateSales()` *and* `getPremiumDiscount()` **at the same time**. In a realistic scenario you would have to refactor 10 tests instead of 40.


In summary, if you find yourself continuously fixing existing tests as you add new features, it means that your tests are tighlty coupled to internal implementation.

### Anti-Pattern 6 - Paying excessive attention to test coverage

Code coverage is a favourite metric among software stakeholders. [Endless discussions](https://softwareengineering.stackexchange.com/questions/1380/how-much-code-coverage-is-enough) [have](https://martinfowler.com/bliki/TestCoverage.html) [happened](https://testing.googleblog.com/2010/07/code-coverage-goal-80-and-no-less.html) (and will continue to happen) among developers and project managers on the amount of code coverage a project needs.

The reason why everybody likes to talk about code coverage is because it is a metric that is easy to understand and quantify. There are several easily accessible tools that output this metric for most programming languages and test frameworks. 

*Let me tell you a little secret:* Code coverage is completely useless as a metric. I am not going to even give you a number on how much code coverage your project needs. This is a trap question. You can have a project with 100% code coverage that still has bugs and problems. The real metrics
that you should monitor are the well-known CTM. 

##### The Codepipes Testing Metrics (CTM)

Here is their definition if you have never seen them before:


|  Metric Name  | Description | Ideal value | Usual value | Problematic value |
| -------------      |-------------| -----   |       -----|    -----|
| PDWT | % of Developers writing tests        |   100%      |  20%-70%    |   Anything less than 100% |
| PBCNT | % of bugs that create new tests          |   100%       |  0%-5%    |   Anything less than 100% |
| PTVB | % of tests that verify behaviour       |   100%       |  10%   |   Anything less than 100% |
| PTD | % of tests that are deterministic       |   100%       |  50%-80%    |   Anything less than 100% |



**PDWT** (Percent of Developers who Write Tests) is probably the most imporant metric of all. There is no point in talking about software testing anti-patterns if you have zero tests in the first place. All developers in the team should write tests. A new feature should be declared *done* only when it is accompanied by one or more tests. 

**PBCNT** (Percent of Bugs that Create New tests). Every bug that slips into production is a great excuse for writing a new software test that verifies the respective fix. A bug that appears in production should only appear once. If your project suffers from bugs that appear multiple times in production even after their original "fix", then your team will really benefit from this metric. More details on this topic in [Antipattern X].

**PTVB** (Percent of Tests that Verify Behaviour and not implementation). Tightly coupled tests are a huge time sink when the main code is refactored. This topic was already discussed in [Antipattern X].

**PTD** (Percent of Tests that are Determistic to total tests). Tests should only fail when something is wrong with the business code. Having tests that fail intermittently for no apparent reason is a huge problem that is discussed in [Antipattern X].


























