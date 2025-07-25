---
tags:
  - Tech
aliases:
  - Reactive-Programming
created: 2025-07-25 11:00
last updated: 2025-07-25 11:00
draft: true
---
# Mastering Observable and Observer Patterns in C#: A Complete Implementation Guide

## Introduction

The Observer pattern is one of the most fundamental design patterns in software development, and in C#, it's beautifully implemented through the `IObservable<T>` and `IObserver<T>` interfaces. Whether you're building reactive applications, handling events, or managing data streams, understanding how to implement and use these patterns is crucial for modern C# development.

In this comprehensive guide, we'll explore both the built-in .NET implementations and create our own custom Observable and Observer classes from scratch.

## Understanding the Core Interfaces

Before diving into implementation, let's understand the fundamental interfaces that make the Observer pattern work in .NET:

### IObservable<T> Interface
```csharp
public interface IObservable<out T>
{
    IDisposable Subscribe(IObserver<T> observer);
}
```

### IObserver<T> Interface
```csharp
public interface IObserver<in T>
{
    void OnNext(T value);
    void OnError(Exception error);
    void OnCompleted();
}
```

## Building a Custom Observable from Scratch

Let's start by implementing our own Observable class to understand how it works internally:

```csharp
using System;
using System.Collections.Generic;

public class CustomObservable<T> : IObservable<T>
{
    private readonly List<IObserver<T>> _observers = new List<IObserver<T>>();
    private readonly object _lock = new object();

    public IDisposable Subscribe(IObserver<T> observer)
    {
        if (observer == null)
            throw new ArgumentNullException(nameof(observer));

        lock (_lock)
        {
            _observers.Add(observer);
        }

        return new Unsubscriber(_observers, observer, _lock);
    }

    public void NotifyObservers(T value)
    {
        lock (_lock)
        {
            foreach (var observer in _observers)
            {
                try
                {
                    observer.OnNext(value);
                }
                catch (Exception ex)
                {
                    observer.OnError(ex);
                }
            }
        }
    }

    public void NotifyError(Exception error)
    {
        lock (_lock)
        {
            foreach (var observer in _observers)
            {
                observer.OnError(error);
            }
        }
    }

    public void NotifyCompleted()
    {
        lock (_lock)
        {
            foreach (var observer in _observers)
            {
                observer.OnCompleted();
            }
            _observers.Clear();
        }
    }

    private class Unsubscriber : IDisposable
    {
        private readonly List<IObserver<T>> _observers;
        private readonly IObserver<T> _observer;
        private readonly object _lock;

        public Unsubscriber(List<IObserver<T>> observers, IObserver<T> observer, object lockObject)
        {
            _observers = observers;
            _observer = observer;
            _lock = lockObject;
        }

        public void Dispose()
        {
            if (_observer != null)
            {
                lock (_lock)
                {
                    _observers.Remove(_observer);
                }
            }
        }
    }
}
```

## Creating Custom Observer Implementations

Now let's create some custom observer implementations:

### Simple Console Observer
```csharp
public class ConsoleObserver<T> : IObserver<T>
{
    private readonly string _name;

    public ConsoleObserver(string name)
    {
        _name = name;
    }

    public void OnNext(T value)
    {
        Console.WriteLine($"[{_name}] Received: {value}");
    }

    public void OnError(Exception error)
    {
        Console.WriteLine($"[{_name}] Error: {error.Message}");
    }

    public void OnCompleted()
    {
        Console.WriteLine($"[{_name}] Stream completed");
    }
}
```

### Logger Observer
```csharp
public class LoggerObserver<T> : IObserver<T>
{
    private readonly Action<string> _logger;

    public LoggerObserver(Action<string> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    public void OnNext(T value)
    {
        _logger($"Data received: {value}");
    }

    public void OnError(Exception error)
    {
        _logger($"Error occurred: {error.Message}");
    }

    public void OnCompleted()
    {
        _logger("Data stream completed");
    }
}
```

## Real-World Example: Stock Price Monitor

Let's build a practical example that demonstrates the Observer pattern in action:

```csharp
public class StockPrice
{
    public string Symbol { get; set; }
    public decimal Price { get; set; }
    public DateTime Timestamp { get; set; }

    public override string ToString()
    {
        return $"{Symbol}: ${Price:F2} at {Timestamp:HH:mm:ss}";
    }
}

public class StockPriceMonitor : IObservable<StockPrice>
{
    private readonly CustomObservable<StockPrice> _observable = new CustomObservable<StockPrice>();
    private readonly Timer _timer;
    private readonly Random _random = new Random();
    private readonly string[] _stocks = { "AAPL", "GOOGL", "MSFT", "TSLA", "AMZN" };

    public StockPriceMonitor()
    {
        // Simulate stock price updates every 2 seconds
        _timer = new Timer(GenerateStockPrice, null, TimeSpan.Zero, TimeSpan.FromSeconds(2));
    }

    public IDisposable Subscribe(IObserver<StockPrice> observer)
    {
        return _observable.Subscribe(observer);
    }

    private void GenerateStockPrice(object state)
    {
        try
        {
            var stock = _stocks[_random.Next(_stocks.Length)];
            var price = _random.Next(100, 1000) + _random.NextDecimal();
            
            var stockPrice = new StockPrice
            {
                Symbol = stock,
                Price = price,
                Timestamp = DateTime.Now
            };

            _observable.NotifyObservers(stockPrice);
        }
        catch (Exception ex)
        {
            _observable.NotifyError(ex);
        }
    }

    public void Stop()
    {
        _timer?.Dispose();
        _observable.NotifyCompleted();
    }
}

// Extension method for Random to generate decimal values
public static class RandomExtensions
{
    public static decimal NextDecimal(this Random random)
    {
        return (decimal)random.NextDouble();
    }
}
```

