require "httparty"

class GithubRepositoryFetcher
  include HTTParty

  base_uri "https://api.github.com"

  def initialize(repository)
    @repository = repository
  end

  def call
    response = self.class.get(
      "/repos/#{@repository.github_owner}/#{@repository.github_repo}",
      headers: headers
    )

    unless response.success?
      return failure_result(
        "GitHub API error: #{response.code} #{response.message} - #{response.body}"
      )
    end

    {
      success: true,
      full_name: response["full_name"],
      description: response["description"],
      language: response["language"],
      stars: response["stargazers_count"],
      default_branch: response["default_branch"],
      updated_at: response["updated_at"],
      html_url: response["html_url"]
    }
  rescue StandardError => e
    failure_result("#{e.class}: #{e.message}")
  end

  private

  def headers
    token = ENV["GITHUB_TOKEN"]

    base_headers = {
      "Accept" => "application/vnd.github+json",
      "User-Agent" => "CodeHandoffNotes"
    }

    return base_headers if token.blank?

    base_headers.merge("Authorization" => "Bearer #{token}")
  end

  def failure_result(message)
    {
      success: false,
      error: message
    }
  end
end