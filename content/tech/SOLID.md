---
tags:
  - Tech
  - oop
aliases:
  - Solid principles
created: 2024-10-07 23:56
last updated: 2024-10-07 23:56
draft: false
---
# SOLID Principle

## Single Responsibility Principle : SRP

Every software component should have *one and only responsibility*

Things we can keep in mind while thinking about single responsibility : 1. Cohesion and 2. Coupling
#### Cohesion
- Cohesion is the degree to which the various parts of a software components are related

Example :

A square class with different types of methods like : CalculateArea, CalculatePerimeter, Draw, Rotate
```c#
class Square
    {
        private int side;

        public Square(int side)
        {
            this.side = side;
        }
        public int CalculateArea()
        {
            return side * side;
        }
        public int CalculatePerimeter()
        {
            return side * 4;
        }
        public void Draw(string resolution)
        {
            if (resolution == "High")
            {
                // code to draw
            }
            else
            {
                // code to draw
            }
        }
        public void Rotate(int degree)
        {
            // code to rotate clockwise
            // code to re-render the square
        }
    }
```
The above mentioned code can be more meaningful if we increase the level of cohesion and separate them into two class, such as :

```c#
public class Square
{
    private int side = 5;

    public int CalculateArea()
    {
        return side * side;
    }
    public int CalculatePerimeter()
    {
        return side * 4;
    }
}
public class SquareUI
{
    public void Draw(string resolution)
    {
        if (resolution == "High")
        {
            // code to draw
        }
        else
        {
            // code to draw
        }
    }
    public void Rotate(int degree)
    {
        // code to rotate clockwise
        // code to re-render the square
    }
}
```
One class dealing with the calculation and another dealing with the rendering. Thus cohesion can help us segregating the responsibilities. 

- Aim for High Cohesion

#### Coupling
- Coupling is defined as the level of inter dependencies between various software components

Example :

Let's take a student class which has multiple info of a student and can save the data into a file(db).
```c#
class Student
    {
        private string name;
        private string id;
        private DateTime dateOfBirth;

        public Student()
        {
            //constructor
        }
        public string GetStudentId()
        {
            return id;
        }
        public string GetStudentName()
        {
            return name;
        }
        public void Save()
        {
            var studentsDbFile = @"Chemistry/2024/Students.db";
            // Save the details of the student
            // Write to file
        }
    }
```
Here we are saving the data in a local file. But in future if we want to move to some other db like mysql or mongodb, this student call has to be changed because it is tightly coupled to this saving mechanism. Student class is dealing with saving and is aware of low level design of how and where data is getting saved. We can fix this by creating another class(StudentRepository) to keep the Student class pure.
```c#
class StudentRepository
{
    public void Save()
    {
        var studentsDbFile = @"Chemistry/2024/Students.db";
        // Save the details of the student
        // Write to file
        // Try-Catch blocks
        // Handle exceptions and retry mechanism
    }
}
class Student
{
    private string name;
    private string id;
    private DateTime dateOfBirth;

    public Student()
    {
        //constructor
    }
    public string GetStudentId()
    {
        return id;
    }
    public string GetStudentName()
    {
        return name;
    }
    public void Save()
    {
        new StudentRepository().Save();
    }
}
```
By doing this Student class is only dealing with StudentProfile, while low level design is abstracted out in StudentRepository. Thus loose coupling helps in separating based on responsibilities.

- Aim for Loose Coupling

We can also say : Every software component should have *one and only reason to change* 

Explanation :

Lets take the first example of Student class which has student info as well as how to save mechanism. There can be multiple reasons to change the class, such as : 
1. If there is a change in the name format
2. If there is a change in how the student id is created
3. If they decide to move from file to DB
4. If they want change in the database backend as adviced by technical team

But if we decouple them to StudentProfile and StudentRepository :
1. The StudentProfile class will be changed only when there is a requirement for any format change.
2. The StudentRepository class will be updated when there is a requirement for the persistance mechanism.

Though the reasons are multiple, but they are closely related. The code will be organised and easily maintainable, will keep the changes minimal and help in reducing cost.


## Open-Closed Principle : OCP

Every software component should be *closed for modification, but open for extension*