## Using the Stock Price Monitor

Here's how to use our stock price monitoring system:

```csharp
class Program
{
    static void Main(string[] args)
    {
        var stockMonitor = new StockPriceMonitor();

        // Create different types of observers
        var consoleObserver = new ConsoleObserver<StockPrice>("Console");
        var loggerObserver = new LoggerObserver<StockPrice>(Console.WriteLine);

        // Subscribe observers
        var subscription1 = stockMonitor.Subscribe(consoleObserver);
        var subscription2 = stockMonitor.Subscribe(loggerObserver);

        Console.WriteLine("Stock price monitoring started. Press any key to stop...");
        Console.ReadKey();

        // Unsubscribe and stop
        subscription1.Dispose();
        subscription2.Dispose();
        stockMonitor.Stop();

        Console.WriteLine("Monitoring stopped.");
    }
}
```

## Advanced: Using Reactive Extensions (Rx.NET)

While custom implementations are great for learning, in production you'll often use Rx.NET:

```csharp
using System.Reactive.Linq;
using System.Reactive.Subjects;

public class RxStockMonitor
{
    private readonly Subject<StockPrice> _stockSubject = new Subject<StockPrice>();
    private readonly Timer _timer;
    private readonly Random _random = new Random();
    private readonly string[] _stocks = { "AAPL", "GOOGL", "MSFT", "TSLA", "AMZN" };

    public IObservable<StockPrice> StockPrices => _stockSubject.AsObservable();

    public RxStockMonitor()
    {
        _timer = new Timer(GenerateStockPrice, null, TimeSpan.Zero, TimeSpan.FromSeconds(1));
    }

    private void GenerateStockPrice(object state)
    {
        var stock = _stocks[_random.Next(_stocks.Length)];
        var price = _random.Next(100, 1000) + _random.NextDecimal();
        
        _stockSubject.OnNext(new StockPrice
        {
            Symbol = stock,
            Price = price,
            Timestamp = DateTime.Now
        });
    }

    public void Stop()
    {
        _timer?.Dispose();
        _stockSubject.OnCompleted();
    }
}

// Usage with Rx operators
class RxExample
{
    static void Main(string[] args)
    {
        var monitor = new RxStockMonitor();

        // Filter high-value stocks and take only 10
        var subscription = monitor.StockPrices
            .Where(stock => stock.Price > 500)
            .Take(10)
            .Subscribe(
                stock => Console.WriteLine($"High-value stock: {stock}"),
                error => Console.WriteLine($"Error: {error.Message}"),
                () => Console.WriteLine("Completed receiving high-value stocks")
            );

        Console.WriteLine("Monitoring high-value stocks. Press any key to stop...");
        Console.ReadKey();

        subscription.Dispose();
        monitor.Stop();
    }
}
```

## Best Practices and Tips

### 1. **Always Handle Disposal**
```csharp
// Good practice: Store and dispose subscriptions
var subscription = observable.Subscribe(observer);
// ... later
subscription.Dispose();
```

### 2. **Thread Safety**
Always ensure your Observable implementations are thread-safe when multiple threads might be involved.

### 3. **Error Handling**
```csharp
observable.Subscribe(
    value => Console.WriteLine(value),
    error => Console.WriteLine($"Error: {error.Message}"),
    () => Console.WriteLine("Completed")
);
```

### 4. **Memory Leaks Prevention**
```csharp
// Use using statements for automatic disposal
using (var subscription = observable.Subscribe(observer))
{
    // Do work
} // Automatically disposed here
```

## Performance Considerations

- **Cold vs Hot Observables**: Understand the difference and choose appropriately
- **Backpressure**: Handle scenarios where observers can't keep up with data
- **Operator Chaining**: Be mindful of creating long operator chains that might impact performance

## Conclusion

The Observer pattern and its implementation through `IObservable<T>` and `IObserver<T>` provides a powerful foundation for reactive programming in C#. Whether you're building your own implementations or using established libraries like Rx.NET, understanding these patterns will help you create more responsive, maintainable applications.

Key takeaways:
- ✅ The Observer pattern enables loose coupling between data producers and consumers
- ✅ Custom implementations help you understand the underlying mechanics
- ✅ Rx.NET provides powerful operators for complex scenarios
- ✅ Always remember to handle disposal and errors properly
- ✅ Thread safety is crucial in multi-threaded environments

Start with simple implementations and gradually move to more complex scenarios as you become comfortable with the patterns.

---

## References and Further Reading

- [.NET IObservable<T> Interface Documentation](https://docs.microsoft.com/en-us/dotnet/api/system.iobservable-1)
- [Reactive Extensions for .NET](https://github.com/dotnet/reactive)
- [Introduction to Rx](http://introtorx.com/)
- [Observer Design Pattern](https://refactoring.guru/design-patterns/observer)

---

*Have you implemented the Observer pattern in your projects? Share your experiences and use cases in the comments below!*
