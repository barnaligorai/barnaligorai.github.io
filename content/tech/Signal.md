---
tags:
  - Tech
  - Angular
aliases:
  - Signal
created: 2025-07-15 11:00
last updated: 2025-07-15 11:00
draft: false
---
# Signal

In Angular, we use _signals_ to create and manage state. A signal is a lightweight wrapper around a value.

Use the `signal` function to create a signal for holding local state:

```ts
import {signal} from '@angular/core';

// Create a signal with the `signal` function.
const firstName = signal('Anna');

// Read a signal value by calling it— signals are functions.
console.log(firstName()); // Anna

// Change the value of this signal by calling its `set` method with a new value.
firstName.set('Elsa');

// You can also use the `update` method to change the value
// based on the previous value.
firstName.update(name => name.toUpperCase());
console.log(firstName()); // ELSA
```

## Computed expressions
A `computed` is a signal that produces its value based on other signals.

A `computed` signal is read-only; it does not have a `set` or an `update` method. Instead, the value of the `computed` signal automatically changes when any of the signals it reads change:
```ts
import {signal, computed} from '@angular/core';
const firstName = signal('Anna');
const firstNameCapitalized = computed(() => firstName().toUpperCase());
console.log(firstNameCapitalized()); // ANNA

firstName.set('Elsa');
console.log(firstNameCapitalized()); // Elsa
```

Angular tracks where signals are read and when they're updated. The framework uses this information to do additional work, such as updating the DOM with new state. This ability to respond to changing signal values over time is known as _reactivity_.