---
tags:
  - Tech
aliases:
  - Reactive-Programming
created: 2025-07-25 11:00
last updated: 2025-07-25 11:00
draft: true
---
# Mastering the C# Observer Pattern: Building Reactive Event Systems

## Introduction

The Observer pattern is one of the most fundamental and widely-used design patterns in software development. In C#, this pattern is elegantly implemented through the `IObserver<T>` interface, providing a standardized way to handle notifications and events in a reactive manner.

Whether you're building event-driven applications, implementing the Model-View-Controller pattern, or creating reactive user interfaces, understanding how to effectively implement and use the Observer pattern is essential for any C# developer.

This comprehensive guide will walk you through everything you need to know about C# Observers - from basic implementations to advanced scenarios and real-world applications.

## Understanding the IObserver<T> Interface

The `IObserver<T>` interface is beautifully simple yet incredibly powerful:

```csharp
public interface IObserver<in T>
{
    void OnNext(T value);
    void OnError(Exception error);
    void OnCompleted();
}
```

### Key Characteristics:
- **Contravariant** (`in T`): You can assign `IObserver<object>` to `IObserver<string>`
- **Three-method contract**: Handles data, errors, and completion
- **Push-based**: Receives data when it becomes available
- **Reactive**: Responds to changes automatically

## Building Your First Observer

Let's start with a simple console-based observer:

```csharp
public class ConsoleObserver<T> : IObserver<T>
{
    private readonly string _name;
    private readonly ConsoleColor _color;

    public ConsoleObserver(string name, ConsoleColor color = ConsoleColor.White)
    {
        _name = name;
        _color = color;
    }

    public void OnNext(T value)
    {
        var originalColor = Console.ForegroundColor;
        Console.ForegroundColor = _color;
        Console.WriteLine($"[{_name}] Received: {value}");
        Console.ForegroundColor = originalColor;
    }

    public void OnError(Exception error)
    {
        var originalColor = Console.ForegroundColor;
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine($"[{_name}] Error: {error.Message}");
        Console.ForegroundColor = originalColor;
    }

    public void OnCompleted()
    {
        var originalColor = Console.ForegroundColor;
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine($"[{_name}] Stream completed");
        Console.ForegroundColor = originalColor;
    }
}
```

## Advanced Observer Implementations

### Filtering Observer
An observer that only processes specific types of data:

```csharp
public class FilteringObserver<T> : IObserver<T>
{
    private readonly IObserver<T> _innerObserver;
    private readonly Func<T, bool> _predicate;

    public FilteringObserver(IObserver<T> innerObserver, Func<T, bool> predicate)
    {
        _innerObserver = innerObserver ?? throw new ArgumentNullException(nameof(innerObserver));
        _predicate = predicate ?? throw new ArgumentNullException(nameof(predicate));
    }

    public void OnNext(T value)
    {
        try
        {
            if (_predicate(value))
            {
                _innerObserver.OnNext(value);
            }
        }
        catch (Exception ex)
        {
            OnError(ex);
        }
    }

    public void OnError(Exception error)
    {
        _innerObserver.OnError(error);
    }

    public void OnCompleted()
    {
        _innerObserver.OnCompleted();
    }
}
```

### Transforming Observer
An observer that transforms data before processing:

```csharp
public class TransformingObserver<TSource, TResult> : IObserver<TSource>
{
    private readonly IObserver<TResult> _targetObserver;
    private readonly Func<TSource, TResult> _transform;

    public TransformingObserver(IObserver<TResult> targetObserver, Func<TSource, TResult> transform)
    {
        _targetObserver = targetObserver ?? throw new ArgumentNullException(nameof(targetObserver));
        _transform = transform ?? throw new ArgumentNullException(nameof(transform));
    }

    public void OnNext(TSource value)
    {
        try
        {
            var transformedValue = _transform(value);
            _targetObserver.OnNext(transformedValue);
        }
        catch (Exception ex)
        {
            OnError(ex);
        }
    }

    public void OnError(Exception error)
    {
        _targetObserver.OnError(error);
    }

    public void OnCompleted()
    {
        _targetObserver.OnCompleted();
    }
}
```

