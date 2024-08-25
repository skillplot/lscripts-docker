---
layout: post
title:  "Using GitHub for Open Source Software Development"
date:   2024-08-25 15:45:00 +0530
categories: getting-started
---


## Need?

- Do you need to collaborate with a team or other open source projects?
- Do you want to publish your code for others to use and collaborate with them?
- Do you want to take control of your documentation content, course material, blog articles that you write once and publish anywhere?
- Do you want to write the book, articles, blog, course-ware, and collaborate with others?
- Do you want to automate the software development and content publishing?
- Do you want simple, less maintenance overhead, and free hosting web site?

## What is GitHub?

- **GitHub** is a **Git** repository hosting service, but it adds many of its own features.
- At the heart of GitHub is Git, an open source project started by Linux creator Linus Torvalds.  
  [GitHub Help](https://help.github.com/en/github)

## What is Git?

- **Version control system**
- Git is a mature, actively maintained **open source project** originally **developed in 2005** by Linus Torvalds, the famous creator of the Linux operating system kernel.
- A staggering number of software projects rely on Git for version control, **including commercial projects as well as open source**.
- **Distributed architecture**, Git is an example of a DVCS (hence, **Distributed Version Control System**).

## Key Features

3 Key Flagship features: **Fork**, **Pull Request**, **Merge**

- **Fork / Forking** - create a copy of a repository from another user's account to your account.
  - This enables you to take a project that you don't have write access to and modify it under your own account.
- **Pull Request** - allows you to share the changes for the forked repo by sending the notification to the parent repo/owner.
- **Merge Request** - allows taking the change request from other users to their repo.
  - The original owner of the parent repo can then, with a click of a button, merge the changes you requested from the forked repo into their original repo.

### Before GitHub: If you wanted to contribute to an open source project

- You had to manually download the project's source code.
- Make your changes locally.
- Create a list of changes called a "patch."
- And then email the patch to the project's maintainer.
- The maintainer would then have to evaluate this patch, possibly sent by a total stranger, and decide whether to merge the changes.

- The network effect starts to play a role in GitHub:
  - When you submit a pull request, the project’s maintainer can see your profile, which includes all of your contributions on GitHub. If your patch is accepted, you get credit on the original site, and it shows up in your profile.
  - It’s like a resume that helps the maintainer determine your reputation.
  - Publicly discussed.

## Other Salient Features and Services

- ML-based code scanner, security
- Other offers and services for individuals, organizations, and enterprise
- Individual repos
- Organization repos
- Private and public repos
- Collaborators, transfer ownerships
- DevOps - Actions - automation, triggers
- Content Publishing - books in markdown, AsciiDoc formats, LMS
- Issue/Bug Tracker, inbuilt wiki, statistics/insight - lines of code, total commits, etc.
- Static Website hosting directly from text files for individual or repo specific
- Web-hooks for auto-updating repo - can be used as LMS

## 5C's - How GitHub Helps in Open Source Software Project Development

- **Contribution** to other Open Source projects.
- **Collaboration** with others for your Open Source project; more than one person can be the code owner.
- **Credit** to individual contributors, appears on the project contributor list.
- **Communication** - issues, documentation, wikis, project website.
- **Catalog** - insights, stats - code frequency, traffic, contributors, commits, dependency graph, forks, network.

## Alternatives

- [Bitbucket](https://bitbucket.org/) is an alternative to GitHub.
- [Mercurial (hg)](https://www.mercurial-scm.org/) is an alternative to `git`.

## Getting Started with GitHub

GitHub documentation is the best resource to follow the instructions step-by-step: [Getting Started with GitHub](https://help.github.com/en/github/getting-started-with-github).  
Following instructions gives you a quick summary; for details, follow the GitHub documentation.

## Install `git` On Your System

### For Windows, there are a couple of options:

1. Install [Git for Windows from gitforwindows.org](https://gitforwindows.org/). This installs git and other Linux-like utilities, text editors. It is around `~45MB`.
   ```sh
   git --version
