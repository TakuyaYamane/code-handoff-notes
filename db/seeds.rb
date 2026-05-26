project = Project.find_or_create_by!(
  name: "CodeHandoff Notes"
) do |p|
  p.description = "A Rails application for creating software handoff documents from repository information."
end

repository = project.repositories.find_or_create_by!(
  url: "https://github.com/TakuyaYamane/code-handoff-notes"
) do |r|
  r.name = "code-handoff-notes"
  r.description = "A portfolio application built with Ruby on Rails to support software project handoff."
end

repository.handoff_document || repository.create_handoff_document!(
  overview: "This application helps developers organize repository information and generate handoff documents.",
  features: "- Project management\n- Repository registration\n- Handoff document generation\n- Markdown preview",
  database_notes: "Project has many repositories. Repository has one handoff document.",
  environment_notes: "DATABASE_URL is required in production.",
  setup_notes: "Run bundle install, bin/rails db:create, bin/rails db:migrate, bin/rails db:seed, and bin/rails server.",
  operation_notes: "This app is currently designed for local development. In production, it should be deployed with PostgreSQL and environment variables.",
  risks: "GitHub API integration, authentication, AWS deployment, and AI-generated documentation are not implemented yet."
)

puts "Seed data created successfully."