### Buffering Observer
An observer that collects data into batches:

```csharp
public class BufferingObserver<T> : IObserver<T>
{
    private readonly IObserver<T[]> _targetObserver;
    private readonly int _bufferSize;
    private readonly List<T> _buffer;
    private readonly object _lock = new object();

    public BufferingObserver(IObserver<T[]> targetObserver, int bufferSize)
    {
        _targetObserver = targetObserver ?? throw new ArgumentNullException(nameof(targetObserver));
        _bufferSize = bufferSize > 0 ? bufferSize : throw new ArgumentException("Buffer size must be positive");
        _buffer = new List<T>(_bufferSize);
    }

    public void OnNext(T value)
    {
        lock (_lock)
        {
            _buffer.Add(value);
            
            if (_buffer.Count >= _bufferSize)
            {
                var batch = _buffer.ToArray();
                _buffer.Clear();
                _targetObserver.OnNext(batch);
            }
        }
    }

    public void OnError(Exception error)
    {
        lock (_lock)
        {
            if (_buffer.Count > 0)
            {
                var remainingBatch = _buffer.ToArray();
                _buffer.Clear();
                _targetObserver.OnNext(remainingBatch);
            }
        }
        _targetObserver.OnError(error);
    }

    public void OnCompleted()
    {
        lock (_lock)
        {
            if (_buffer.Count > 0)
            {
                var finalBatch = _buffer.ToArray();
                _buffer.Clear();
                _targetObserver.OnNext(finalBatch);
            }
        }
        _targetObserver.OnCompleted();
    }
}
```

## Real-World Example: Event Logging System

Let's build a comprehensive event logging system using the Observer pattern:

