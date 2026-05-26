project = Project.create!(
  name: "CodeHandoff Notes",
  description: "A Rails application for creating handoff documents from repository information."
)

repository = project.repositories.create!(
  name: "code-handoff-notes",
  url: "https://github.com/yakutaneyama/code-handoff-notes",
  description: "A portfolio application built with Ruby on Rails to support software project handoff."
)

repository.create_handoff_document!(
  overview: "This application helps developers organize repository information and generate handoff documents.",
  features: "- Project management\n- Repository registration\n- Handoff document generation\n- Markdown preview",
  database_notes: "Project has many repositories. Repository has one handoff document.",
  environment_notes: "DATABASE_URL is required in production.",
  setup_notes: "Run bundle install, rails db:create, rails db:migrate, and rails server.",
  operation_notes: "Deploy to AWS. Use PostgreSQL for production.",
  risks: "GitHub API integration is not implemented yet."
)