---
layout: post
title: Deploying a GO application to Google Cloud via Docker and Semaphore CI
category: containers
---

### Introduction

In this tutorial we will deploy a sample application (written in the [GO programming language](https://golang.org/)) to Google Cloud.
We will package our application using Docker in order to make the final deployment as close as possible to the development environment.


### Prerequisites ###

For this tutorial we will need

* A [Docker](https://www.docker.com) installation
* An account for [Semaphore CI](semaphoreci.com) (free registration required)
* An account for [Google cloud](https://cloud.google.com/) (free registration required)
* Our favourite text editor and command line terminal to edit all related files

#### Note regarding docker on Windows

For this article I am using Docker on Windows. The recommended way to run Docker on Windows (or even Mac) is via [the Docker toolbox](https://www.docker.com/products/docker-toolbox).
The Docker toolbox creates a "normal" VM on Windows and then runs the Docker engine on top giving you access to containers.
This means that things are a bit more complicated as Docker does NOT run on localhost (as it would be expected
	on a Linux installation)

You might see some slightly different screenshots on your system if you use Linux but the basic concepts are the same.


#### Source code for this article

You can find the source code mentioned in this article on [Github](https://github.com/kkapelon/go-docker-semaphore-gcloud). You can follow
along either by creating a repository on your own and typing the source files yourself, or by simple cloning this repository to have
everything ready.


### Step 1 - Creating the Go application

First we will create our GO application. For the purposes of this tutorial we will start with a really trivial web
server that prints a hello message (plain text) when accessed on port 8080. Here is the complete GO file named `trivial-web-server.go`:

{% highlight go %}
package main

import (
	"fmt"
	"net/http"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "I am a GO application running on Google Cloud.")

}

func main() {
	fmt.Println("Basic web server is starting on port 8080...")
	http.HandleFunc("/", indexHandler)
	http.ListenAndServe(":8080", nil)
}

{% endhighlight %}

For the rest of this tutorial we will mention **[WORKDIR]** as the root directory of our project. Choose any location that you see fit
on your workstation for this directory

Place the GO source file into **[WORKDIR]/src/sample** as per GO guidelines. You can choose any other name instead of `sample` if you like.
We also create the folder `[WORKDIR]/bin` that will hold the compiled binary.

#### Running the GO application via Docker

We need to run our GO application at least once to verify that it is working correctly. Of course we could install
the GO development tools locally and run the application directly on our workstation. But this would beat one of
the main objectives of Docker - having the same environment during development and during deployment.

Therefore we will instead run our application in a Docker container that will have the GO runtime installed.
At the time of writing the current official Docker image for GO is [golang:1.7.1](https://hub.docker.com/_/golang/).
We will therefore launch it on our Docker engine and compile/run our sample Web application

This image comes with the directories `go/src` and `go/bin` that already mirror our source code structure.

{% highlight shell %}
$ docker run -v /[WORKDIR]:/go -it -p 8080:8080 golang:1.7.1
root@05f0b7a68683:/go# ls src/sample
trivial-web-server.go
root@05f0b7a68683:/go#
{% endhighlight %}

The docker command runs a Docker instance of image golang:1.7.1, exposes port 8080 to the Docker host (or VM if you use Windows/Mac) and gives
us an interactive terminal inside the container. We also mount the folder that contains our source inside the running container. To verify
that the source code is available we run the ls command.

So now we have a Linux environment with the GO runtime available and with access to the source code. We compile and run our code:

{% highlight shell %}
root@05f0b7a68683:/go# go install sample
root@05f0b7a68683:/go# ls -l bin
total 5557
-rwxrwxrwx 1 1000 staff 5689610 Sep 21 22:15 sample
root@05f0b7a68683:/go# ./bin/sample
Basic web server is starting on port 8080...
{% endhighlight %}

Success! Our code is now compiled and runs as expected. To verify it really runs on port 8080 we can use our browser. If you use Docker on Linux
you can visit the localhost port directly. For Windows we need the VM ip that should be available if you run `docker-machine ls` on your terminal.

Here is the application running.

![Adding a project to CircleCI](../../assets/go-docker-gcloud/local-docker-url.png)

Now we are ready to create a Docker image of our application.

### Step 2 - Packaging manually the application into a Docker image

Exit the container by pressing `Ctrl-C` and then `Ctrl-D` to get back to the Docker host prompt.

{% highlight shell %}
root@05f0b7a68683:/go# bin/sample
Basic web server is starting on port 8080...
^C
root@05f0b7a68683:/go# exit
$ ls bin/sample
bin/sample
{% endhighlight %}

Because we mounted the parent directory of `bin` we now have the GO binary intact left on the Docker host even though the container that compiled it is no
longer active.

The next step is to package this binary into a Docker image. We will use the same GO image we used for compiling, which will assure the correct
functionality of our application when it gets deployed to production.

We create the following Dockerfile at the `WORKDIR` directory. As you can see it just takes the GO binary and runs it.

{% highlight docker %}
FROM golang:1.7.1
COPY bin/sample /go/bin
EXPOSE 8080
CMD ["/go/bin/sample"]
{% endhighlight %}

To verify the docker build we create a sample image and run it:

{% highlight shell %}
$ docker build -t my-sample-image .
Sending build context to Docker daemon 5.772 MB
Step 1 : FROM golang:1.7.1
 ---> 002b233310bb
Step 2 : COPY bin/sample /go/bin
 ---> Using cache
 ---> 2eada3013b42
Step 3 : EXPOSE 8080
 ---> Using cache
 ---> f6bf1285d5a2
Step 4 : CMD /go/bin/sample
 ---> Using cache
 ---> 87d168345b83
Successfully built 87d168345b83

$ docker run -p 8080:8080 my-sample-image
Basic web server is starting on port 8080...
{% endhighlight %}

The application should again be available on our browser as before.

### Step 3 - Using Semaphore CI to automate the build process