```csharp
// Event data model
public class LogEvent
{
    public DateTime Timestamp { get; set; }
    public LogLevel Level { get; set; }
    public string Source { get; set; }
    public string Message { get; set; }
    public Exception Exception { get; set; }

    public override string ToString()
    {
        var exceptionInfo = Exception != null ? $" - Exception: {Exception.Message}" : "";
        return $"[{Timestamp:yyyy-MM-dd HH:mm:ss}] {Level} from {Source}: {Message}{exceptionInfo}";
    }
}

public enum LogLevel
{
    Debug,
    Info,
    Warning,
    Error,
    Critical
}

// File logger observer
public class FileLoggerObserver : IObserver<LogEvent>, IDisposable
{
    private readonly string _filePath;
    private readonly StreamWriter _writer;
    private readonly object _lock = new object();
    private bool _disposed;

    public FileLoggerObserver(string filePath)
    {
        _filePath = filePath;
        _writer = new StreamWriter(filePath, append: true);
    }

    public void OnNext(LogEvent logEvent)
    {
        if (_disposed) return;

        lock (_lock)
        {
            try
            {
                _writer.WriteLine(logEvent.ToString());
                _writer.Flush();
            }
            catch (Exception ex)
            {
                // Handle logging errors - could notify error handling system
                Console.WriteLine($"Failed to write to log file: {ex.Message}");
            }
        }
    }

    public void OnError(Exception error)
    {
        if (_disposed) return;

        lock (_lock)
        {
            try
            {
                _writer.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] LOGGER ERROR: {error.Message}");
                _writer.Flush();
            }
            catch
            {
                // Swallow exception to prevent infinite loops
            }
        }
    }

    public void OnCompleted()
    {
        if (_disposed) return;

        lock (_lock)
        {
            _writer.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Log stream completed");
            _writer.Flush();
        }
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            _disposed = true;
            lock (_lock)
            {
                _writer?.Dispose();
            }
        }
    }
}

// Database logger observer
public class DatabaseLoggerObserver : IObserver<LogEvent>
{
    private readonly string _connectionString;
    private readonly Queue<LogEvent> _logQueue = new();
    private readonly object _lock = new object();
    private readonly Timer _flushTimer;

    public DatabaseLoggerObserver(string connectionString, TimeSpan flushInterval)
    {
        _connectionString = connectionString;
        _flushTimer = new Timer(FlushLogs, null, flushInterval, flushInterval);
    }

    public void OnNext(LogEvent logEvent)
    {
        lock (_lock)
        {
            _logQueue.Enqueue(logEvent);
        }
    }

    public void OnError(Exception error)
    {
        var errorLog = new LogEvent
        {
            Timestamp = DateTime.Now,
            Level = LogLevel.Error,
            Source = "DatabaseLogger",
            Message = "Observer error occurred",
            Exception = error
        };

        lock (_lock)
        {
            _logQueue.Enqueue(errorLog);
        }
    }

    public void OnCompleted()
    {
        FlushLogs(null);
        _flushTimer?.Dispose();
    }

    private void FlushLogs(object state)
    {
        List<LogEvent> logsToFlush;
        
        lock (_lock)
        {
            if (_logQueue.Count == 0) return;
            
            logsToFlush = new List<LogEvent>(_logQueue);
            _logQueue.Clear();
        }

        try
        {
            // Simulate database write
            foreach (var log in logsToFlush)
            {
                // Insert into database
                Console.WriteLine($"DB: {log}");
            }
        }
        catch (Exception ex)
        {
            // Re-queue failed logs or handle error
            Console.WriteLine($"Failed to write to database: {ex.Message}");
        }
    }
}

// Email alert observer for critical events
public class EmailAlertObserver : IObserver<LogEvent>
{
    private readonly string[] _recipients;
    private readonly LogLevel _minimumLevel;

    public EmailAlertObserver(string[] recipients, LogLevel minimumLevel = LogLevel.Error)
    {
        _recipients = recipients ?? throw new ArgumentNullException(nameof(recipients));
        _minimumLevel = minimumLevel;
    }

    public void OnNext(LogEvent logEvent)
    {
        if (logEvent.Level >= _minimumLevel)
        {
            SendEmailAlert(logEvent);
        }
    }

    public void OnError(Exception error)
    {
        var errorLog = new LogEvent
        {
            Timestamp = DateTime.Now,
            Level = LogLevel.Critical,
            Source = "EmailAlertObserver",
            Message = "Observer system error",
            Exception = error
        };

        SendEmailAlert(errorLog);
    }

    public void OnCompleted()
    {
        // Send completion notification if needed
        Console.WriteLine("Email alert system: Log stream completed");
    }

    private void SendEmailAlert(LogEvent logEvent)
    {
        try
        {
            // Simulate email sending
            foreach (var recipient in _recipients)
            {
                Console.WriteLine($"EMAIL to {recipient}: {logEvent.Level} - {logEvent.Message}");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to send email alert: {ex.Message}");
        }
    }
}
```

## Observer Composition and Chaining

Create powerful observer chains:

```csharp
public static class ObserverExtensions
{
    // Chain observers together
    public static IObserver<T> Chain<T>(this IObserver<T> first, IObserver<T> second)
    {
        return new ChainedObserver<T>(first, second);
    }

    // Add filtering capability
    public static IObserver<T> Where<T>(this IObserver<T> observer, Func<T, bool> predicate)
    {
        return new FilteringObserver<T>(observer, predicate);
    }

    // Add transformation capability
    public static IObserver<TResult> Select<T, TResult>(this IObserver<TResult> observer, Func<T, TResult> transform)
    {
        return new TransformingObserver<T, TResult>(observer, transform);
    }

    // Add buffering capability
    public static IObserver<T> Buffer<T>(this IObserver<T[]> observer, int bufferSize)
    {
        return new BufferingObserver<T>(observer, bufferSize);
    }
}

public class ChainedObserver<T> : IObserver<T>
{
    private readonly IObserver<T> _first;
    private readonly IObserver<T> _second;

    public ChainedObserver(IObserver<T> first, IObserver<T> second)
    {
        _first = first ?? throw new ArgumentNullException(nameof(first));
        _second = second ?? throw new ArgumentNullException(nameof(second));
    }

    public void OnNext(T value)
    {
        try
        {
            _first.OnNext(value);
        }
        catch (Exception ex)
        {
            _first.OnError(ex);
        }

        try
        {
            _second.OnNext(value);
        }
        catch (Exception ex)
        {
            _second.OnError(ex);
        }
    }

    public void OnError(Exception error)
    {
        _first.OnError(error);
        _second.OnError(error);
    }

    public void OnCompleted()
    {
        _first.OnCompleted();
        _second.OnCompleted();
    }
}
```

