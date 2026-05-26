# CodeHandoff Notes

CodeHandoff Notes is a Ruby on Rails application for creating software handoff documents from repository information.

## Why I Built This

I built this application because I am interested in solving problems around software handoff, code understanding, and documentation.

In software development, important knowledge often stays inside the heads of individual developers. This creates problems when a project is handed over, maintained, or improved by another developer.

This application is my attempt to understand that problem and build a small but working solution with Ruby on Rails.

## Concept

The core idea is simple:

1. Register a software project
2. Register its GitHub repository
3. Write structured notes about the system
4. Generate a handoff document in Markdown format

This application does not try to solve everything at once. Instead, it focuses on the basic workflow of turning system knowledge into a document that another developer can understand.

## Features

- Create and manage projects
- Register GitHub repository URLs
- Create handoff documents for repositories
- Organize system information into structured sections
- Generate Markdown handoff documents
- View generated documents in the browser

## Tech Stack

- Ruby
- Ruby on Rails
- PostgreSQL
- HTML / ERB
- Git / GitHub

## Database Design

```text
Project
  has_many :repositories

Repository
  belongs_to :project
  has_one :handoff_document

HandoffDocument
  belongs_to :repository