Explanation :


1. To add a new feature in the software component, it should not modify any existing code.
2. The software component should be extendable to add anew feature.

For example, if there is a InsuranceDiscountCalculator class which returns how much discount should be given based on the customer profile and it has two types of customes : HealthInsuranceCustomerProfile and VehicleInsuranceCustomerProfile.

```c#
class InsuranceDiscountCalculator
{
    public int CalculatePremiumDiscountPercentage(HealthInsuranceCustomerProfile profile)
    {
        if (profile.IsLoyalCustomer())
        {
            return 20;
        }

        return 0;
    }
    public int CalculatePremiumDiscountPercentage(VehicleInsuranceCustomerProfile profile)
    {
        if (profile.IsLoyalCustomer())
        {
            return 20;
        }

        return 0;
    }
}
class HealthInsuranceCustomerProfile
{
    public bool IsLoyalCustomer()
    {
        return true;// Implement logic to return tru or false
    }
}
class VehicleInsuranceCustomerProfile
{
    public bool IsLoyalCustomer()
    {
        return true;// Implement logic to return tru or false
    }
}
```

Now if there we want to add another type of customer HomeInsuranceCustomerProfile, we have to modify the existing InsuranceDiscountCalculator class with another overload of CalculatePremiumDiscountPercentage method.

But we can make this code mode extensible so that we do not have to modify the InsuranceDiscountCalculator calss everytime we have a new customer profile by adding an Interface.

```c#
interface CustomerProfile
{
    bool IsLoyalCustomer();
}
class InsuranceDiscountCalculator
{
    public int CalculatePremiumDiscountPercentage(CustomerProfile profile)
    {
        if (profile.IsLoyalCustomer())
        {
            return 20;
        }

        return 0;
    }
}
class HealthInsuranceCustomerProfile : CustomerProfile
{
    public bool IsLoyalCustomer()
    {
        return true;// Implement logic to return tru or false
    }
}
class VehicleInsuranceCustomerProfile : CustomerProfile
{
    public bool IsLoyalCustomer()
    {
        return true;// Implement logic to return tru or false
    }
}
class HomeInsuranceCustomerProfile : CustomerProfile
{
    public bool IsLoyalCustomer()
    {
        return true;// Implement logic to return tru or false
    }
}
```

In this way by adding only one interface we made this whole code easily extensible. Now if we get another kind of cuistomer, we just need to implement the CustomerProfile interface in that new customer.

Here we can also see the CalculatePremiumDiscountPercentage is only handling a single responsibility of calculating the discount, so here SRP is also followed. OCP and SRP can work together to achive a better design.

## Liskov Substitution Principle : LSP

According to this principle *Derived or child classes must be substitutable for their base or parent classes*. 

The principle was introduced by Barbara Liskov in 1987. 
This principle ensures that any class that is the child of a parent class should be usable in place of its parent without any unexpected behavior.
The importance of the LSP lies in its ability to ensure that the behavior of a program remains consistent and predictable when substituting objects of different classes. Violating the LSP can lead to unexpected behavior, bugs, and maintainability issues. Let's understand with an example :

There is a Car Interface:
```csharp
interface Car {   
    void TurnOnEngine();
    void Accelerate();
}
```
Let’s implement our interface and provide some code for the methods:
```csharp
public class MotorCar implements Car {
    private Engine engine;
    public void TurnOnEngine() {
        //turn on the engine!
        engine.On();
    }
    public void Accelerate() {
        //move forward!
        engine.PowerOn(1000);
    }
}
```
As our code describes, we have an engine that we can turn on, and we can increase the power.

But wait — we are now living in the era of electric cars:
```csharp
public class ElectricCar implements Car {

    public void TurnOnEngine() {
        throw new Exception("I don't have an engine!");
    }

    public void Accelerate() {
        //this acceleration is crazy!
    }
}
```

By throwing a car without an engine into the mix, we are inherently changing the behavior of our program. This is a blatant violation of Liskov substitution and is a bit harder to fix than our previous two principles.

- One possible solution would be to rework our model into interfaces that take into account the engine-less state of our Car.


Let's see another example to understant this better :