## Observer with State Management

Sometimes observers need to maintain state across notifications:

```csharp
public class StatisticsObserver<T> : IObserver<T> where T : IComparable<T>
{
    private readonly object _lock = new object();
    private int _count;
    private T _minimum;
    private T _maximum;
    private bool _hasValues;

    public int Count
    {
        get { lock (_lock) return _count; }
    }

    public T Minimum
    {
        get { lock (_lock) return _minimum; }
    }

    public T Maximum
    {
        get { lock (_lock) return _maximum; }
    }

    public bool HasValues
    {
        get { lock (_lock) return _hasValues; }
    }

    public void OnNext(T value)
    {
        lock (_lock)
        {
            _count++;
            
            if (!_hasValues)
            {
                _minimum = value;
                _maximum = value;
                _hasValues = true;
            }
            else
            {
                if (value.CompareTo(_minimum) < 0)
                    _minimum = value;
                
                if (value.CompareTo(_maximum) > 0)
                    _maximum = value;
            }
        }

        Console.WriteLine($"Stats: Count={Count}, Min={Minimum}, Max={Maximum}");
    }

    public void OnError(Exception error)
    {
        Console.WriteLine($"Statistics Observer Error: {error.Message}");
    }

    public void OnCompleted()
    {
        lock (_lock)
        {
            Console.WriteLine($"Final Statistics: Count={_count}, Min={_minimum}, Max={_maximum}");
        }
    }

    public void Reset()
    {
        lock (_lock)
        {
            _count = 0;
            _minimum = default(T);
            _maximum = default(T);
            _hasValues = false;
        }
    }
}
```

## Testing Observers

Create testable observers for unit testing:

```csharp
public class TestObserver<T> : IObserver<T>
{
    private readonly List<T> _receivedValues = new();
    private readonly List<Exception> _errors = new();
    private bool _completed;

    public IReadOnlyList<T> ReceivedValues => _receivedValues.AsReadOnly();
    public IReadOnlyList<Exception> Errors => _errors.AsReadOnly();
    public bool Completed => _completed;

    public void OnNext(T value)
    {
        _receivedValues.Add(value);
    }

    public void OnError(Exception error)
    {
        _errors.Add(error);
    }

    public void OnCompleted()
    {
        _completed = true;
    }

    // Helper methods for testing
    public void AssertReceivedCount(int expectedCount)
    {
        if (_receivedValues.Count != expectedCount)
            throw new AssertionException($"Expected {expectedCount} values, but received {_receivedValues.Count}");
    }

    public void AssertReceived(params T[] expectedValues)
    {
        if (!_receivedValues.SequenceEqual(expectedValues))
            throw new AssertionException($"Expected {string.Join(", ", expectedValues)}, but received {string.Join(", ", _receivedValues)}");
    }

    public void AssertCompleted()
    {
        if (!_completed)
            throw new AssertionException("Expected observer to be completed");
    }

    public void AssertError<TException>() where TException : Exception
    {
        if (!_errors.Any(e => e is TException))
            throw new AssertionException($"Expected error of type {typeof(TException).Name}");
    }
}

public class AssertionException : Exception
{
    public AssertionException(string message) : base(message) { }
}

// Usage example
public class ObserverTests
{
    public void TestConsoleObserver()
    {
        var testObserver = new TestObserver<int>();
        
        // Simulate data
        testObserver.OnNext(1);
        testObserver.OnNext(2);
        testObserver.OnNext(3);
        testObserver.OnCompleted();

        // Assert results
        testObserver.AssertReceivedCount(3);
        testObserver.AssertReceived(1, 2, 3);
        testObserver.AssertCompleted();
    }
}
```

