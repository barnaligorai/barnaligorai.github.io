---
title: About This Site
date: 2022-08-27T17:52:48+05:30
featured_image: ../images/tech_cover.jpeg
description: Now blogging is a piece of cake.
draft: true
tags:
  - Tech
  - Hugo
---
# HUGO
Hi. This is **Barnali Gorai**. 
This is my first post on this site.

I have created this site using hugo.
Started with the **Ananke** theme.
Hosted the site on *GitHub*.

Hugo is super easy to start with. Because there is no database, no plugins requiring any permissions.


## Installation

```sh
brew install hugo
```


## Create a new site

```sh
hugo new site site-name
```

To change the site open config.toml and edit settings such as the blog's title, copyright, name, your social network links, etc.


## Add a theme

Set a theme, with Hugo, you can either theme your blog yourself or use one of the beautiful, ready-made themes. I chose Ananke because it is simple. Download the theme from GitHub and add it to your site’s themes directory.

```sh
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
```

Add the theme to your config.toml

```sh
echo theme = \"ananke\" >> config.toml
```


## Create a new post

```sh
hugo new posts/post-name.md
```

This will create a new md file in ./content/posts/ which you can edit and add your content there in md format.


## Start the server

```sh
hugo server -D
```

Start the Hugo server with drafts enabled.
By default hugo serves on : **http://localhost:1313**


## Build static pages

```sh
hugo -D
```
  - Output will be in ./public/ directory by default.
  - Use -d/--destination flag to change it, or set publishdir in the config file.
  - Use -D flag to publish drafts.

If don't want to publish draft, use 

```sh
hugo
```

Drafts do not get deployed.
Once you finish a post, update the header of the post to say draft: false.

***
