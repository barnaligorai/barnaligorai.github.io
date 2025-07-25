---
tags:
  - Tech
aliases: 
created: 2024-10-16 22:43
last updated: 2024-10-16 22:43
draft: false
---
# Creational Design Patterns

Creational design patterns deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by controlling this object creation.

The creational patterns aim to separate a system from how its objects are created, composed, and represented. They increase the system's flexibility in terms of the what, who, how, and when of object creation.

Creational design patterns provide various object creation mechanisms, which increase flexibility and reuse of existing code.

These design patterns are all about class instantiation. This pattern can be further divided into class-creation patterns and object-creational patterns. While class-creation patterns use inheritance effectively in the instantiation process, object-creation patterns use delegation effectively to get the job done.

- Factory Method
	- Creates an instance of several derived classes
- Abstract Factory
	- Creates an instance of several families of classes
- Builder
	- Separates object construction from its representation
- Prototype
	- A fully initialized instance to be copied or cloned
- Singleton
	- A class of which only a single instance can exist

## Factory Method
It provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.

## Abstract Factory
Abstract Factory is a creational design pattern that lets you produce families of related objects without specifying their concrete classes.

## Builder
Builder is a creational design pattern that lets you construct complex objects step by step. The pattern allows you to produce different types and representations of an object using the same construction code.

## Prototype
Prototype is a creational design pattern that lets you copy existing objects without making your code dependent on their classes.

## Singleton
Singleton is a creational design pattern that lets you ensure that a class has only one instance, while providing a global access point to this instance.


### Reference
- https://refactoring.guru/design-patterns/creational-patterns