## Async Observer Pattern

Handle asynchronous operations in observers:

```csharp
public abstract class AsyncObserver<T> : IObserver<T>
{
    private readonly SemaphoreSlim _semaphore = new(1, 1);

    public void OnNext(T value)
    {
        _ = Task.Run(async () =>
        {
            await _semaphore.WaitAsync();
            try
            {
                await OnNextAsync(value);
            }
            catch (Exception ex)
            {
                OnError(ex);
            }
            finally
            {
                _semaphore.Release();
            }
        });
    }

    public void OnError(Exception error)
    {
        _ = Task.Run(async () =>
        {
            await _semaphore.WaitAsync();
            try
            {
                await OnErrorAsync(error);
            }
            finally
            {
                _semaphore.Release();
            }
        });
    }

    public void OnCompleted()
    {
        _ = Task.Run(async () =>
        {
            await _semaphore.WaitAsync();
            try
            {
                await OnCompletedAsync();
            }
            finally
            {
                _semaphore.Release();
            }
        });
    }

    protected abstract Task OnNextAsync(T value);
    protected abstract Task OnErrorAsync(Exception error);
    protected abstract Task OnCompletedAsync();
}

// Example async observer
public class AsyncFileLogger<T> : AsyncObserver<T>
{
    private readonly string _filePath;

    public AsyncFileLogger(string filePath)
    {
        _filePath = filePath;
    }

    protected override async Task OnNextAsync(T value)
    {
        await File.AppendAllTextAsync(_filePath, $"{DateTime.Now}: {value}\n");
    }

    protected override async Task OnErrorAsync(Exception error)
    {
        await File.AppendAllTextAsync(_filePath, $"{DateTime.Now}: ERROR - {error.Message}\n");
    }

    protected override async Task OnCompletedAsync()
    {
        await File.AppendAllTextAsync(_filePath, $"{DateTime.Now}: COMPLETED\n");
    }
}
```

## Performance Considerations

### Avoid Blocking Operations
```csharp
// Bad - Blocking observer
public class SlowObserver<T> : IObserver<T>
{
    public void OnNext(T value)
    {
        Thread.Sleep(1000); // This will block the observable!
        ProcessValue(value);
    }
    
    // ... other methods
}

// Good - Non-blocking observer
public class FastObserver<T> : IObserver<T>
{
    public void OnNext(T value)
    {
        Task.Run(() => ProcessValueAsync(value)); // Non-blocking
    }
    
    private async Task ProcessValueAsync(T value)
    {
        await Task.Delay(1000); // Simulate work without blocking
        ProcessValue(value);
    }
    
    // ... other methods
}
```

### Memory Management
```csharp
public class ResourceAwareObserver<T> : IObserver<T>, IDisposable
{
    private readonly ConcurrentQueue<T> _buffer = new();
    private readonly Timer _processTimer;
    private bool _disposed;

    public ResourceAwareObserver()
    {
        _processTimer = new Timer(ProcessBuffer, null, TimeSpan.FromSeconds(1), TimeSpan.FromSeconds(1));
    }

    public void OnNext(T value)
    {
        if (!_disposed)
        {
            _buffer.Enqueue(value);
            
            // Prevent memory buildup
            while (_buffer.Count > 1000)
            {
                _buffer.TryDequeue(out _);
            }
        }
    }

    private void ProcessBuffer(object state)
    {
        var processedCount = 0;
        while (_buffer.TryDequeue(out var item) && processedCount < 100)
        {
            ProcessItem(item);
            processedCount++;
        }
    }

    private void ProcessItem(T item)
    {
        // Process the item
        Console.WriteLine($"Processing: {item}");
    }

    public void OnError(Exception error)
    {
        Console.WriteLine($"Error: {error.Message}");
    }

    public void OnCompleted()
    {
        // Process remaining items
        while (_buffer.TryDequeue(out var item))
        {
            ProcessItem(item);
        }
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            _disposed = true;
            _processTimer?.Dispose();
        }
    }
}
```

