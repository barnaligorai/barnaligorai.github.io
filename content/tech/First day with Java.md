---
title: "First Day With Java"
date: 2022-09-01T22:45:15+05:30
featured_image: '../images/tech_cover.jpeg'
description: "Learn JAVA"
draft: false
tags:
  - Tech
  - Java
---
# Java
Java is a high-level, class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible.

At first, Java code goes through compilation process. Java code is compiled into byte code. Then byte code is ran by JVM (Java Virtual Machine). JVM along with System Library makes JRE (Java Runtime Environment). The compiler along with the JRE makes JDK (Java Development Kit).

JRE stands for 'Java Runtime Environment' and may also be written as 'Java RTE'. The Java Runtime Environment provides the minimum requirements for executing a Java application; it consists of the Java Virtual Machine (JVM), core classes, and supporting files.

Java Development Kit (JDK) is a software development environment used for developing Java applications and applets. It includes the Java Runtime Environment (JRE), an interpreter/loader (Java), a compiler (javac), an archiver (jar), a documentation generator (Javadoc), and other tools needed in Java development.

## Installation 

```sh
brew tap adoptopenjdk/openjdk
brew install --cask adoptopenjdk8
```

## Write your first program

```java
class Greet {
  public static void main (String[] args) {
    System.out.println("Hello world");
  }
}
```

  - File extention : **Greet.java**
  - Convention to follow : **Keep classname and Filename as same**


## Compile your code

```sh
javac Greet.java
```

This command will compile your code to byte code and create '.class' file named same as your className.


## Run your code

```sh
java Greet
```

This command will run your byte code.

***
