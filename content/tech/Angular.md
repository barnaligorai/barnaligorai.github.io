---
tags: 
aliases: 
created: 2025-05-19 22:45
last updated: 2025-05-19 22:45
draft: true
---
Angular Essentials
Components
Services & DI
HTTP

----
Angular Essentials
Decorator : @Component
Decorators like `@Component` are used by Angular to add metadata & configuration to classes

TypeScript docs : https://www.typescriptlang.org/docs/handbook/


_definite assignment assertion operator_, `!`:
```ts
class OKGreeter {
	// Not initialized, but no error
	name!: string;
}
```

Note that inside a method body, it is still mandatory to access fields and other methods via `this.`. An unqualified name in a method body will always refer to something in the enclosing scope:

```ts
let x: number = 0;  
class C {    
	x: string = "hello";    
	m() {      
		// This is trying to modify 'x' from line 1, not the class property
		x = "world";
		// Error : Type 'string' is not assignable to type 'number'.Type 'string' is not assignable to type 'number'.
	}  
}
```


selector
template vs templateurl
standalone 
componenttree
styleurl, styleurls, styles

ng generate component <component name>

string interpolation
property binding

zone.js vs signal
signal + computed

@Input
required


Identifier: Type
!: : Will definitely receive a value during runtime
?: :