## Best Practices

### 1. **Handle Exceptions Gracefully**
```csharp
public class RobustObserver<T> : IObserver<T>
{
    public void OnNext(T value)
    {
        try
        {
            ProcessValue(value);
        }
        catch (Exception ex)
        {
            // Log error but don't propagate to avoid breaking the stream
            Console.WriteLine($"Error processing value {value}: {ex.Message}");
        }
    }

    // Always implement error handling
    public void OnError(Exception error)
    {
        Console.WriteLine($"Stream error: {error.Message}");
        // Implement recovery logic if needed
    }

    public void OnCompleted()
    {
        Console.WriteLine("Stream completed successfully");
        // Cleanup resources
    }

    private void ProcessValue(T value)
    {
        // Your processing logic here
    }
}
```

### 2. **Thread Safety**
```csharp
public class ThreadSafeObserver<T> : IObserver<T>
{
    private readonly object _lock = new object();
    private readonly List<T> _data = new();

    public void OnNext(T value)
    {
        lock (_lock)
        {
            _data.Add(value);
            ProcessValue(value);
        }
    }

    public void OnError(Exception error)
    {
        lock (_lock)
        {
            // Handle error with thread safety
        }
    }

    public void OnCompleted()
    {
        lock (_lock)
        {
            // Final processing with thread safety
        }
    }
}
```

### 3. **Resource Cleanup**
```csharp
public class CleanupObserver<T> : IObserver<T>, IDisposable
{
    private readonly IDisposable[] _resources;
    private bool _disposed;

    public CleanupObserver(params IDisposable[] resources)
    {
        _resources = resources;
    }

    public void OnCompleted()
    {
        Dispose(); // Cleanup when completed
    }

    public void OnError(Exception error)
    {
        Dispose(); // Cleanup on error
    }

    public void Dispose()
    {
        if (!_disposed)
        {
            _disposed = true;
            foreach (var resource in _resources)
            {
                resource?.Dispose();
            }
        }
    }
}
```

## When to Use Observer vs Alternatives

### **Use Observer Pattern When:**
- ✅ Multiple components need to react to the same events
- ✅ You need loose coupling between event producers and consumers
- ✅ Building reactive systems or event-driven architectures
- ✅ Implementing the Model-View-Controller pattern
- ✅ Creating notification systems

### **Consider Alternatives When:**
- ❌ Simple one-to-one communication (use direct method calls)
- ❌ Performance is critical and you have simple event handling
- ❌ You need guaranteed delivery (use message queues)
- ❌ Complex workflow orchestration (use workflow engines)

## Conclusion

The C# Observer pattern, implemented through `IObserver<T>`, provides a powerful foundation for building reactive, event-driven applications. By understanding the core concepts and implementation patterns, you can create robust observers that handle data streams, errors, and completion scenarios gracefully.

### Key Takeaways:
- ✅ **Three-method contract** - Handle data, errors, and completion
- ✅ **Composition is powerful** - Chain and combine observers for complex behaviors
- ✅ **Thread safety is critical** - Protect shared state appropriately
- ✅ **Resource management matters** - Implement proper cleanup
- ✅ **Error handling is essential** - Always handle exceptions gracefully
- ✅ **Async support** - Use async patterns for non-blocking operations

Start with simple observer implementations and gradually build complexity as you become more comfortable with the reactive paradigm.

---

## References and Further Reading

- [IObserver<T> Interface Documentation](https://docs.microsoft.com/en-us/dotnet/api/system.iobserver-1)
- [Observer Design Pattern](https://refactoring.guru/design-patterns/observer)
- [Reactive Extensions for .NET](https://github.com/dotnet/reactive)
- [Event-Driven Architecture Patterns](https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven)

---

*Ready to implement the Observer pattern in your applications? Start with the examples above and build your own reactive event systems!*
