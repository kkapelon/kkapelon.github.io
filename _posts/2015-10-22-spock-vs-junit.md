---
layout: post
title: Spock testing framework versus JUnit 
category: spock
---

[Spock](http://spockframework.org) is the newcomer in the test arena. The king of the arena is of course JUnit.
Even though JUnit has served us well for the last 15 years, its age is starting to show. Spock comes with several fresh
ideas that vastly improve unit testing. 

In this post I will summarize 5 big differences between the two frameworks so that you can draw your own conclusions.
If you wish to see more details about Spock, consult its [official documentation](http://docs.spockframework.org).

### 1. Spock enforces a clear test structure ###

The number one reason for using Spock is to make your tests more readable. This may not seem important to you
if you are just working on small projects created over the weekend. For big enterprise projects however test readability
is a crucial factor when it comes to working on existing code.

#### JUnit tests lack formal semantics ####

If you look at any good JUnit test you will see a pattern in its structure. The structure is the well known [arrange-act-assert](http://c2.com/cgi/wiki?ArrangeActAssert) pattern that clearly splits the test into three phases:

{% highlight java %}
@Test
public void chargeCreditCard() {
    CreditCardBilling billing = new CreditCardBilling();
    Client client = new Client();
    billing.charge(client,150);
    assertEquals("Revenue should be recorded",150,billing.getCurrentRevenue());
}
{% endhighlight %}

The *arrange* phase sets up the needed classes. In the example above the first two statements are that phase (a client and a billing service are initiliazed)

The *act* is the trigger of the test. This phase should call the method(s) of the [Subject under test](http://xunitpatterns.com/SUT.html). In our case
that subject is the billing service. The trigger is the charge of 150 dollars.

The *assert* phase is the final one. It checks the actual result of the trigger with the one we expect. If they match the test succeeds. Otherwise
the test fails.

#### The arrange-act-assert structure is only present if developers account for it ####

The example above is very simple so all three phases are instantly visible. One could improve the test even further by using blank lines as bellow:

{% highlight java %}
@Test
public void chargeCreditCard() {
    CreditCardBilling billing = new CreditCardBilling();
    Client client = new Client();

    billing.charge(client,150);

    assertEquals("Revenue should be recorded",150,billing.getCurrentRevenue());
}
{% endhighlight %}

However in really big tests, these phases are not always evident. Imagine a large JUnit test with complex business logic. Seasoned developers
will still demarkate the phase with comments in order to improve readability:

{% highlight java %}
@Test
public void veryComplexLoanApprovalScenario() {
    //Prepare loan request and client details
    [...lots of statements here...]

    //Customer asks for a loan
    [...lots of statements here...]

    //Check that loan was approved
    [...lots of assert statements here...]
}
{% endhighlight %}

The usage of comments certainly makes the test more readable but this technique is far from ideal. First of all big JUnit tests are an anti-pattern and should
be refactored using private methods that correspond to business needs. Secondly, not all developers put comments, and those comments are only accessible to programmers.
(i.e. they never appear on test reports).

#### Spock tests make the arrange-act-assert structure explicit ####

Let's rewrite the first unit test with Spock:

{% highlight groovy %}
public void "charging a credit card - happy path"() {

    given: "a billing service and a customer with a valid credit card"
    CreditCardBilling billing = new CreditCardBilling();
    Client client = new Client();

    when: "client buys something with 150 dollars"
    billing.charge(client,150);

    then: "we expect the transaction to be recorded"
    billing.getCurrentRevenue() == 150
}
{% endhighlight %}

Even though this code is Groovy, I have kept it as close to Java as possible. The first thing you will notice
is that the name of the method is full English text that clearly describes the test (more on this later). The second
thing that you should notice is the set of given-when-then labels that split the code intro three parts.

It should be obvious that these blocks are directly mapped to the arrange-act-assert part of JUnit.
The statements in the *given* block are the *arrange* phase, those in the *when* block correspond
to the *act* phase, and the *assert* phase is handled by the *then* block in Spock.

There are two big advantages of Spock labels against using plain comments (like the JUnit example)

1. The Spock labels are full English text that also appear on test reports (more on this later)
2. The Spock labels have also semantic value

The second point is best illustrated with a *bad* example.

#### In JUnit test the arrange-act-assert pattern is implied ####

Let's assume that a naughty Java developer modifies the JUnit test as below:

{% highlight java %}
@Test
public void chargeCreditCard() {
    CreditCardBilling billing = new CreditCardBilling();
    Client client = new Client();

    billing.charge(client,150);
	    
    assertEquals("Revenue should be recorded",150,billing.getCurrentRevenue());
	    
    Client client2 = new Client();
    billing.charge(client2,100);
    assertEquals("Revenue should be recorded",250,billing.getCurrentRevenue());
}
{% endhighlight %}

This test is badly designed. The arrange-act-assert pattern has been broken. In this simple test, it is easy
to understand what has happened. But in bigger tests the addition of extra asserts and setup statements
makes the test very hard to read.

#### Spock can keep the test structure very clear ####

Spock has several other blocks apart from the basic given-when-then. They can be used
to keep the structure of the test clear.

The naughty developer would not modify the Spock test in a similar way. Instead a better Spock test
would be the following:

{% highlight groovy %}
public void "charging a credit card - two transactions"() {
    given: "a billing service ready to accept payments"
    CreditCardBilling billing = new CreditCardBilling();
		
    and: "two customers with valid credit cards"
    Client client1 = new Client();
    Client client2 = new Client();

    when: "first client buys something with 150 dollars"
    billing.charge(client1,150);

    then: "we expect the transaction to be recorded"
    billing.getCurrentRevenue() == 150
		
    when: "second client buys something with 100 dollars"
    billing.charge(client2,100);

    then: "we expect the transaction to be recorded"
    billing.getCurrentRevenue() == 250
}
{% endhighlight %}

Here I have used the *and* block to merge the two *arrange* phases. Also the *when* and *then* blocks
make the test have a natural reading flow. Just by reading the block names (given-and-when-then-when-then) one
gets a good idea of what the test does.


### 2. Spock is much more helpful when tests fail ###

This is the killer feature of Spock that played a pivotal role on its adoption on my own projects.

>Never trust a test you haven't seen fail
> 
>--Colin Vipurs

 The primary purpose of unit tests it to catch regression errors. This happens when a test that passed in the previous build, fails in the current build. It might
 seem counterintuitive but you *want* your tests to fail. A test that fails is a test that works.

#### Failures in JUnit tests always need a debugger ####


 Unfortunately a failed JUnit test is usually the start of a debugging session as the information given in case of a failure is very basic. Here
 is a contrived example:

{% highlight java %}
@Test
public void similarBooks() {
    Book book = new Book("The Murder on the Links");
    List<String> similar = book.findSimilarTitles();

    assertEquals("Murder on the Orient Express",similar.get(0));
}
{% endhighlight %}

Let's say that the latest build of your project fails. You checkout the code locally, run all tests
and get the following: 

![JUnit failed test](../../assets/spock-vs-junit/junit-fail.png)

Just looking at this failure is not very helpful. You know which test has failed, but it is hard to understand
*how* to fix the failure. In this example you need to run the test in a debugger to understand why you get
a different value instead of the one expected.

#### Spock provides you with the surrounding context ####

Let's say that you rewrite the same test with Spock:

{% highlight groovy %}
public void "find books with similar titles"() {
    given: "A book that contains the word murder"
    Book book = new Book("The Murder on the Links")
		
    when: "we search similar books"
    List<String> similar = book.findSimilarTitles()

    then: "similar books should have murder in the title"
    similar.get(0) == "Murder on the Orient Express"
}
{% endhighlight %}

The test fails of course, but this time you get the following:

![Spock failed test](../../assets/spock-vs-junit/spock-fail.png)


Unlike JUnit, Spock knows the context of the failure. In this case Spock shows you the contents of the whole list of similar books.
Just by looking at the failed test you see that book title you search for, is indeed in the list but in the second position. The test
expects the value in the first position and thus fails.

Now you know that the code fails because of an index change (or code that changes the order of similar books). Armed with this knowledge you 
quickly pinpoint the problem in a much faster way. 

### 3. Spock tests are readable by non technical people ####

Naming of unit tests is a big problem in Enterprise applications. Developers usually think in technical terms never really
showing any respect on how reports from tests are generated.

>There are only two hard things in Computer Science: cache invalidation and naming things.
>
>-- Phil Karlton

#### Methods names in JUnit are constrained by Java conventions.

The classic mistake here is unit tests that really say nothing in their title. Here is a particularly bad example:

![Bad JUnit test titles](../../assets/spock-vs-junit/badtest.png)

The problem with this naming "scheme" is that it is not helpful for people who do not have the code in front of them. If the test named "scenario2" fails
for some reason, nobody but the developer can understand its impact.

Seasoned Java developers attempt to name their unit tests with their true purpose. This is obviously better but still not perfect
as they are constrained to the camel case (or underscore) format of the Java language:

![Better JUnit test titles](../../assets/spock-vs-junit/better-junit-naming.png)


#### Spock supports plain English sentences

The beauty of Spock tests, is the ability to enter full English descriptions in the method names (already
showcased in the code examples in the previous sections)

Maven (and any other JUnit related tools) will format them with no extra configuration:

![Spock test titles](../../assets/spock-vs-junit/spock-surefire-report.png)

However Spock can take this report a step further. Spock has its own [reports module](https://github.com/renatoathaydes/spock-reports) 
that shows in the reports all text contained in the Spock blocks (i.e given, when, then).
The result if the following:

![Spock reports](../../assets/spock-vs-junit/spock-reports.png)

This is massive improvement in the readability of Spock tests. Non-technical people can see this report and take proper decisions
without actually knowing how Java works.

* _Testers_ can read Spock tests and compare them against their own test cases
* _Business analysts_ can read Spock tests and verify that they reflect the specifications of the system
* _Projects managers_ can read Spock reports and understand the status of the system. They can instantly decide
if a failed test has high or low impact.


### 4. Spock has a custom DSL for parameterized tests ###

A very common anti-pattern in JUnit tests, is a series of tests that are 99.9% same where only some variables really
change. Here is an example:

{% highlight java %}
@Test
public void acceptJpg() {
    ImageNameValidator validator = new ImageNameValidator();
    String pictureFile = "scenery.jpg";
		
    assertTrue(validator.isValidImageExtension(pictureFile));
}

@Test	
public void acceptJpeg() {
    ImageNameValidator validator = new ImageNameValidator();
    String pictureFile = "house.jpeg";
		
    assertTrue(validator.isValidImageExtension(pictureFile));
}

@Test	
public void doNotAcceptTiff() {
    ImageNameValidator validator = new ImageNameValidator();
    String pictureFile = "sky.tiff";
		
    assertFalse(validator.isValidImageExtension(pictureFile));
}

{% endhighlight %}

Those JUnit tests are clearly not [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) as they share a lot of common code. Actually all of them share the same test logic
(pass an image to the ImageValidator class) and the only thing that changes is the filename and the expected result.

This is a better illustration of the similarity of these tests:

![parameterized code sharing](../../assets/spock-vs-junit/parameterized.png)

This type of tests are called _parameterized_ tests because they share they same test logic and all scenarios depend
on different parameters passed to that test logic.

Parameterized test with JUnit are possible, but the resulting syntax is certainly ugly. I challenge you 
to read the [official documentation of JUnit](https://github.com/junit-team/junit4/wiki/parameterized-tests). I will wait
for you to come back.

If you have never seen the approach of JUnit for parameterized tests, do not worry. It should be clear that:

1. it requires a custom runner (`@RunWith(Parameterized.class)`)
1. the test class must be polluted with fields that represent inputs
1. the test class must be polluted with fields that represent outputs
1. a special constructor is needed for all inputs and outputs
1. test data comes into a two dimensional object array (which is converted to a list)
1. test data and test descriptions are in different placed
1. you cannot easily use two tests in the same class.

Essentially the "solution" offered by JUnit is more trouble than its worth and this is why so many Java developers
are not aware of JUnit parameterized tests.

I know that there are external libraries that augment the way JUnit handles parameterized tests, but their existence
further enforces my argument that Spock is batteries-included unlike JUnit.

Spock can instead offer data tables that present the unit test in a much more understandable manner. Powered
by its Groovy DSL it allows you to keep together data and its description in a tabular format:

{% highlight groovy %}
public void "Valid images are PNG and JPEG files"() {
        given: "an image extension checker"
        ImageNameValidator validator = new ImageNameValidator()

        expect: "that only valid filenames are accepted"
        validator.isValidImageExtension(pictureFile) == validPicture

        where: "sample image names are"
        pictureFile        || validPicture
        "scenery.jpg"      || true
        "house.jpeg"       || true
        "car.png"          || true
        "sky.tiff"         || false
        "dance_bunny.gif"  || false
}

{% endhighlight %}

A single test method is shown, but if you run it you will get multiple executions (one for each l)




### 5. Spock has built-in mocking and stubbing capabilities ###

To be written


### Conclusion

This was just a small selection of cases where Spock makes your tests better. Even if you are a diehard JUnit fan, you should acknowledge the advantages of Spock
and what it means for your unit tests.

You can also get the PDF slides of my [presentation for Spock versus JUnit](http://codepipes.com/presentations/spock-vs-junit.pdf).

 

