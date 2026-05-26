class RepositoriesController < ApplicationController
  before_action :set_project, only: [:new, :create]
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  def show
    @handoff_document = @repository.handoff_document
  end

  def new
    @repository = @project.repositories.new
  end

  def create
    @repository = @project.repositories.new(repository_params)

    if @repository.save
      redirect_to @repository, notice: "Repository was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @repository.update(repository_params)
      redirect_to @repository, notice: "Repository was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = @repository.project
    @repository.destroy
    redirect_to project_path(project), notice: "Repository was successfully deleted."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_repository
    @repository = Repository.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:name, :url, :description)
  end
end