One of the classic examples of this principle is a rectangle having four sides. A rectangle’s height can be any value and width can be any value. A square is a rectangle with equal width and height. So we can say that we can extend the properties of the rectangle class into square class. </br>
In order to do that you need to swap the child (square) class with parent (rectangle) class to fit the definition of a square having four equal sides but a derived class does not affect the behavior of the parent class so if you will do that it will violate the Liskov Substitution Principle.

## Interface Segregation Principle : ISP

It states that *Do not force any client to implement an interface which is irrelevant to them*.

Consider a Vehicle interface as below:
```csharp
interface Vehicle {
    void StartEngine();
    void StopEngine();
    void Drive();
    void Fly();
}
```

And then you have a class called Car that implements the Vehicle interface:
```csharp
class Car implements Vehicle {
    public void startEngine() {
        // implementation
    }
    public void stopEngine() {
        // implementation
    }
    public void drive() {
        // implementation
    }
    public void fly() {
        throw new UnsupportedOperationException("This Car cannot fly.");
    }
}
```

In this example, the Vehicle interface has too many methods. The Car class is forced to implement all of them, even though they cannot fly. This violates the ISP because the Vehicle interface is not properly segregated into smaller interfaces based on related functionality.

Let's understand how you can follow the ISP here. Suppose you refactor the Vehicle interface into smaller, more focused interfaces:
```csharp
interface Drivable {
    void StartEngine();
    void StopEngine();
    void Drive();
}

interface Flyable {
    void Fly();
}
```
Now, you can have a class called Car that only implements the Drivable interface:
```csharp
class Car implements Drivable {
    public void StartEngine() {
        // implementation
    }
    public void StopEngine() {
        // implementation
    }
    public void Drive() {
        // implementation
    }
}
```
And, thanks to interface segregation, you can have another class called Airplane that implements both the Drivable and Flyable interfaces:
```csharp
class Airplane implements Drivable, Flyable {
    public void StartEngine() {
        // implementation
    }
    public void StopEngine() {
        // implementation
    }
    public void Drive() {
        // implementation
    }
    public void Fly() {
        // implementation
    }
}
```
In this example, you have properly segregated the Vehicle interface into smaller interfaces based on related functionality. This adheres to the ISP and makes your code more flexible and maintainable.

## Dependency Inversion Principle : DIP

It states that *High-level modules should not depend on low-level modules. Both should depend on abstractions*.

This principle aims to reduce coupling between modules, increase modularity, and make the code easier to maintain, test, and extend.

For example, consider a scenario where you have a class that needs to use an instance of another class. In the traditional approach, the first class would directly create an instance of the second class, leading to a tight coupling between them. This makes it difficult to change the implementation of the second class or to test the first class independently.

But if you apply the DIP, the first class would depend on an abstraction of the second class instead of the implementation. This would make it possible to easily change the implementation and test the first class independently.

Here is an example that violates the DIP:

```csharp
class MySQLConnection
{
    public void Connect()
    {
        // handle the database connection
        return 'Database connection';
    }
    public void Save(Student student)
    {
        // Save
    }
}

class Student{
    //constructor
    private string name;
    private int id;

    public void Save(MySQLConnection sqlConnection)
    {
        sqlConnection.Connect();
        sqlConnection.Save(this);
        // Save the details of the student
        // Write to file
    }
}
```
This snippet above violates this principle as the Student class is being forced to depend on the MySQLConnection class.
Later, if you were to change the database engine, you would also have to edit the Save method signature in Student class, which would violate the open-close principle.
To address these issues, you can code to an interface since high-level and low-level modules should depend on abstraction:

```csharp
interface DBConnectionInterface
{
    void Connect();
    void Save(Student student);
}
class MySQLConnection implements DBConnectionInterface
{
    public void Connect()
    {
        // handle the database connection
        return 'Database connection';
    }
    public void Save(Student student)
    {
        // Save
    }
}

class Student{

    //constructor
    private string name;
    private int id;

    public void Save(DBConnectionInterface dBConnectionInterface)
    {
        dBConnectionInterface.Connect();
        dBConnectionInterface.Save(this);
        // Save the details of the student
        // Write to file
    }
}
```
This code establishes that both the high-level and low-level modules depend on abstraction.