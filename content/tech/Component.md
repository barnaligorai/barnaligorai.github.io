---
tags:
  - Tech
  - Angular
aliases:
  - Component
created: 2025-07-15 11:00
last updated: 2025-07-15 11:00
draft: false
---
# Component

## Understanding Angular Components : The Fundamental Building Blocks of Angular Application

Components are the main building blocks of Angular applications. With multiple components we create a larger web page. Organizing an application into components helps provide a manageable structure, clearly separating code into specific parts make it easy to maintain. Components are like custom HTML elements that encapsulate both presentation and behavior.

## What is an Angular Component?

A component in Angular consists of three main parts:

1. **@Component Decorator** - that contains some configuration used by Angular.
2. **HTML Template** - Defines the component's view
3. **CSS Styles** - Provides styling for the component
4. **TypeScript Class** - Contains the component logic and data

Here is a simplified example of a `UserProfile` component.
```ts
// user-profile.component.ts
@Component({
  selector: 'user-profile',
  template: `
    <h1>User profile</h1>
    <p>This is the user profile page</p>
  `,
  styles: `h1 { font-size: 3em; } `
})
export class UserProfileComponent { /* Your component code goes here */ }
```

## Separating HTML and CSS into separate files

You can define a component's HTML and CSS in separate files using `templateUrl` and `styleUrl`:
```ts
// user-profile.component.ts
@Component({
  selector: 'user-profile',
  templateUrl: 'user-profile.component.html',
  styleUrl: 'user-profile.component.css',
})
export class UserProfileComponent {
  // Component behavior is defined in here
}
```

```html
<!-- user-profile.component.html -->
<h1>User profile</h1>
<p>This is the user profile page</p>
```

```css
/* user-profile.component.css */
h1 {
  font-size: 3em;
}
```

## Creating Your First Component

### Using Angular CLI

The easiest way to create a component is using the Angular CLI:

```bash
ng generate component my-component
```

This creates four files:
- `my-component.component.ts` - The component class
- `my-component.component.html` - The template
- `my-component.component.css` - The styles
- `my-component.component.spec.ts` - The unit tests

## Using Components

We build an application by composing multiple components together. For example, if we are building a user profile page, we might break the page up into several components like : ProfilePhoto, UserName, UserBio, UserDetails. We need to combine all the components to build the UserProfile.

To import and use a component, we need to:

1. In the component's TypeScript file, add an `import` statement for the component we want to use.
2. In the `@Component` decorator, add an entry to the `imports` array for the component we want to use.
3. In the component's template, add an element that matches the selector of the component we want to use.

```ts
// profile-photo.component.ts
@Component({
  selector: 'profile-photo',
  ...
})
export class ProfilePhotoComponent { }
```

We can use this component by creating a matching HTML element in the templates of _other_ components:

```ts
// user-profile.component.ts
import {ProfilePhoto} from 'profile-photo.ts';
@Component({
  selector: 'user-profile',
  imports: [ProfilePhoto],
  template: `
    <h1>User profile</h1>
    <profile-photo />
    <p>This is the user profile page</p>
  `,
})
export class UserProfileComponent {
  // Component behavior is defined in here
}
```

## Standalone Components

Modern Angular supports standalone components that do not need to be declared in NgModules:

```ts
import { Component } from '@angular/core';

@Component({
  selector: 'app-standalone',
  standalone: true,
  template: `<h1>I'm standalone!</h1>`
})
export class StandaloneComponent { }
```

Learn more : [standalone-component](https://blog.angular-university.io/angular-standalone-components/)


## Data Binding in Components

### String Interpolation
Display component data in the template:

```typescript
// Component
export class UserComponent {
  userName = 'John Doe';
}
```

```html
<!-- Template -->
<h1>Welcome, {{userName}}!</h1>
```

### Property Binding
Bind component properties to element attributes:

```html
<img [src]="imageUrl" [alt]="imageDescription">
<button [disabled]="isLoading">Submit</button>
```

### Event Binding
Handle user interactions:

```html
<button (click)="handleClick()">Click me</button>
<input (keyup)="onKeyUp($event)">
```

### Two-way Binding
Combine property and event binding:

```html
<input [(ngModel)]="userName">
```

Learn more about [dynamic interfaces with templates](https://angular.dev/guide/templates)

## Component Communication

### Input Properties
Pass data from parent to child:

```typescript
// Child component
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-child'
})
export class ChildComponent {
  @Input() message!: string;
  @Input() count: number = 0;
}
```

```html
<!-- Parent template -->
<app-child [message]="parentMessage" [count]="parentCount"></app-child>
```

### Output Events
Send data from child to parent:

```typescript
// Child component
import { Component, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-child'
})
export class ChildComponent {
  @Output() countChanged = new EventEmitter<number>();
  
  incrementCount() {
    this.countChanged.emit(this.count + 1);
  }
}
```

```html
<!-- Parent template -->
<app-child (countChanged)="onCountChanged($event)"></app-child>
```

## Component Lifecycle

Angular components have a well-defined lifecycle with hooks :

```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({
  selector: 'app-lifecycle'
})
export class LifecycleComponent implements OnInit, OnDestroy {
  
  ngOnInit() {
    // Component initialization logic
    console.log('Component initialized');
  }
  
  ngOnDestroy() {
    // Cleanup logic
    console.log('Component destroyed');
  }
}
```

Common lifecycle hooks:
- `ngOnInit` - After component initialization
- `ngOnChanges` - When input properties change
- `ngOnDestroy` - Before component destruction
- `ngAfterViewInit` - After view initialization

## Modern Angular: Signals (Angular 16+)

Signals provide a new reactive programming model:

```typescript
// signals.component.ts
import { Component, signal, computed } from '@angular/core';

@Component({
  selector: 'app-signals'
  template: 'signals.component.html'
})
export class SignalsComponent {
  count = signal(0);
  doubleCount = computed(() => this.count() * 2);
  
  increment() {
    this.count.update(value => value + 1);
  }
}
```

```html
<!--> signals.component.html </-->
<p>Count: {{count()}}</p>
<p>Double: {{doubleCount()}}</p>
<button (click)="increment()">Increment</button>
```
Learn more about adding and manage dynamic data with [Signal](./Signal.md)